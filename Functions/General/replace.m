function X = replace(X, val_A, val_B)
% Replaces all elements in X equal to value A with new value B.
%
% Inputs
%
%   X : matrix
%       n_rows x n_cols
%       Input matrix
%
%   val_A : scalar
%       Original value
%
%   val_B : scalar
%       New value
%
% Outputs
%
%   X : matrix
%       n_rows x n_cols
%       Original X with some replaced values

if isnan(val_A)
    X(isnan(X)) = val_B;
else
    X(X == val_A) = val_B;
end

end
