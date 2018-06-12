function part_seg = segment_parts_pure(fore_depth, image_coords,...
    joint_conn, is_line, betas, ratios)
% Segments a depth image using only the Random Walker algorithm.
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
%   ratios : vector
%       n_connections x 1
%       Element i is ratio for connection i
%       Ratio of length A to whole length of path A -> B
%
% Outputs
%
%   part_seg : matrix
%       n_rows x n_cols
%       Final segmentation of body parts


%% Process parameters

foreground = ~isnan(fore_depth);

% Partial application
g = @(beta, A, B)  @(A, B) exp(-beta * normalize((A - B).^2));

beta_base = betas(2);

g_base = g(beta_base);

I_size = size(fore_depth);

fore_node_nums = enumerate_logic_matrix(foreground);
fore_pixels = find(foreground);

struct_elem_grid = cell_neighbourhood(1, 'Neumann', false);

%% Grid graph

% Base graph structure
[N, C] = grid_adj_list_struct(fore_node_nums, struct_elem_grid);

% Values of base graph nodes
V = node_values(fore_depth, fore_node_nums);

%% Seed nodes and labels

[seed_pixels, seed_labels] = line_seeds(fore_node_nums, image_coords,...
    joint_conn, is_line, ratios);

[seed_pixels, seed_labels] = remove_nan_elems(seed_pixels, seed_labels);
seed_nodes = fore_node_nums(seed_pixels);

% Ensure there are no nan elements, since this will cause Random Walker to
% fail
[seed_nodes, seed_labels] = remove_nan_elems(seed_nodes, seed_labels);



%% Final segmentation

% % Convert adjacency list to a list of edges
% [edges, weights] = adj_list_to_edges(N, W, C);

% Convert to edge list
edges = adj_list_to_edges(N, nan(size(N)), C);
weights = weight_edges(edges, V, g_base);

% Ensure there are no seed nodes with nans
[seed_nodes, seed_labels] = remove_nan_elems(seed_nodes, seed_labels);

if max(seed_nodes) > max(edges(:))
    % The random walk algorithm will fail
    part_seg = nan;
    return
end

% Assign labels to nodes with Random Walker
node_labels = random_walk_graph(seed_nodes, seed_labels,...
    edges, weights);

% Convert node labels to pixel labels to get final image
part_seg = node_vals_to_img(I_size, fore_pixels, node_labels);


end