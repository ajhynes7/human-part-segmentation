function weights = weight_edges(edges, V, weight_func)
% Lists edges from nodes in set A to nodes in set B.
% Used for graph representations of images.
%
% Inputs
%
%   edges : matrix
%       n_edges x 2
%       Each row is an edge A -> B
%       Col 1 is node A, col 2 is node B
%
%   V : vector
%       n_nodes x 1
%       Value of each node (e.g., from an image)
%
%   weight_func : function_handle
%       Weight function of the form f(A, B) -> w
%
% Outputs
%
%   weights : vector
%       n_edges x 1
%       Element i is weight of edge i

n_edges = size(edges, 1);

[vals_A, vals_B] = deal(nan(n_edges, 1));

for i = 1:n_edges
    
    node_A = edges(i, 1);
    node_B = edges(i, 2);
    
    vals_A(i) = V(node_A);
    vals_B(i) = V(node_B);
end

weights = weight_func(vals_A, vals_B);

end

