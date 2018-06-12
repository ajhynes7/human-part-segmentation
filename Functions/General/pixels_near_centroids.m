function image_coords = pixels_near_centroids(L)
% Assigns a image coordinate for each labelled body part in a ground truth
% image.
%
% Image coord i is the foreground pixel closest to the centroid of 
% pixels labelled i.
%
% Inputs
%
%   L : matrix
%       n_rows x n_cols
%       Label matrix
%       Each pixel (i, j) is a ground truth label
%
% Outputs
%
%   image_coords : matrix
%       n_parts x 2
%       Row i is the (x, y) image coordinates for body part i

foreground = L > 0;
foreground_pts = binary_to_pos(foreground);

labels = unique(L(foreground))';
n_labels = numel(labels);

image_coords = nan(numel(labels), 2);


for i = 1:n_labels
    
    label = labels(i);
    
    blob = L == label;
    
    if ~any(blob)
        continue
    end
    
    % Centroid of the binary blob
    centroid = round(binary_centroid(blob));
    
    if ~foreground(centroid(2), centroid(1))
        % The centroid pixel is not in the foreground
        % Choose the nearest foreground pixel
        
        % Choose the closest foreground pixel
        distances_to_centre = pdist2(foreground_pts, centroid);
        [~, min_idx] = min(distances_to_centre);
        
        image_coords(label, :) = foreground_pts(min_idx, :);
    else
        
        image_coords(label, :) = centroid;
    end
end

end

