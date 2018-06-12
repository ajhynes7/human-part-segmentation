function [mask, probabilities] = random_walk_graph(seeds, labels,...
    edges, weights)
% Assigns a label to every node in a graph using labelled seed pixels.
%
% Note: The code is a portion of the function random_walker, 
%   fully written by Leo Grady (http://leogrady.net/software/)
% 
% Inputs
%
%   seeds : vector
%       n_seed_nodes x 1
%       Seed node numbers
%
%   labels : vector
%       n_seed_nodes x 1
%       Label number for each seed node
%       Each element has a value from 1 to n_labels
%
%   edges : matrix
%       n_edges x 2
%       Each row has two node numbers A and B, representing an edge from A
%       to B
%
%   weights : vector
%       n_edges x 1
%       Weight of each node
%
% Outputs
%
%   mask : vector
%       1 x n_nodes
%       Each element has a value from 0 to n_parts
%       Non-line pixel has a value of 0
%       Pixels on a line are assigned a body part number
%       
%   probabilities : matrix
%       n_nodes x n_labels
%       For each node i, there is a vector of probabilities for labels 1
%       to n_labels
%       The label with max probability is assigned to this node

L=laplacian(edges,weights);

%Determine which label values have been used
label_adjust=min(labels); labels=labels-label_adjust+1; %Adjust labels to be > 0
labels_record(labels)=1;
labels_present=find(labels_record);
number_labels=length(labels_present);

%Set up Dirichlet problem
boundary=zeros(length(seeds),number_labels);
for k=1:number_labels
    boundary(:,k)=(labels(:)==labels_present(k));
end

%Solve for random walker probabilities by solving combinatorial Dirichlet
%problem
probabilities = dirichletboundary(L,seeds(:),boundary);

%Generate mask
[~, mask] = max(probabilities,[],2);
mask=labels_present(mask)+label_adjust-1; %Assign original labels to mask

end

