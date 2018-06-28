%% Read in all images and save all descriptors
clear; clc;
dir_path = 'TeddyBear';
filePattern = fullfile(dir_path, '*.JPG');
jpegFiles = dir(filePattern);
numImg = length(jpegFiles);
frame = cell(1,numImg);
descriptor = cell(1,numImg);
images = cell(1,numImg);
for k = 1:length(jpegFiles)
    baseFileName = jpegFiles(k).name;
    fullFileName = fullfile(dir_path, baseFileName);
    fprintf(1, 'Reading %s\n', fullFileName);
    img = imread(fullFileName);
    images{k} = img;
    im = single(rgb2gray(img));
    [f, d] = vl_sift(im,'PeakThresh',7) ;
    frame{k} = f;
    descriptor{k} = d;
end
%%
load('descriptor_frame/haraff_descriptor');
load('descriptor_frame/haraff_frame');
descriptor = haraff_descriptor;
frame = haraff_frame;
%% Matching
c = [1:numImg 1 2 3];
match_thres = 1.2;
for i = 1:numImg
    % match feature points
    [matches, scores] = vl_ubcmatch(descriptor{i}, descriptor{c(i+1)}, match_thres) ;
end

%% Apply normalized 8-point RANSAC algorithm to find best matches
ransac_thres = 25;
ransac_matches = cell(1,numImg);
for i = 1:numImg
    % match feature points
    [matches, scores] = vl_ubcmatch(descriptor{i}, descriptor{c(i+1)}, match_thres) ;
    points1 = frame{i}(1:2,matches(1,:));
    points2 = frame{c(i+1)}(1:2,matches(2,:));
    % do 8-point RANSAC
    [F_final, max_idx] = Normalized_Eight_point_RANSAC(points1,points2,ransac_thres);
    ransac_matches{i} = matches(:,max_idx);
end

%% Chaining
point_view_matrix = build_point_view_matrix(ransac_matches);

%% Stitching
%find point sets that appear in 3 and 4 consecutive images
points3 = point_view_matrix(:,sum((point_view_matrix > 0),1) >= 3);
common = point_view_matrix(:,sum((point_view_matrix > 0),1) >= 4);
point_matrix_cell = cell(1,numImg);
threeDpoints = cell(1,numImg);
commonPoints = cell(1,numImg);
for i = 1:numImg
    twoDpoints1 = points3([c(i) c(i+1) c(i+2)], ((points3(c(i),:) ~= 0) & (points3(c(i+1),:) ~= 0) & (points3(c(i+2),:) ~= 0)) );
    twoDpoints2 = points3([c(i+1) c(i+2) c(i+3)], ((points3(c(i+1),:) ~= 0) & (points3(c(i+2),:) ~= 0) & (points3(c(i+3),:) ~= 0)) );
    commonpoints = common([c(i) c(i+1) c(i+2) c(i+3)], ((common(c(i),:) ~= 0) & (common(c(i+1),:) ~= 0) & (common(c(i+2),:) ~= 0) & (common(c(i+3),:) ~= 0)) );
    % eliminate repeating values in common
    [C,IA,IC] = unique(commonpoints(1,:));
    commonpoints = commonpoints(:,IA);
    % 
    [~, idx1, idx2] = intersect(twoDpoints1(1,:), commonpoints(1,:));  
    [~, idx3, idx4] = intersect(twoDpoints2(1,:), commonpoints(2,:)); 
    mat = zeros(2,length(idx1));
    for id = 1:length(idx2)
        mat(1,id) = idx1(idx2()==id);
        mat(2,id) = idx3(idx4==id);
    end
    commonPoints{i} = mat;
end

%% Reconstruct 3D points with factorization
camera=[];
for i = 1:numImg
    sfmPoints = points3([c(i) c(i+1) c(i+2)], ((points3(c(i),:) ~= 0) & (points3(c(i+1),:) ~= 0) & (points3(c(i+2),:) ~= 0)) );
    commonpoints = common([c(i) c(i+1) c(i+2) c(i+3)], ((common(c(i),:) ~= 0) & (common(c(i+1),:) ~= 0) & (common(c(i+2),:) ~= 0) & (common(c(i+3),:) ~= 0)) );
    [~, idx1, idx2] = intersect(sfmPoints(1,:), commonpoints(1,:));
    f = cell(1,3);
    for ff = 1:3
        f{ff} = frame{c(i+ff-1)};
    end
    point_matrix_cell{i} = build_point_matrix(sfmPoints, f);
    [M,S] = SfM(point_matrix_cell{i});
    camera(:,:,i) = M;
    threeDpoints{i} = S;
end
save('camera', 'camera');
save('3d_points','threeDpoints');
save('2d_points','point_matrix_cell');
%% Plot 3D points
% use the first frame as the reference
color = threedAverRGB(point_matrix_cell,images);
S = threeDpoints{1};
Z = S;
all_color = uint8(color{1});
for i = 2:numImg
   all_color = [all_color uint8(color{i})]; 
end
%%
for i = 2:numImg
    m1 = Z(:,commonPoints{i-1}(1,:));
    m2 = threeDpoints{i}(:,commonPoints{i-1}(2,:));
    [D, Z, Trans] = procrustes(m1',m2');
    Z =  (Trans.b * threeDpoints{i}' * Trans.T) + Trans.c(1,:);
    Z = Z';
    S = [S Z];
end
%%
ptCloud = pointCloud(S','C',all_color');
pcshow(ptCloud)