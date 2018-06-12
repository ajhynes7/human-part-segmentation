function [labels, centroids, k] = mean_shift(points, shift_func, r, eps)
% Executes the mean shift algorithm on a set of points using a specified
% shifting function (e.g., a Gaussian kernel).
%
% Inputs
%
%   points : matrix
%       n_points x n_dimensions
%       Input points to mean shift algorithm
%
%   shift_func : function_handle
%       Function of form f(points, mean_pos, radius)
%       Shifts an initial mean position to a new mean position
%
%   r : scalar
%       Radius (bandwidth) parameter for mean shift
%       Sigma (standard deviation) is set to this value
%
%   eps : scalar
%       Convergence criterion epsilon
%       The mean shifts until distance from previous mean position 
%       to new mean position is less than epsilon
%
% Outputs
%
%   labels : vector
%       n_points x 1
%       CLuster label of each input point
%
%   centroids : vector
%       k x n_dimensions
%       Centroid of each cluster
%
%   k : scalar
%       Number of clusters

[n_points, n_dim] = size(points);

index_matrix = false(n_points);
all_centroids = nan(n_points, n_dim);

for i = 1:n_points
    
    mean_pos = points(i, :);
    
    % Shift mean until convergence
    [mean_pos, in_radius] = shift_to_convergence(points, mean_pos,...
        shift_func, r, eps);
    
    index_matrix(i, :) = in_radius;
    all_centroids(i, :) = mean_pos;
end

[~, centroid_index, labels] = unique(index_matrix, 'rows');

centroids = all_centroids(centroid_index, :);
k = max(labels); % Number of clusters

end

