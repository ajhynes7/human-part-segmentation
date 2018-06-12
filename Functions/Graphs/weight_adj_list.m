function W = weight_adj_list(N, C, V, weight_func)
% Computes weights of edges between nodes in a grid graph.
% The grid graph is used to represent an image.
% The image pixel values are used in the weight calculation.
%
% Inputs
%
%   N : matrix
%       n_nodes x max_degree
%       Each row i contains the neighbours of node i
%       max_degree is the max number of neighbours
%
%   C : vector
%       n_nodes x 1
%       Each row i contains the count of neighbours of node i
%
%   V : vector
%       n_nodes x 1
%       Value of each node (e.g., from an image)
%   
%   weight_func : function_handle
%       Function with two inputs, that computes a weight from two adjacent
%       node values
%
% Outputs
%
%   W : matrix
%       n_nodes x max_degree
%       Each row i contains the weights of edges to neighbours of node i

[n_nodes, max_degree] = size(N);

[node_vals, neighbour_vals] = deal(nan(n_nodes, max_degree));


for node = 1:n_nodes
    
    node_value = V(node, :);
    n_neighbours = C(node);
    
    for ii = 1:n_neighbours
        
        neighbour = N(node, ii);
        neighbour_value = V(neighbour, :);
        
        node_vals(node, ii) = node_value;
        neighbour_vals(node, ii) = neighbour_value;
    end
    
end

W = weight_func(node_vals, neighbour_vals);

end

