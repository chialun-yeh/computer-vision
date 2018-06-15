%% Lab5: Epipolar Geometry
% We calculate the fundamental matrix F betwenn 2 images
img1 = imread('TeddyBear/obj02_001.jpg');
img2 = imread('TeddyBear/obj02_002.jpg');
I1 = single(rgb2gray(img1)) ;
I2 = single(rgb2gray(img2)) ;

% Compute the SIFT keypoints and descriptors
% The matrix f has a column for each keypoint: center f(1:2), scale f(3) and orientation f(4). 
[fa, da] = vl_sift(I1,'PeakThresh',8) ;
[fb, db] = vl_sift(I2,'PeakThresh',8) ;

% Check the keypoints
imshow(img1)
h1 = vl_plotframe(fa);
h2 = vl_plotframe(fa);
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;

% Match the keypoints using the descriptors
[matches, scores] = vl_ubcmatch(da, db, 1) ;
% points1 = fa(1:3,matches(1,:));
% points2 = fb(1:3,matches(2,:));
points1 = fa(1:2,matches(1,:));
points2 = fb(1:2,matches(2,:));
figure; ax = axes;
showMatchedFeatures(img1,img2,points1',points2','montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');

% Use 30 of the points to calculate F
perm = randperm(size(matches,2));
sel = perm(1:30);
F = calFundamentalMatrix(points1(:,sel), points2(:,sel));

%% Normalization
T1 = calSimilarityT(points1(:,sel));
one = ones(1,length(points1(:,sel)));
p1 = T1*[points1(:,sel);one];
p1 = p1(1:2,:);
T2 = calSimilarityT(points2(:,sel));
one = ones(1,length(points2(:,sel)));
p2 = T2*[points2(:,sel);one];
p2 = p2(1:2,:);

% calculate new F
F_norm = calFundamentalMatrix(p1, p2);
%denormalize
F_norm = T2'*F_norm*T1;

%% Normalized Eight-point Algorithm with RANSAC
threshold = 1000;
[F_best,inliers_index] = Normalized_Eight_point_RANSAC(points1, points2,threshold);

