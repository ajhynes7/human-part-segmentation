function [R_blob, L_blob] = ...
    resolve_blob_conflict(R_blob, L_blob, R_prob_mat, L_prob_mat)
% Deals with pixels belonging to both right and left arm blobs.
% Each intersecting pixel is assigned to the side with greater probability.
%
% Inputs
%
%   R_blob, L_blob : logical matrix
%       n_rows x n_cols
%       Right and left arm blobs
%
%   R_prob_mat, L_prob_mat : matrix
%       n_rows x n_cols
%       Right and left probability matrices
%
% Outputs
%
%   R_blob, L_blob : logical matrix
%       Blobs now have no intersecting pixels

blob_intersect = R_blob & L_blob;

concat_prob_mat = cat(3, R_prob_mat, L_prob_mat);
[~, max_index] = max(concat_prob_mat, [], 3);

for i = 1:numel(blob_intersect)
    if blob_intersect(i)
        switch max_index(i)
            case 1
                L_blob(i) = false;
            case 2
                R_blob(i) = false;
        end
    end
end

blob_intersect = R_blob & L_blob;
assert(~any(blob_intersect(:)));

end

