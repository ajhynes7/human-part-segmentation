function [arm_blob, I_grad] = segment_arm(foreground, P, struct_elem, r)
% Segments arm by minimizing a cost function.
%
% Inputs
%
%   foreground : logical matrix
%       n_rows x n_cols
%       Binary image for foreground
%
%   P : matrix
%       n_rows x n_cols
%       Probability matrix for arm
%
%   struct_elem : logical matrix
%       n_rows_struct x n_rows_struct
%       Structuring element (square matrix)
%
%   r : scalar
%       Radius (bandwidth) for mean shift
%
% Outputs
%
%   arm_blob : logical matrix
%       n_rows x n_cols
%       Binary image of arm segment
%
%   I_grad : matrix
%       n_rows x n_cols
%       Gradient image for arm


%% Cluster probability values

vals = P(foreground);

samples = sample_sorted(vals, 100);

[~, centroids, k] = mean_shift(samples, @gaussian_kernel_shift, r, 0.001);
[~, sort_index] = sort(centroids, 'descend');

% Image with cluster labels
I_seg = segment_by_cluster(P, centroids);
I_seg(~foreground) = nan;

%% Determine best arm blob

P(~foreground) = nan;
I_grad = imgradient(P);

min_cost = inf;

for i = 1:k
    
    centroid_nums = sort_index(1:i);
    current_blob = equal_to_any(I_seg, centroid_nums);

    cost = arm_blob_cost(I_grad, current_blob,...
        struct_elem, @nanmean);

    if cost < min_cost
        min_cost = cost;
        arm_blob = current_blob;
    end
end

end

