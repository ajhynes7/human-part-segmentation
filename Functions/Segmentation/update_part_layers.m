function part_layers = update_part_layers(part_layers, image_coords,...
    arm_parts, binary_layers, is_valid, side)
% Assigns arm parts on side X (left or right) to the corresponding graph
% layer.
%
% All body parts are first assumed to belong to the base layer of the
% graph.
%
% Arm parts that are on the segmented arm image are assigned to the 
% corresponding (left/right) upper layer of the graph.
%
% Inputs
%
%   part_layers : vector
%       n_parts x 1
%       Element i is the graph layer of body part i
%
%   image_coords : matrix
%       n_parts x 2
%       Row i is the (x, y) image coordinates for body part i
%
%   arm_parts : matrix
%       2 x n_arm_parts
%       Row i is list of arm parts for body side i (R/L)
%       First column must be hand
%
%   binary_layers : logical matrix
%       n_rows x n_cols x 3
%       Each matrix layer i is a binary image of the pixels 
%       represented by graph layer i
%
%   is_valid : vector
%       1 x 2
%       Element i is true iff arm i is valid
%
% Outputs
%
%   part_layers : vector
%       n_parts x 1
%       Updated vector of part layers

if is_valid(side)
    
    % Graph layer of body side X (left or right)
    X_layer = side + 1;
    
    % Arm segment X
    X_blob = binary_layers(:, :, X_layer);
    
    X_arm_parts = arm_parts(side, :);
    arm_coords = image_coords(X_arm_parts, :);
    
    arm_part_indices = sub2ind(size(X_blob), arm_coords(:, 2),...
        arm_coords(:, 1));
    
    % Delete nans (in case of part blob being non-existent for this image)
    arm_part_indices = remove_nan_elems(arm_part_indices);
    
    % Logical vector for arm parts on the upper graph layer
    % Element i is true if arm part i is on the upper layer
    on_upper_layer = X_blob(arm_part_indices);
    
    upper_part_nums = X_arm_parts(on_upper_layer);
    
    % Update the part layers for these arm parts
    part_layers(upper_part_nums) = X_layer;
end

end

