function centroid = binary_centroid(B)
% Calculates centroid of binary image.
% Intended to be faster than MATLAB built-in function regionprops.
%
% Inputs
%
%   B : logical matrix
%       n_rows x n_cols
%       Binary image
%
% Outputs
%
%   centroid : vector
%       1 x 2
%       (x, y) coordinates of centroid
%       Image coordinates, i.e. origin in top left corner

[n_rows, n_cols] = size(B);

x_coords = 1:n_cols;
y_coords = (1:n_rows)';

x_mass_counts = sum(B, 1);
y_mass_counts = sum(B, 2);

x_mean = sum(x_coords .* x_mass_counts) / sum(x_mass_counts);
y_mean = sum(y_coords .* y_mass_counts) / sum(y_mass_counts);

centroid = [x_mean, y_mean];

end
