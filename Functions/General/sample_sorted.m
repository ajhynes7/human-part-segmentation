function X_sample = sample_sorted(X, n_samples)
% Takes a sample of a vector after sorting its values.
%
% Inputs
%
%   X : vector
%       n x 1
%       Set of values
%
%   n_samples : scalar
%       Number of samples
%
% Outputs
%
%   X_sample : vector
%       n_samples x 1
%       Sample of original vector X

n = numel(X);

sorted = sort(X);
indices = floor(linspace(1, n, n_samples));

X_sample = sorted(indices);

end

