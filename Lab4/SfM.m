%OUTPUT
% an image showing the points in their estimated 3-dimensional position,
% where the yellow dots are the ground truth and the pink dots the tracked
% points from the LKtracker
%- M: The transformation matrix size of 2nx3. Where n is the number of 
%     cameras i.e. images.
%- S: The estimated 3-dimensional locations of the points (3x#points)
function [M,S] = Sfm()
[framesN, pointsN] = size(Points);
framesN = framesN / 2;

%Shift the mean of the points to zero using "repmat" command
pointsCenter = Points - repmat(sum(Points, 2) / pointsN, 1, pointsN);

% % %singular value decomposition
[U,W,V] = svd(pointsCenter);
M = U(:, 1:3) * sqrt(W(1:3, 1:3));
S = sqrt(W(1:3, 1:3)) * V(:, 1:3)';
save('M','M')
% % %solve for affine ambiguity
A = M;
L0 = inv(A' * A);
%L0 = pinv(A) * eye(2*framesN)*pinv(A');
% Solve for L
L = lsqnonlin(@myfun,L0);
% Recover C
C = chol(L,'lower');
% Update M and S
M = M*C;
S = pinv(C)*S;
plot3(S(1,:),S(2,:),S(3,:),'.b');

end
