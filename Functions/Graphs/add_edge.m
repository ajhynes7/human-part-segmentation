function [N, W, C] = add_edge(N, W, C, node_A, node_B, weight)
% Adds an edge between two nodes.
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
%   node_A : scalar
%       Number for node A
%
%   node_B : scalar
%       Number for node B
%
%   weight : scalar
%       Weight of new edge
%
% Outputs
%
%   N, W, C with added edge

max_degree = size(N, 2);

% Add node to adjacency list
N(node_A, C(node_A) + 1) = node_B;

% Assign weight to new edge
W(node_A, C(node_A) + 1) = weight;

% Increase edge count
C(node_A) = C(node_A) + 1;

if C(node_A) > max_degree
    % The number of neighbours now exceeds the original connectivity of the
    % graph, creating many zero values
    % Replace all zero values with nan
    index = N==0;
    [N(index), W(index)]  = deal(nan);
end

end

