%% Use the scale-invariant Harris corner detector to detect interest points
close all; 
clear; clc;
addpath('C:\Users\sharo\Documents\Delft\CV\computer-vision\Lab1');

% read image and detect interest points
Img1 = imread('landscape-a.jpg');
[frame1,des1] = harrisDecSiftDes(Img1);
size1 = length(des1);
Img2 = imread('landscape-b.jpg');
[frame2,des2] = harrisDecSiftDes(Img2);
size2 = length(des2);

%% Find matching descriptors using Euclidean distance
bestIdx = 0;
secondBestIdx=0;
match=[];

for i = 1:size1
    best = 1000;
    secondBest = 1000;
    for j = 1:size2
        d = sqrt(sum((des1(:,i)-des2(:,j)).^2));
        if  d < best && d < secondBest
            best = d;
            bestIdx=j;
        elseif d > best && d < secondBest
            secondBest = d;
            secondBestIdx=j;
        end
    end
    if secondBest/best > 1.15
        coord=[i;bestIdx];
        match = [match coord];
    end
        
end

%% show interest points on image
points1 = frame1(1:2,match(1,:));
points2 = frame2(1:2,match(2,:));
figure; ax = axes;
showMatchedFeatures(Img1,Img2, points1',points2','montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');




