function [R_prob_mat, L_prob_mat] = ...
    arm_probability(I_size, edges, weights, node_pixels, hand_nodes)
% Finds probability matrix for each arm using Random walker.
%
% Dummy node added to graph to increase variance in probability values.
%
% Inputs
%
%   I_size : vector
%       1 x 2
%       Image size: [n_rows, n_cols]
%
%   edges : matrix
%       n_edges x 2
%       Each row is an edge A -> B
%       Col 1 is node A, col 2 is node B
%
%   weights : vector
%       n_edges x 1
%       Element i is weight of edge i
%
%   node_pixels : vector
%       n_nodes x 1
%       Element i is the linear index for the pixel corresponding to node i
%
%   hand_nodes : vector
%       2 x 1
%       Node number for right and left hands
%
% Outputs
%
%   R_prob_mat, L_prob_mat : matrix
%       n_rows x n_cols
%       Probability matrix for right and left arm

n_nodes = max(edges(:));
new_node = n_nodes + 1;

w = 1e-3; % Small weight for each edge to dummy node

new_edges = [new_node * ones(n_nodes, 1), (1:n_nodes)'];
new_weights = w * ones(n_nodes, 1);

edges       = [edges; new_edges];
weights     = [weights; new_weights];
seed_nodes  = [hand_nodes; new_node];

n_seeds = numel(seed_nodes);
[~, probabilities] = random_walk_graph(seed_nodes, 1:n_seeds, edges, weights);

R_prob_mat = node_vals_to_img(I_size, node_pixels, probabilities(:, 1));
L_prob_mat = node_vals_to_img(I_size, node_pixels, probabilities(:, 2));

end
