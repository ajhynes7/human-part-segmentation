function [N, W, C] = add_edges(N, W, C, nodes_A, nodes_B, weights)
% Adds an undirected edge from each node in set A to each node in set B.
%
% Inputs
%
%   N : matrix
%       n_nodes x max_degree
%       Each row i contains the neighbours of node i
%       max_degree is the max number of neighbours
%
%   W : matrix
%       n_nodes x max_degree
%       Each row i contains the weights of edges to neighbours of node i
%
%   C : vector
%       n_nodes x 1
%       Each row i contains the count of neighbours of node i
%
%   nodes_A : vector
%       n_edge_nodes x 1
%       Set A of nodes
%
%   nodes_B : vector
%       n_edge_nodes x 1
%       Set B of nodes
%
%   weights : vector
%       n_edge_nodes x 1
%       Weight of each added edge
%
% Outputs
%
%   N, W, C with added edges

n_edge_nodes = numel(nodes_A);

for i = 1:n_edge_nodes

    w = weights(i);

    % Add edge from A to B and from B to A
    [N, W, C] = add_edge(N, W, C, nodes_A(i), nodes_B(i), w);
    [N, W, C] = add_edge(N, W, C, nodes_B(i), nodes_A(i), w);
end

end
