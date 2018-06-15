
%% Read in all images and save all descriptors
clear; clc;
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
    [f, d] = vl_sift(im,'PeakThresh',5) ;
    frame{k} = f;
    descriptor{k} = d;
end
%% Apply normalized 8-point RANSAC algorithm
newmatches = cell(1,length(frame)-1);
threshold = 10000;
for i = 1:length(frame)-1
    [matches, scores] = vl_ubcmatch(descriptor{i}, descriptor{i+1}, 1) ;
    points1 = frame{i}(1:2,matches(1,:));
    points2 = frame{i+1}(1:2,matches(2,:));
    [F,inliers_index,distance] = Normalized_Eight_point_RANSAC(points1,points2,threshold);
    newmatches{i} = matches(:,inliers_index);
end

%% 
for i = 1:3:length(frame)
    set = [i i+1 i+2];
    if i == 19
        set = [19 1 2];
    end
    points_matrix = build_matrix(newmatches{set}, frames);
    S = SfM(points_matrix)
end

plot3(S(1, :), S(2,:), S(3,:),'b.');
procrustes(X,Y)

