function blob_perim = blob_perimeter(B, struct_elem)
% Returns perimeter of binary image by subtracting the erosion of the
% image.
%
% Inputs
%
%   B : logical matrix
%       n_rows x n_cols
%       Binary image
%
% Outputs
%
%   struct_elem : logical matrix
%       n_rows_struct x n_rows_struct 
%       Structuring element (square matrix)

blob_perim = B & ~imerode(B, struct_elem);

end

