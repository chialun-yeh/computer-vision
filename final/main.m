%% Read in all images and descriptors
clear; clc;
% read the images and detect keypoints (here we already have pre-extracted keypoints)
% we save images in the memory 
dir_path = 'model_castle';
filePattern = fullfile(dir_path, '*.JPG');
jpegFiles = dir(filePattern);
numImg = length(jpegFiles);
images = cell(1,numImg);
for k = 1:length(jpegFiles)
    baseFileName = jpegFiles(k).name;
    fullFileName = fullfile(dir_path, baseFileName);
    fprintf(1, 'Reading %s\n', fullFileName);
    img = imread(fullFileName);
    images{k} = img;
end

% Load descriptors
load('descriptor_frame/haraff_descriptor');
load('descriptor_frame/haraff_frame');
load('descriptor_frame/hesaff_descriptor');
load('descriptor_frame/hesaff_frame');
descriptor = haraff_descriptor;
frame = haraff_frame;
for i = 1:numImg
    descriptor{i} = [descriptor{i} hesaff_descriptor{i}];
    frame{i} = [frame{i} hesaff_frame{i}];
end

%% Matching
c = [1:numImg 1 2 3];
match_thres = 1.1;
all_matches = cell(1,numImg);
for i = 1:numImg
    % match feature points
    [matches, scores] = vl_ubcmatch(descriptor{i}, descriptor{c(i+1)}, match_thres) ;
    all_matches{i} = matches;
end

%% Normalized 8-point RANSAC algorithm
c = [1:numImg 1 2 3];
ransac_thres = 700;
ransac_matches = cell(1,numImg);
for i = 1:numImg
    matches = all_matches{i};
    points1 = frame{i}(1:2,matches(1,:));
    points2 = frame{c(i+1)}(1:2,matches(2,:));
    % do 8-point RANSAC
    [F_final, max_idx] = Normalized_Eight_point_RANSAC(points1,points2,ransac_thres);
    ransac_matches{i} = matches(:,max_idx);
end

%% Chaining
point_view_matrix = build_point_view_matrix(ransac_matches);
% plot the point view matrix
forplot = zeros(size(point_view_matrix,1), size(point_view_matrix,2));
forplot(point_view_matrix ~= 0) = 1;
figure(); imagesc(forplot); title('point view matrix')

%% Stitching
%find point sets that appear in 3 and 4 consecutive images
points3 = point_view_matrix(:,sum((point_view_matrix > 0),1) >= 3);
common = point_view_matrix(:,sum((point_view_matrix > 0),1) >= 4);
commonPoints = find_common_points(points3, common);

% Reconstruct 3D points with factorization
camera=[];
threeDpoints = cell(1,numImg);
point_matrix_cell = cell(1,numImg);
for i = 1:numImg
    sfmPoints = points3([c(i) c(i+1) c(i+2)], ((points3(c(i),:) ~= 0) & (points3(c(i+1),:) ~= 0) & (points3(c(i+2),:) ~= 0)) );
    commonpoints = common([c(i) c(i+1) c(i+2) c(i+3)], ((common(c(i),:) ~= 0) & (common(c(i+1),:) ~= 0) & (common(c(i+2),:) ~= 0) & (common(c(i+3),:) ~= 0)) );
    [~, idx1, idx2] = intersect(sfmPoints(1,:), commonpoints(1,:));
    f = cell(1,3);
    for ff = 1:3
        f{ff} = frame{c(i+ff-1)};
    end
    % turn the points into the format for factorization (2m*n)
    point_matrix_cell{i} = build_point_matrix(sfmPoints, f);
    [M,S] = SfM(point_matrix_cell{i});
    camera(:,:,i) = M;
    threeDpoints{i} = S;
end

%% Bundle Adjustment
[optimal_M, optimal_S] = local_bundle_adjustment_lsqnonlin(point_matrix_cell,threeDpoints,camera);

%% 3D Model Plotting
% find the color for each point
color = threedAverRGB(point_matrix_cell,images);
all_color = uint8(color{1});
for i = 2
   all_color = [all_color uint8(color{i})]; 
end

% use the first frame as the reference
S = threeDpoints{1};
Z = S;
for i = 2
    m1 = Z(:,commonPoints{i-1}(1,:));
    m2 = threeDpoints{i}(:,commonPoints{i-1}(2,:));
    [D, Z, Trans] = procrustes(m1',m2');
    Z =  (Trans.b * threeDpoints{i}' * Trans.T) + Trans.c(1,:);
    Z = Z';
    S = [S Z];
end

% plot the 3D points
ptCloud = pointCloud(S','C',all_color');
pcshow(ptCloud,'MarkerSize',45)
title('3D point cloud')

%% plot the output triangulation
p = S';
[t]=MyCrustOpen(S');
figure(1)
hold on
title('Output Triangulation','fontsize',14)
axis equal
trisurf(t,p(:,1),p(:,2),p(:,3),'facecolor','c','edgecolor','b')%plot della superficie
axis vis3d
view(3)