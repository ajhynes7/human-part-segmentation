function [N, W, C] = connect_layers(N, W, C, all_node_nums,...
    connect_pix, side)
% Inserts edges in the graph that connect different graph layers.  
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
%   all_node_nums : matrix
%       n_rows x n_cols x 3
%       Node numbers for all 3 layers of the graph (base layer + both arms)
%       Lists the number for each node in the grid graph
%       Values of NaN indicate a pixel in the image that is not a node
%
%   connect_pix : matrix
%       n_rows x n_cols
%       Pixel (i, j) has value of 0, 1, or 2:
%           0 - Not a connect pixel (connects graph layers)
%           1 - Right connect pixel
%           2 - Left connect pixel
%
%   side : scalar
%       Side of the body being connected (1: right, 2: left)
%
% Outputs
%
%   N, W, C after connecting graph layers

X_connect_pix = connect_pix == side;

B_node_nums = all_node_nums(:, :, 1);
X_node_nums = all_node_nums(:, :, side + 1);

X_connect_nodes = X_node_nums(X_connect_pix);
X_base_nodes   = B_node_nums(X_connect_pix);

% Add same edges between graph layers as those added on original graph
if ~any(isnan([X_connect_nodes; X_base_nodes]))
    
    % Add edges from upper blob to base blob, and vice versa
    weights = ones(numel(X_base_nodes), 1);
    [N, W, C] = add_edges(N, W, C, X_connect_nodes, X_base_nodes, weights);
end


end

