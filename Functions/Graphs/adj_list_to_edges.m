function [edges, weights] = adj_list_to_edges(N, W, C)
% Converts adjacency list into a list of edges and weights.
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
% Outputs
%
%   edges : matrix
%       n_edges x 2
%       Each row is an edge A -> B
%       Col 1 is node A, col 2 is node B
%
%   weights : vector
%       n_edges x 1
%       Element i is weight of edge i

n_nodes = size(N, 1);
n_edges = sum(C);

edges = nan(n_edges, 2);
weights = nan(n_edges, 1);

count = 0;
for i = 1:n_nodes
    n_neigh = C(i);

    for ii = 1:n_neigh

        node = i;
        neighbour = N(i, ii);

        count = count + 1;

        edges(count, :) = [node, neighbour];
        weights(count) = W(i, ii);
    end
end

end
