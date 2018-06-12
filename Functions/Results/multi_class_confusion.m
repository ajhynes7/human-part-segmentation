function C = multi_class_confusion(classification, truth)
% Returns a multi-class confusion matrix from classification image and
% truth image.
%
% C_ij is the number of pixels with truth label i and predicted label j.
%
% Inputs
%
%   classification : matrix
%       n_rows x n_cols
%       Element (i, j) is the predicted class of this pixel
%       
%   truth : matrix
%       n_rows x n_cols
%       Element (i, j) is the true class of this pixel
%
% Outputs
%
%   C : matrix
%       n_classes x n_classes 
%       Multi-class confusion matrix

n_classes = max(truth(:));

C = zeros(n_classes);

for i = 1:n_classes
    for j = 1:n_classes
        
        x = truth == i & classification == j;
        C(i, j) = sum(x(:));
    end
end


end

