function index = equal_to_any(A, B)
% Returns a logical index to use inside matrix A.
%
% Element (i, j) is true iff A(i, j) is equal to any element in B.
%
% Inputs
%
%	A : matrix
%       n_rows x n_cols
%
%   B : vector
%       n x 1
%       List of values
%
% Outputs
%
%   index : logical matrix
%       n_rows x n_cols

index = false(size(A));

for i = 1:numel(B)
    index = index | A == B(i);
end

end

