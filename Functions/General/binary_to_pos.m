function points = binary_to_pos(B)
% Converts pixels in binary image to positions.
%
% Inputs
%
%   B : logical matrix
%       n_rows x n_cols
%       Binary image
%
% Outputs
%
%   points : matrix
%       n_points x n_dimensions
%       Row i is vector for point i

[n_rows, n_cols] = size(B);
n = sum(B(:));

points = nan(n, 2);

count = 0;
% Outer loop is along columns, to mimic MATLAB 2D array indexing
for j = 1:n_cols
    for i = 1:n_rows
        if B(i, j)
            count = count + 1;

            points(count, :) = [j, i];
        end
    end
end


end
