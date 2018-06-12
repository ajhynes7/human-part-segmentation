function [mean_pos, in_radius] = shift_to_convergence(points, mean_pos,...
    shift_func, r, eps)
% Shifts a mean position until it converges on a final position.
%
% Inputs
%
%   points : matrix
%       n_points x n_dimensions
%       Input points to mean shift algorithm
%
%   mean_pos : vector
%       1 x n_dimensions
%       Initial mean position
%
%   shift_func : function_handle
%       Function of form f(points, mean_pos, radius)
%       Shifts an initial mean position to a new mean position
%
%   r : scalar
%       Radius (bandwidth) parameter for mean shift
%       Sigma (standard deviation) is set to this value
%
%   eps : scalar
%       Convergence criterion epsilon
%       The iterations terminate when distance from previous mean position 
%       to new mean position is less than epsilon
%
% Outputs
%
%   mean_pos : vector
%       1 x n_dimensions
%       Final mean position
%
%   in_radius : logical vector
%       n_points x 1
%       Element i is true if point i is within the radius of the mean
%       position

while true
    
    prev_mean_pos = mean_pos;
    [mean_pos, distances] = shift_func(points, mean_pos, r);
    
    if norm(prev_mean_pos - mean_pos) < eps
        % Mean position has converged
        
        in_radius = distances <= r;
        break
        
    end
end

end

