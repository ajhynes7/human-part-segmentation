function V = node_values(I, node_nums)
% Creates a list of values for each node in a grid graph.
% The grid graph represents an image with pixel values.
%
% Inputs
%
%   I : matrix
%       n_rows x n_cols
%       Image that is being represented as a grid graph
%
%   node_nums : matrix
%       n_rows x n_cols
%       Lists the number for each node in the grid graph
%       Values of NaN indicate a pixel in the image that is not a node
%
% Outputs
%
%   V : vector
%       n_nodes x 1
%       Value of each node (e.g., from an image)


[n_rows, n_cols] = size(I);

n_nodes = max(node_nums(:));

V = nan(n_nodes, 1);
is_node_num = ~isnan(node_nums);

for i = 1:n_rows
    for j = 1:n_cols
        if is_node_num(i, j)
             node = node_nums(i, j);
             V(node) = I(i, j);
        end
    end
end

end

