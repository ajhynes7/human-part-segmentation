function B_connect = connecting_pixels(foreground, B_arm,...
    I_grad, struct_elem, r)
% Finds the set of pixels that are used to connect base graph layer to
% an arm layer.
%
% Inputs
%
%   foreground : logical matrix
%       n_rows x n_cols
%       Binary image for foreground
%
%   B_arm : logical matrix
%       n_rows x n_cols
%       Binary image of arm segment
%
%   I_grad : matrix
%       n_rows x n_cols
%       Gradient image for arm
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
%   B_connect : matrix
%       n_rows x n_cols
%       Binary image of pixels that connect graph layers

if ~any(B_arm)
    % Arm segment is invalid
    B_connect = false(size(B_arm));
    return
end

F_other = foreground & ~B_arm;
is_nan_gradient = isnan(I_grad);

B_inner = pixel_neighbourhood(F_other, B_arm, struct_elem);

% Only look at perimeter pixels where gradient is not nan
I_grad_inner = I_grad(B_inner & ~is_nan_gradient);

perim_pix_nums = enumerate_logic_matrix(B_inner);

% Cluster values of gradient along perimeter of arm blob
[labels, centroids] = mean_shift(I_grad_inner, ...
    @gaussian_kernel_shift, r, 0.001);

[~, min_index] = min(centroids);

% Take the lowest cluster of pixels
chosen_indices = find(labels == min_index);
B_connect = equal_to_any(perim_pix_nums, chosen_indices);

end

