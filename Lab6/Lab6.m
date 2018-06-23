clear; clc
dir_path = 'C:\Users\sharo\Documents\Delft\CV\computer-vision\Lab5\TeddyBear';
filePattern = fullfile(dir_path, '*.JPG');
jpegFiles = dir(filePattern);
frame = cell(1,length(jpegFiles));
descriptor = cell(1,length(jpegFiles));
for k = 1:length(jpegFiles)
    baseFileName = jpegFiles(k).name;
    fullFileName = fullfile(dir_path, baseFileName);
    fprintf(1, 'Reading %s\n', fullFileName);
    img = imread(fullFileName);
    im = single(rgb2gray(img));
    [f, d] = vl_sift(im,'PeakThresh',5) ;
    frame{k} = f;
    descriptor{k} = d;
end
%% 
addpath('C:\Users\sharo\Documents\Delft\CV\computer-vision\Lab5');
fundamental_matrix = cell(1,length(jpegFiles));
new_matches = cell(1,length(jpegFiles));
for i = 1:length(frame)
    if i == length(frame)
        j=1;
    else
        j=i+1;
    end
    [matches, scores] = vl_ubcmatch(descriptor{i}, descriptor{j}, 1) ;
    points1 = frame{i}(1:2,matches(1,:));
    points2 = frame{j}(1:2,matches(2,:));
    [F,inliers_index] = Normalized_Eight_point_RANSAC(points1,points2,1000);
    fundamental_matrix{i} = F;
    new_matches{i} = matches(:,inliers_index);
end

%% Build the point-view matrix
point_view_matrix = zeros(length(jpegFiles),size(new_matches{1},2));
point_view_matrix(1,1:size(new_matches{1},2)) = new_matches{1}(1,:)';
point_view_matrix(2,1:size(new_matches{1},2)) = new_matches{1}(2,:)';

%%
for i = 2:length(new_matches)-1
    current_size = size(point_view_matrix,2);
    [C, IA, IB] = intersect(new_matches{i}(1,:)', point_view_matrix(i,:));
    [C,ia] = setdiff(new_matches{i}(1,:)', point_view_matrix(i,:));
    point_view_matrix(i+1,IB) = new_matches{i}(2,IA);
    point_view_matrix = [point_view_matrix zeros(size(point_view_matrix,1),length(ia))];
    point_view_matrix(i, current_size+1:size(point_view_matrix,2)) = new_matches{i}(1,ia);
    point_view_matrix(i+1, current_size+1:size(point_view_matrix,2)) = new_matches{i}(2,ia);
end
%%
% Do the last frame 
[C, IA, IB] = intersect(new_matches{20}(1,:)', point_view_matrix(1,:));
%[C,ia] = setdiff(new_matches{20}(1,:)', point_view_matrix(1,:));
point_view_matrix
