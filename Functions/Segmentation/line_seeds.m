function [seed_pixels, seed_labels] =...
    line_seeds(node_nums, image_coords, joint_conn, is_line, ratios)
% Determines seed nodes and labels by drawing lines between body parts.
%
% Inputs
%
%   node_nums : matrix
%       n_rows x n_cols
%       Lists the number for each node in the grid graph
%       Values of NaN indicate a pixel in the image that is not a node
%
%   image_coords : matrix
%       n_parts x 2
%       Row i is the (x, y) image coordinates for body joint i
%
%   joint_conn : matrix
%       n_connections x 2
%       Row i indicates a connection from joint A to B
%
%   is_line : logical vector
%       n_connections x 1
%       Element i is true iff a line will be drawn for joint connection i
%
%   ratios : vector
%       n_connections x 1
%       Element i is ratio for connection i
%       Ratio of length A to whole length of path A -> B
%
% Outputs
%
%   seed_pixels : vector
%       n_seeds x 1
%       List of pixels that are seeds for image segmentation
%
%   seed_labels : vector
%       n_seeds x 1
%       Element i is label of seed pixel i

I_size = size(node_nums);
n_conn = size(joint_conn, 1);
n_parts = size(image_coords, 1);

[lin_idx_cell, label_cell] = deal(cell(n_conn, 1));

for i = 1:n_conn
    
    if ~is_line(i)
        continue
    end
        
    part_A = joint_conn(i, 1);
    part_B = joint_conn(i, 2);
    
    pt_A = image_coords(part_A, :);
    pt_B = image_coords(part_B, :);
    
    [x, y] = bresenham(pt_A(1), pt_A(2), pt_B(1), pt_B(2));
    
    lin_idx_cell{i} = sub2ind(I_size, y, x);
    n_pixels = numel(x);
    
    n_pix_A = round(n_pixels * ratios(i));
    n_pix_B = n_pixels - n_pix_A;
    
    labels_A = part_A * ones(n_pix_A, 1);
    labels_B = part_B * ones(n_pix_B, 1);
    
    label_cell{i} = [labels_A; labels_B];
end

seed_pixels    = cell2mat(lin_idx_cell);
seed_labels    = cell2mat(label_cell);


%% Add seed pixels at image coordinates

part_indices = sub2ind(I_size, image_coords(:, 2), image_coords(:, 1));

seed_pixels = [seed_pixels; part_indices];
seed_labels = [seed_labels; (1:n_parts)'];

end

