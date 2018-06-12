function cost = arm_blob_cost(I_grad, arm_blob, ...
    struct_elem, func)
% Cost function for arm segmentation.
%
% Inputs
%
%   I_grad : matrix
%       n_rows x n_cols
%       Gradient image
%
%   arm_blob : logical matrix
%       n_rows x n_cols
%       Binary image of arm segment
%
%   struct_elem : logical matrix
%       n_rows_struct x n_rows_struct
%       Structuring element (square matrix)
%
%   func : function_handle
%       Function for defining the cost (e.g., @nanmean)
%
% Outputs
%
%   cost : scalar
%       Cost of arm segment

eroded_1 = imerode(arm_blob, struct_elem);
eroded_2 = imerode(~arm_blob, struct_elem);

eroded_union = eroded_1 | eroded_2;

cost = func(I_grad(eroded_union));

end
