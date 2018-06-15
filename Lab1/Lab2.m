%% Use the scale-invariant Harris corner detector to detect interest points
close all; 
clear;
clc;

% read image and detect interest points
Img1 = imread('landscape-a.jpg');
[frame1,des1] = harrisDecSiftDes(Img1);
size1 = length(des1);
Img2 = imread('landscape-b.jpg');
[frame2,des2] = harrisDecSiftDes(Img2);
size2 = length(des2);
bestIdx = 0;
secondBestIdx=0;
match=[];

%% Find matching descriptors using Euclidean distance
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
    if secondBest/best > 1.2
        coord=[i;bestIdx];
        match = [match coord];
    end
        
end

%% show interest points on image
figure(1); clf;
imshow(cat(2, rgb2gray(Img1), rgb2gray(Img2)))
hold on
h = line([frame1(1,match(1,:));frame2(1,match(2,:))+size(Img1,2)], [frame1(2,match(1,:));frame2(2,match(2,:))]);




