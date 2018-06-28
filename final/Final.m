
%% Read in all images and save all descriptors
clear; clc;
dir_path = 'TeddyBear';
filePattern = fullfile(dir_path, '*.JPG');
jpegFiles = dir(filePattern);
numImg = length(jpegFiles);
frame = cell(1,numImg);
descriptor = cell(1,numImg);
for k = 1:length(jpegFiles)
    baseFileName = jpegFiles(k).name;
    fullFileName = fullfile(dir_path, baseFileName);
    fprintf(1, 'Reading %s\n', fullFileName);
    img = imread(fullFileName);
    im = single(rgb2gray(img));
    [f, d] = vl_sift(im,'PeakThresh',3) ;
    frame{k} = f;
    descriptor{k} = d;
end
%%
numImg = 16;
%descriptor = haraff_descriptor;
%frame = haraff_frame;
%% Apply normalized 8-point RANSAC algorithm to find best matches
newmatches = cell(1,numImg);
cycle = [1:numImg 1 2 3];
match_thres = 1;
ransac_thres = 1000;
for i = 1:numImg
    [matches, scores] = vl_ubcmatch(descriptor{i}, descriptor{cycle(i+1)}, match_thres) ;
    points1 = frame{i}(1:2,matches(1,:));
    points2 = frame{cycle(i+1)}(1:2,matches(2,:));
    [F,inliers_index,distance] = Normalized_Eight_point_RANSAC(points1,points2,ransac_thres);
    newmatches{i} = matches(:,inliers_index);
end

%% Chaining
point_view_matrix = build_point_view_matrix(newmatches);

%% Stitching
%find point sets that appear in 3 consecutive images
points3 = point_view_matrix(:,sum((point_view_matrix > 0),1) >= 3);
common = point_view_matrix(:,sum((point_view_matrix > 0),1) >= 4);

point_matrix_cell = cell(1,numImg);
threeDpoints = cell(1,numImg);

for i = 1:numImg
    index = a([cycle(i) cycle(i+1) cycle(i+2)], ((a(cycle(i),:) ~= 0) & (a(cycle(i+1),:) ~= 0) & (a(cycle(i+2),:) ~= 0)) );
    f = cell(1,3);
    for ff = 1:3
        f{ff} = frame{cycle(i+ff-1)};
    end
    point_matrix_cell{i} = build_point_matrix(index, f);
    [M,S] = SfM(point_matrix_cell{i});
    threeDpoints{i} = S;
end
    
%%
plot3(S(1, :), S(2,:), S(3,:),'b.');
%procrustes(X,Y)

