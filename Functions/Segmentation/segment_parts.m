function [part_seg, arm_seg, connect_pix, is_valid] = ...
    segment_parts(fore_depth, image_coords, joint_conn, is_line,...
    betas, arm_parts, ratios, r)
% Segments a depth image using a layered graph structure.
%
% Inputs
%
%   fore_depth : matrix
%       n_rows x n_cols
%       Depth values for foreground of image
%
%   image_coords : matrix
%       n_parts x 2
%       Row i is the (x, y) image coordinates for body part i
%
%   joint_conn : matrix
%       n_connections x 2
%       Row i indicates a connection from joint A to B
%
%   is_line : logical vector
%       n_connections x 1
%       Element i is true iff a line will be drawn for joint connection i
%
%   betas : vector
%       1 x 2
%       Beta values for Random Walker
%       [beta_arm, beta_base]
%
%   arm_parts : matrix
%       2 x n_arm_parts
%       Row i is list of arm parts for body side i (R/L)
%       First column must be hand
%
%   ratios : vector
%       n_connections x 1
%       Element i is ratio for connection i
%       Ratio of length A to whole length of path A -> B
%
%   r : scalar
%       Radius (bandwidth) for mean shift
%
% Outputs
%
%   part_seg : matrix
%       n_rows x n_cols
%       Final segmentation of body parts
%
%   arm_seg : matrix
%       n_rows x n_cols
%       Segmentation of arms
%
%   connect_pix : matrix
%       n_rows x n_cols
%       Pixels used to connect graph layers
%
%   is_valid : vector
%       1 x 2
%       Element i is true iff arm i is valid


%% Process parameters

foreground = ~isnan(fore_depth);
n_fore_pixels = sum(foreground(:));

% Partial application
g = @(beta, A, B)  @(A, B) exp(-beta * normalize((A - B).^2));

beta_arm = betas(1);
beta_base = betas(2);

g_arm  = g(beta_arm);
g_base = g(beta_base);

n_parts = size(image_coords, 1);
I_size = size(fore_depth);

fore_node_nums = enumerate_logic_matrix(foreground);
fore_pixels = find(foreground);

struct_elem_grid = cell_neighbourhood(1, 'Neumann', false);
struct_elem_full = cell_neighbourhood(1, 'Neumann', true);

%% Grid graph

% Base graph structure
[N_b, C_b] = grid_adj_list_struct(fore_node_nums, struct_elem_grid);

% Values of base graph nodes
V_b = node_values(fore_depth, fore_node_nums);

% Convert to edge list
edges_b = adj_list_to_edges(N_b, nan(size(N_b)), C_b);
weights_arm  = weight_edges(edges_b, V_b, g_arm);


%% Arm probability matrix

% Determine hand nodes
hand_nums       = arm_parts(:, 1);
hand_pos        = image_coords(hand_nums, :);

if any(isnan(hand_pos))
    % A hand position is missing
    [part_seg, arm_seg, connect_pix, is_valid] = deal(nan);
    return
end


hand_lin_idx    = sub2ind(I_size, hand_pos(:, 2), hand_pos(:, 1));
hand_nodes      = fore_node_nums(hand_lin_idx);

% Probabilites for pixels in arm blob
[R_prob_mat, L_prob_mat] = ...
    arm_probability(I_size, edges_b, weights_arm, fore_pixels, hand_nodes);


%% Arm segmentation

[R_blob, R_gradient] = segment_arm(foreground, R_prob_mat, struct_elem_full, r);
[L_blob, L_gradient] = segment_arm(foreground, L_prob_mat, struct_elem_full, r);

% Remove any pixel conflicts
[R_blob, L_blob] = resolve_blob_conflict(R_blob, L_blob,...
    R_prob_mat, L_prob_mat);

% Arm segmentation image
arm_seg = double(foreground);
arm_seg(R_blob) = 2;
arm_seg(L_blob) = 3;


%% Validation of arm segments

[R_is_valid, R_blob] = validate_arm_blob(fore_depth, R_blob, R_prob_mat,...
    struct_elem_full);

[L_is_valid, L_blob] = validate_arm_blob(fore_depth, L_blob, L_prob_mat,...
    struct_elem_full);

is_valid = [R_is_valid, L_is_valid];  


%% Layered grid graph

% Concatenate the 3 binary matrices
binary_layers = cat(3, foreground, R_blob, L_blob);
all_node_nums = enumerate_logic_matrix(binary_layers);
node_pixels = nodes_to_pix(binary_layers);

% Create graph of arm segments
[N_upper, C_upper] = grid_adj_list_struct(all_node_nums(:, :, 2:3),...
    struct_elem_grid);

% Combine graph layers
N = N_upper;
N(1:n_fore_pixels, :) = N_b;

C = C_upper;
C(1:n_fore_pixels, :) = C_b;

% Interpolate pixel values on base blob
V = layered_graph_values(fore_depth, binary_layers);

% Assign weights to edges in layered graph
W = weight_adj_list(N, C, V, g_base);


%% Connect graph layers

% Pixels used to connect layers
R_connect_pix = connecting_pixels(foreground, R_blob, R_gradient,...
    struct_elem_full, 0.05);

L_connect_pix = connecting_pixels(foreground, L_blob, L_gradient,...
    struct_elem_full, 0.05);

% Right connect pixels get val of 1, left pixels get val of 2
connect_pix = double(R_connect_pix);
connect_pix(L_connect_pix) = 2;

% Add edges between layers
[N, W, C] = connect_layers(N, W, C, all_node_nums, connect_pix, 1);
[N, W, C] = connect_layers(N, W, C, all_node_nums, connect_pix, 2);


%% Assign body parts to layers

% Initally assume all parts are on base layer
part_layers = ones(n_parts, 1);

% Update part layers for left and right arm parts
part_layers = update_part_layers(part_layers, image_coords, arm_parts,...
    binary_layers, is_valid, 1);

part_layers = update_part_layers(part_layers, image_coords, arm_parts,...
    binary_layers, is_valid, 2);


%% Seed nodes and labels

[seed_pixels, seed_labels] = line_seeds(fore_node_nums, image_coords,...
    joint_conn, is_line, ratios);

% Ensure there are no nan elements, since this will cause Random Walker to
% fail
[seed_pixels, seed_labels] = remove_nan_elems(seed_pixels, seed_labels);


% Convert seed pixels to layered graph nodes
n_seed_pix = numel(seed_pixels);
seed_nodes = nan(n_seed_pix, 1);

for i = 1:n_seed_pix
    
    pixel_idx = seed_pixels(i);
    pixel_label = seed_labels(i);
    
    pixel_layer = part_layers(pixel_label);
    node_nums = all_node_nums(:, :, pixel_layer);
    
    seed_nodes(i) = node_nums(pixel_idx);
end


%% Final segmentation

% Convert adjacency list to a list of edges
[edges, weights] = adj_list_to_edges(N, W, C);

% Ensure there are no seed nodes with nans
[seed_nodes, seed_labels] = remove_nan_elems(seed_nodes, seed_labels);

if max(seed_nodes) > max(edges(:))
    % The random walk algorithm will fail
    [part_seg, arm_seg, connect_pix, is_valid] = deal(nan);
    return
end

% Assign labels to nodes with Random Walker
node_labels = random_walk_graph(seed_nodes, seed_labels,...
    edges, weights);

% Convert node labels to pixel labels to get final image
part_seg = node_vals_to_img(I_size, node_pixels, node_labels);


end