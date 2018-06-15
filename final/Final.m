
clear; clc;
%% Read in all images and save all descriptors
dir_path = 'model_castle\';
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
    [f, d] = vl_sift(im,'PeakThresh',8) ;
    frame{k} = f;
    descriptor{k} = d;
end
%% Apply normalized 8-point RANSAC algorithm
for i = 1:length(frame)-1
    [matches, scores] = vl_ubcmatch(descriptor{i}, descriptor{i+1}, 5) ;
    points1 = frame{i}(1:2,matches(1,:));
    points2 = frame{i+1}(1:2,matches(2,:));
    [F,inliers_index] = Normalized_Eight_point_RANSAC(points1,points2,threshold);
    newmatches = matches(:,inliers);
end


