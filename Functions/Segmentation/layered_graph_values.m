function V = layered_graph_values(fore_depth, binary_layers)
% Assigns each node in the layered graph with a value 
% using the depth image.
%
% Interpolates depth values on the base layer of the graph behind the
% segmented arms.
%
% Inputs
%
%   fore_depth : matrix
%       n_rows x n_cols
%       Depth image for the foreground
%
%   binary_layers : logical matrix
%       n_rows x n_cols x 3
%       Each matrix layer i is a binary image of the pixels 
%       represented by graph layer i
%
% Outputs
%
%   V : vector
%       n_nodes x 1
%       Value of each node in the graph

R_blob = binary_layers(:, :, 2);
L_blob = binary_layers(:, :, 3);

[R_depth, L_depth] = deal(fore_depth);
R_depth(~R_blob) = nan;
L_depth(~L_blob) = nan;

med = nanmedian(fore_depth(:));
non_occluded = replace(fore_depth, nan, med);
interpolated = regionfill(non_occluded, L_blob | R_blob);

layered_depth = cat(3, interpolated, R_depth, L_depth);

V = layered_depth(binary_layers);

end

