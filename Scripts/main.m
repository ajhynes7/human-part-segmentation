
clc, clearvars, close all;

%-------------------------------------------------------------------------
% Human Part Segmentation in Depth Images with Annotated Part Positions
%
% Andrew Hynes
% June 11, 2018
%-------------------------------------------------------------------------

path_to_data = fullfile('..', 'Input Data', 'Human Limbs from RGBD Data');

% Add paths to functions
addpath(fullfile('..', 'Functions', 'Graphs'))
addpath(fullfile('..', 'Functions', 'Results'))
addpath(fullfile('..', 'Functions', 'General'))
addpath(fullfile('..', 'Functions', 'Clustering'))
addpath(fullfile('..', 'Functions', 'Segmentation'))
addpath(fullfile('..', 'Functions', 'MATLAB File Exchange'))
addpath(fullfile('..', 'Functions', 'GraphAnalysisToolbox (by Leo Grady)'))


%% Parameters

dataset = 'n';

% If set to True, only the pure random walker algorithm will be run,
% i.e. no layered graph will be constructed
pure_RW = false;

% Joint connections (e.g., torso [1] to RU arm [2])
joint_conn = [1 2; 2 3; 3 4; 1 5; 5 6; 6 7];

% Draw a line of seed pixels for this joint connection
is_line = [1 0 0 1 0 0];

% Ratios for labelling the lines of seed pixels
ratios = [2/3, nan, nan, 2/3, nan, nan, nan, nan, nan];

% Numbers of the arm parts, first column is the hands
% Row 1 is right, 2 is left
arm_parts  = [4 3; 7 6];

% Beta values for Random Walker weighting function
% For arm segmentation and final segmentation
betas = [90, 90];

% Radius for mean shift with Gaussian kernel (standard deviation)
% Mean shift used to segment arm
r = 0.01;



%% Load data

load_filename = sprintf('hernandez_clean_%s', dataset);

load_path = fullfile(path_to_data, load_filename);
load(load_path)

n_frames = numel(depth_cell);


%% Process frames

[part_seg_cell, arm_seg_cell] = deal(cell(n_frames, 1));

for f = 14
        
    depth        = depth_cell{f};
    truth        = truth_cell{f};
    image_coords = image_coords_cell{f};
    
    % Segment body parts
    if pure_RW == true
        
        % Segment with pure Random Walker (no layered graph)
        part_seg = segment_parts_pure(depth, image_coords, joint_conn,...
            is_line, betas, ratios);
    else
        
        % Segment with layered graph
        [part_seg, arm_seg, connect_pix, is_valid] = ...
            segment_parts(depth, image_coords, joint_conn, is_line,...
            betas, arm_parts, ratios, r);
        
        arm_seg_cell{f} = arm_seg;
    end
    
    part_seg_cell{f} = part_seg;
end



%% Numerical results

% Create confusion matrix
C = multi_class_confusion(part_seg, truth);

% Per-class accuracy and Jaccard index
[~, PC, JI] = confusion_matrix_results(C);

fprintf('Mean per-class accuracy: \n%.4f \n\n', nanmean(PC));
fprintf('Mean Jaccard index:      \n%.4f \n\n', nanmean(JI));



%% Visual results

background = 'w';
n_parts = size(image_coords, 1);
colours = distinguishable_colors(n_parts, background);

if pure_RW == false
     
    figure;
    RGB = label2rgb(arm_seg, colours, background);
    imagesc(RGB);
    title(sprintf('Arm segmentation: Set %s - Frame %d', dataset, f))
    
    fprintf('Valid arms (right/left): \n%d %d \n\n',...
        is_valid(1), is_valid(2)); 
end

figure;
RGB = label2rgb(part_seg, colours, background);
imagesc(RGB);
title(sprintf('Part segmentation: Set %s - Frame %d', dataset, f))
hold on;
scatter(image_coords(:, 1), image_coords(:, 2), 'filled',...
    'w', 'MarkerEdgeColor', 'k')




