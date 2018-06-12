function [X_is_valid, arm_blob] = validate_arm_blob(fore_depth,...
    arm_blob, P, struct_elem)
% Applies a series of tests to validate an arm blob (segment).
%
% An arm segment is valid if it is occluding the body.
%
% It should have significantly different depths and probabilities than 
% its neighbouring pixels.
%
% Inputs
%
%   fore_depth : matrix
%       n_rows x n_cols
%       Depth values for foreground of image
%
%   arm_blob : logical matrix
%       n_rows x n_cols
%       Binary image of arm segment
%
%   P : matrix
%       n_rows x n_cols
%       Probability matrix for arm
%
%   struct_elem : logical matrix
%       n_rows_struct x n_rows_struct
%       Structuring element (square matrix)
%
% Outputs
%
%   X_is_valid : logical
%       Marks the arm blob as valid or invalid
%
%   arm_blob : logical matrix
%       n_rows x n_cols
%       If arm blob was found to be invalid, this is now a blank image

foreground = ~isnan(fore_depth);

% Foreground outside the arm blob
F_other = foreground & ~arm_blob;

% Binary images on outer and inner perimeter of arm blob
B_inner = pixel_neighbourhood(F_other, arm_blob, struct_elem);
B_outer = pixel_neighbourhood(arm_blob, F_other, struct_elem);

% Outer and inner depths
D_inner = fore_depth(B_inner);
D_outer = fore_depth(B_outer);

% Outer and inner probabilities
P_inner = P(B_inner);
P_outer = P(B_outer);

connected_components = bwconncomp(arm_blob, 4);

% Test that blob is whole
test_1 = connected_components.NumObjects == 1;

% Test that blob different from surroundings
test_2 = nanmedian(D_outer) - nanmedian(D_inner) >= 10;
test_3 = nanmedian(P_inner) - nanmedian(P_outer) >= 0.01;

tests = [test_1, test_2, test_3];

% Arm blob X (left or right) is valid
X_is_valid = all(tests);

if ~X_is_valid
    % The arm blob is a blank image
    arm_blob = false(size(arm_blob));
end

end

