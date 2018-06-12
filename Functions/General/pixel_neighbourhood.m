function neighbours_in_B = pixel_neighbourhood(blob_A, blob_B, struct_elem)
% Finds the neighbours of blob A that exist in blob B.
% Neighbourhood defined by structuring element (e.g., Neumann or Moore).
%
% Inputs
%
%   blob_A : logical matrix
%       n_rows x n_cols
%       Binary image A
%
%   blob_B : logical matrix
%       n_rows x n_cols
%       Binary image B
%
%   struct_elem : logical matrix
%       n_rows_struct x n_rows_struct 
%       Structuring element (square matrix)
%
% Outputs
%
%   neighbours_in_B : logical matrix
%       n_rows x n_cols
%       Element i is true iff it is in blob B and is a neighbour to blob A

dilated_A = imdilate(blob_A, struct_elem);

neighbours_in_B = dilated_A & blob_B;

end

