function c_of_m = centre_of_mass(points, masses)
% Finds the centre of mass of multiple point masses.
%
% Inputs
%
%   points : matrix
%       n_points x n_dimensions
%       Row i is vector for point i
%
%   masses : vector
%       n_points x 1
%       Vector of mass values
%
% Outputs
%
%   c_of_m : vector
%       1 x n_dimensions
%       Centre of mass

[n_pos, n_dim] = size(points);

total = zeros(1, n_dim);
for i = 1:n_pos
    m = masses(i);
    p = points(i, :);
    total = total + m * p;
end

c_of_m = total / sum(masses);

end
