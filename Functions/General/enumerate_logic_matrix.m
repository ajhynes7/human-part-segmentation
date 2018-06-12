function logic_mat_nums = enumerate_logic_matrix(logic_mat)
% Assigns number to each true element of matrix in order that it appears.
%
% Inputs
%
%   logic_mat : logical matrix
%       n_rows x n_cols
%
% Outputs
%
%   logic_mat_nums : matrix
%       n_rows x n_cols

n_elems = numel(logic_mat);

logic_mat_nums = nan(size(logic_mat));

count = 0;
for i = 1:n_elems
    if logic_mat(i)
        count = count + 1;
        logic_mat_nums(i) = count;
    end
end

end

