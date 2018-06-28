%% try using Ramon's
clear; clc
load('b_measurementMatrix.mat');

%% Sfm using points3
numImg = 16;
c = [1:numImg 1 2 3];
points3 = measurementMatrix(:,sum((measurementMatrix > 0),1) >= 6);
common = measurementMatrix(:,sum((measurementMatrix > 0),1) >= 8);
threeDpoints = cell(1,numImg);
commonPointIdx = cell(1,numImg);
for i = 1:numImg
    rows = [2*c(i)-1 2*c(i) 2*c(i+1)-1 2*c(i+1) 2*c(i+2)-1 2*c(i+2)];
    input = points3(rows,((points3(2*c(i)-1,:) ~= 0) & (points3(2*c(i+1)-1,:) ~= 0) & (points3(2*c(i+2)-1,:) ~= 0)));
    
    [M,S] = SfM(input);
    threeDpoints{i} = S;
end
% using points4
% for i = 1:numImg
%     rows = [2*c(i)-1 2*c(i) 2*c(i+1)-1 2*c(i+1) 2*c(i+2)-1 2*c(i+2) 2*c(i+3)-1 2*c(i+3)];
%     input = points4(rows,((points4(2*c(i)-1,:) ~= 0) & (points4(2*c(i+1)-1,:) ~= 0) & (points4(2*c(i+2)-1,:) ~= 0) & (points4(2*c(i+3)-1,:) ~= 0)));
%     % we need at least 3 points
%     if size(input,2) > 3
%         [M,S] = SfM(input);
%         threeDpoints{i} = [threeDpoints{i} S];
%     end
% end
%% Draw 3D points
%use the first set as the reference
S = threeDpoints{1};
plot3(S(1,:),S(2,:),S(3,:),'.b')
hold on 
for i = 2:numImg
    S = threeDpoints{i};
    plot3(S(1,:),S(2,:),S(3,:),'.b')
end
    