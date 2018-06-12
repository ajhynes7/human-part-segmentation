function I = node_vals_to_img(I_size, node_pixels, node_values)
% Creates an image by assigning node values to pixels.
%
% Inputs
%
%   I_size : vector
%       1 x 2
%       Image size: [n_rows, n_cols]
%
%   node_pixels : vector
%       n_nodes x 1
%       Element i is the linear index for the pixel corresponding to node i
%
%   node_values : vector
%       n_nodes x 1
%       Element i is value of node i
%
% Outputs
%
%   I : matrix
%       n_row x n_cols
%       Final image

I = zeros(I_size);
n_nodes = numel(node_pixels);

for node = 1:n_nodes
    
    pixel = node_pixels(node);
    value = node_values(node);
    
    I(pixel) = value;
end

end

