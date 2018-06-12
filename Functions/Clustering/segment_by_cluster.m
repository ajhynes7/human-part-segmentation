function I_seg = segment_by_cluster(I, centroids)
% Segments an image using cluster centroids.
% Centroids found by a clustering algorithm, e.g. k-means, mean shift.
%
% Inputs
%
%   I : matrix
%       n_rows x n_cols
%       Image to be segmented
%
%   centroids : vector
%       n_centroids x 1
%       Cluster centroids
%
% Outputs
%
%   I_seg : matrix
%       n_rows x n_cols
%       Segmented image

[n_rows, n_cols] = size(I);

centroids_3d = reshape(centroids, [1 1 numel(centroids)]);
centroid_img = repmat(centroids_3d, n_rows, n_cols);

% Assign each pixel to nearest centroid value
abs_diff = abs(bsxfun(@minus, I, centroid_img));
[~, I_seg] = min(abs_diff, [], 3);

I_seg(isnan(I)) = nan;

end

