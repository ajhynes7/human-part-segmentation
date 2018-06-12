function [mean_pos, distances] = gaussian_kernel_shift(points, mean_pos, r)
% Shifts a mean position using a Gaussian kernel.
% Used in the mean shift algorithm.
%
% Inputs
%
%   points : matrix
%       n_points x n_dimensions
%       Input points to mean shift algorithm
%
%   mean_pos : vector
%       1 x n_dimensions
%       Initial mean position
%
%   r : scalar
%       Radius (bandwidth) parameter for mean shift
%       Sigma (standard deviation) is set to this value
%
% Outputs
%
%   mean_pos : vector
%       1 x n_dimensions
%       New mean position
%
%   distances : vector
%       n_points x 1
%       Distance from all points to initial mean position

distances = pdist2(points, mean_pos);

% Define Gaussian kernel
G = @(x, mu, s) 1 / sqrt(2*pi * s^2) * exp(- (x - mu).^2 / (2 * s^2));

% Apply weights with Gaussian
% Sigma (standard deviation) is set to the radius parameter
% Mu (mean) is set to zero
masses = G(distances, 0, r);

mean_pos = centre_of_mass(points, masses);

end

