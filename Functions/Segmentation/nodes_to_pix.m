function node_pixels = nodes_to_pix(binary_layers)
% Associates nodes in a layered grid graph to pixels in an image.
%
% Inputs
%
%   binary_layers : matrix
%       n_rows x n_cols x n_layers
%       Used to represent a layered grid graph
%       A true element indicates a node in the grid graph
%
% Outputs
%
%   node_pixels : vector
%       n_nodes x 1
%       Element i is the linear index for the pixel corresponding to node i

[n_rows, n_cols, n_layers] = size(binary_layers);
n_pix = n_rows * n_cols;

n_nodes = sum(binary_layers(:));
node_pixels = nan(n_nodes, 1);

node = 0;
for layer = 1:n_layers
    
    % Binary matrix for this layer
    B = binary_layers(:, :, layer);
    
    for i = 1:n_pix
        if B(i)
            % A node has been found. Record the pixel index
            node = node + 1;
            node_pixels(node) = i;
        end
    end
end

end

