function M = replace_by_vec(M, vec_A, vec_B)
% Replaces values in a matrix M.
%
% Values in vector A are the initial values. Values in vector B are the
% final values.
% 
% Inputs
%
%	M : matrix
%       n_rows x n_cols
%       Input matrix
%
%   vec_A : vector
%       n_values x 1
%       List of values A
%
%   vec_B : vector
%       n_values x 1
%       List of values B
%
% Outputs
%
%	M : matrix
%       n_rows x n_cols
%       Output matrix

n_values = numel(vec_A);
temp = M;

for i = 1:n_values
    val_A = vec_A(i);
    val_B = vec_B(i);
    
    temp(M == val_A) = val_B;
end

M = temp;
    
end

