function struct_elem = cell_neighbourhood(r, neighbourhood, middle_val)
% Returns structuring element for Von Neumann or Moore neighbourhood.
% Useful for cellular automaton and morphological operations.
%
% Inputs
%
%   r : scalar
%       Radius of neighbourhood (e.g., r = 1 produces 3x3 matrix) 
%
%   neighbourhood : char vector
%       1 x n_chars
%       'Neumann' or 'Moore'
%
%   middle_val : bool
%       Value for middle element
%
% Outputs
%
%   struct_elem : logical matrix
%       n_rows_struct x n_rows_struct 
%       Structuring element (square matrix)

n_rows = 2 * r + 1;

middle = n_rows - r;

switch neighbourhood
    case 'Neumann'
        struct_elem = false(n_rows);
        struct_elem(middle, :) = true;
        struct_elem(:, middle) = true;
    case 'Moore'
        struct_elem = true(n_rows);
end


struct_elem(middle, middle) = middle_val;


end
