function [N, C] = grid_adj_list_struct(node_nums, struct_elem)
% Constructs adjacency list of a grid graph using a structuring element.
% The grid graph is used to represent an image.
%
% Inputs
%
%   node_nums : matrix
%       n_rows x n_cols x n_layers
%       Lists the number for each node in the grid graph
%       Values of NaN indicate a pixel in the image that is not a node
%       Layers of the 3d matrix correspond to layers in the grid graph
%
%   struct_elem : logical matrix
%       n_rows_struct x n_rows_struct
%       Structuring element (square matrix)
%
% Outputs
%
%   N : matrix
%       n_nodes x max_degree
%       Each row i contains the neighbours of node i
%       max_degree is the max number of neighbours
%
%   C : vector
%       n_nodes x 1
%       Each row i contains the count of neighbours of node i

n_nodes = max(node_nums(:));

if isnan(n_nodes)
    % There are no nodes in this graph
    [N, C] = deal([]);
    return
end

binary_layers = ~isnan(node_nums);

[n_rows, n_cols, n_layers] = size(binary_layers);
n_elem = numel(binary_layers);

pad_size = get_pad_size(struct_elem);
x = pad_size(2);
y = pad_size(1);

padded_binary = padarray(binary_layers, pad_size, false);
padded_node_nums = padarray(node_nums, pad_size, nan);

% Max number of edges connected to a node
max_degree = sum(struct_elem(:) > 0);

N = nan(n_nodes, max_degree);
C = zeros(n_nodes, 1);

[rows, cols, layers] = ind2sub([n_rows, n_cols, n_layers], 1:n_elem);

rows = rows + y;
cols = cols + x;


for i = 1:n_elem

    if binary_layers(i)
        node = node_nums(i);

        r = rows(i);
        c = cols(i);
        layer = layers(i);

        row_index = r - y : r + y;
        col_index = c - x : c + x;

        binary_portion = padded_binary(row_index, col_index, layer);
        node_num_portion = padded_node_nums(row_index, col_index, layer);

        intersection = struct_elem & binary_portion;
        neighbours = node_num_portion(intersection);

        n_neigh = numel(neighbours);
        N(node, 1:n_neigh) = neighbours;
        C(node) = n_neigh;
    end
end


end
