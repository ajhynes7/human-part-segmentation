function pad_size = get_pad_size(struct_elem)
% Returns padding size from a structuring element.
% 
% Padding size is amount of padding needed on an image in order to apply a
% structuring element.
%
% Inputs
%
%   struct_elem : logical matrix
%       n_rows_struct x n_rows_struct 
%       Structuring element (square matrix)
%
% Outputs
%
%   pad_size : vector
%       1 x 2
%       Padding for [rows, cols]
%       Used in MATLAB's padarray

[h, w] = size(struct_elem);
pad_size = [floor(h/2), floor(w/2)];

end

