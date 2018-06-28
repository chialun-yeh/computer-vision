function [T] = imageAlign(img1, img2)
% inputs: 
% img1: path to the first image
% img2: path to the second image
% output T: The affine transformation matrix

% read the images to be stitched
im1 = imread(img1);
im2 = imread(img2);
% detect harris corners
[frames1, desc1] = harrisDecSiftDes(im1);
[frames2, desc2] = harrisDecSiftDes(im2);
% matches: descriptor indexs; matches(1,:) is idx in image 1
[matches] = vl_ubcmatch(desc1,desc2);

%% RANSAC
N = 1000;
maxInlier = 10;
bestInliers = 0;
bestModel=0;
for i = 1:N
    perm = randperm(length(matches));
    seed = perm(1:3);
    coord1 = frames1(1:2, matches(1,seed));
    coord2 = frames2(1:2, matches(2,seed));
    A = [coord1(1,1) coord1(2,1) 0 0 1 0; 
         0 0 coord1(1,1) coord1(2,1) 0 1;
         coord1(1,2) coord1(2,2) 0 0 1 0; 
         0 0 coord1(1,2) coord1(2,2) 0 1;
         coord1(1,3) coord1(2,3) 0 0 1 0; 
         0 0 coord1(1,3) coord1(2,3) 0 1];
    b = [coord2(1,1) coord2(2,1)  coord2(1,2) coord2(2,2)  coord2(1,3) coord2(2,3)];
    x = pinv(A)*b';
    transformed = [];
    for i = 1:length(matches)
        A = [frames1(1,matches(1,i)) frames1(2,matches(1,i)) 0 0 1 0; 
             0 0 frames1(1,matches(1,i)) frames1(2,matches(1,i)) 0 1];
        transformed = [transformed A*x];
    end
    threshold = 10;
    inliers = find(sqrt((frames2(1,matches(2,:))-transformed(1,:)).^2 + (frames2(2,matches(2,:))-transformed(2,:)).^2) < threshold); 
    
    if length(inliers) > maxInlier
        maxInlier = length(inliers);
        bestInliers = inliers;
        newA = []; newB=[];
        for i=1:length(inliers)
            newA = [newA; frames1(1,matches(1,inliers(i))) frames1(2,matches(1,inliers(i))) 0 0 1 0; 
                          0 0 frames1(1,matches(1,inliers(i))) frames1(2,matches(1,inliers(i))) 0 1];
            bb = [frames2(1, matches(2,inliers(i))) frames2(2, matches(2, inliers(i)))];
            newB = [newB bb];
        end
        bestModel=newA\newB';
    end
end

x = bestModel;
T = [x(1) x(2) x(5);x(3) x(4) x(6);0 0 1 ];
end