%% Lab5: Epipolar Geometry
% We calculate the fundamental matrix F between 2 images
clear; clc
img1 = imread('TeddyBear/obj02_001.jpg');
img2 = imread('TeddyBear/obj02_002.jpg');
I1 = single(rgb2gray(img1)) ;
I2 = single(rgb2gray(img2)) ;

% Compute the SIFT keypoints and descriptors
% The matrix f has a column for each keypoint: center f(1:2), scale f(3) and orientation f(4). 
[fa, da] = vl_sift(I1,'PeakThresh',7) ;
[fb, db] = vl_sift(I2,'PeakThresh',7) ;
%%
% Check the keypoints
subplot(1,2,1),imshow(img1)
h1 = vl_plotframe(fa);;
set(h1,'color','y','linewidth',2) ;
subplot(1,2,2),imshow(img2)
h1 = vl_plotframe(fb);;
set(h1,'color','y','linewidth',2) ;

%%
% Match the keypoints using the descriptors
[matches, scores] = vl_ubcmatch(da, db, 1) ;
points1 = fa(1:2,matches(1,:));
points2 = fb(1:2,matches(2,:));
figure; ax = axes;
showMatchedFeatures(img1,img2,points1',points2','montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');

%% Normalize all points
T1 = calSimilarityT(points1);
one = ones(1,length(points1));
p1 = T1*[points1;one];
p1 = p1(1:2,:);

T2 = calSimilarityT(points2);
one = ones(1,length(points2));
p2 = T2*[points2;one];
p2 = p2(1:2,:);

%% RANSAC
max_inliers = 0;
max_idx = 0;
iter = 1000;
k = 0;
threshold = 10;
while k < iter
    %First pick 8 point correspondences randomly 
    perm = randperm(size(points1,2));
    sel = perm(1:8);
    %calculate a normalized fundamental matrix F
    F_norm = calFundamentalMatrix(p1(:,sel), p2(:,sel));
    F_norm = T2'*F_norm*T1;
    %get the other correspondences that agree with this fundamental matrix
    [distance,inliers_index] = inliersList(F_norm, points1, points2, threshold);
    %count the number of inliers
    if max_inliers < length(inliers_index)
            max_inliers = length(inliers_index);
            max_idx = inliers_index;
    end
    %Repeat this process many times, pick the largest set of inliers obtained
    k = k + 1;
end

%% apply fundamental matrix estimation to all inliers.
F_best = calFundamentalMatrix(p1(:,max_idx), p2(:,max_idx));
F_final = T2'*F_best*T1;

%% Draw epipolar line
draw1 = points1(:,max_idx)';
draw2 = points2(:,max_idx)';
figure;
subplot(121)
imshow(img1)
title('Inliers and Epipolar Lines in First Image RANSAC'); hold on;
plot(draw1(:,1),draw1(:,2),'go');
lines1=epipolarLine(F_final',draw2); %Ax+By+C
epipoint1=lineToBorderPoints(lines1,size(img1));
line(epipoint1(:,[1,3])',epipoint1(:,[2,4])');

subplot(122); 
imshow(img2)
title('Epipolar lines in second image RANSAC'); hold on; 
plot(draw2(:,1),draw2(:,2),'go');  
lines2=epipolarLine(F_final,draw1);
epipoint2=lineToBorderPoints(lines2,size(img2));
line(epipoint2(:,[1,3])',epipoint2(:,[2,4])');
truesize;