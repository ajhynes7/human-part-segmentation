function [OP, PC, JI] = confusion_matrix_results(C)
% Results from a multi-class confusion matrix.
%
% Equations taken from "What is a good evaluation measure for
%   semantic segmentation?", Csurka et al.
%
% Inputs
%
%   C : matrix
%       n_classes x n_classes
%       Multi-class confusion matrix
%
% Outputs
%
%   OP : scalar
%       Overall accuracy
%       Proportion of correctly labelled pixels
%       Sum of diagonal divided by total sum of C
%
%   PC : vector
%       n_classes x 1
%       Per class accuracy
%       Proportion of correctly labelled pixels for each class
%
%   JI : vector
%       n_classes x 1
%       Jaccard index
%       Measures the intersection over the union of the labelled segments 
%       for each class

n_classes = size(C, 1);

G = sum(C, 2); % Total number of pixels labelled with i
P = sum(C, 1); % Total number of pixels whose prediction is j

%% Overall accuracy

OP = trace(C) / sum(G);

%% Per-class accuracy

PC = nan(n_classes, 1);

for i = 1:n_classes
    PC(i) = C(i, i) / G(i);
end

%% Jaccard Index 

JI = nan(n_classes, 1);

for i = 1:n_classes
    JI(i) =  C(i, i) / (G(i) + P(i) - C(i, i));
end


end

