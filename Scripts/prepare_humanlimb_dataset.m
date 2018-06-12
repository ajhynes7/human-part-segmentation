clc, clearvars, close all;

addpath('../Functions/General')

dataset = 'n';

data_dir = '../Input Data/Human Limbs from RGBD Data';

load_filename = sprintf('hernandez_raw_%s.mat', dataset);
save_filename = sprintf('hernandez_clean_%s.mat', dataset);

load_path = fullfile(data_dir, load_filename);

load(load_path)


%% Process files

% Numbers of all the arm parts: hand to shoulder
% Row 1 is right, 2 is left
arm_orders  = [4 3 2; 7 6 5];

n_frames = size(depth_cell, 1);

orig_depth_cell = depth_cell;
orig_truth_cell = truth_cell;
[depth_cell, truth_cell, image_coords_cell] = deal(cell(n_frames, 1));

for f = 1:n_frames
    
    depth = orig_depth_cell{f};
    truth = orig_truth_cell{f};
    
    % Change truth labels
    truth = replace_by_vec(truth, [2, 16:18, 24:26], 1:7);
    
    % Delete high depths
    delete_index = depth > 2500;
    depth(delete_index) = nan;
    truth(delete_index) = 0;
    
    image_coords = pixels_near_centroids(truth);
     
    % Change torso coordinate
    R_shoulder = image_coords(arm_orders(1, end), :);
    L_shoulder = image_coords(arm_orders(2, end), :);
    
    mid_of_shoulders = round(mean([L_shoulder; R_shoulder]));
    
    if ~any(isnan(mid_of_shoulders))
        image_coords(1, :) = mid_of_shoulders;
    end
    
    % Store data in cells
    depth_cell{f} = depth;
    truth_cell{f} = truth;
    image_coords_cell{f} = image_coords;
end


%% Save processed data

save_path = fullfile('../Input Data/Human Limbs from RGBD Data', save_filename);

save(save_path, 'depth_cell', 'truth_cell', 'image_coords_cell', '-v7.3')

