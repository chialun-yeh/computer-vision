%- M: The transformation matrix size of 2nx3. Where n is the number of 
%     cameras i.e. images.
%- S: The estimated 3-dimensional locations of the points (3x#points)

function [M,S] = Sfm(points)

[framesN, pointsN] = size(points);
framesN = framesN / 2;

%Shift the mean of the points to zero using "repmat" command
pointsCenter = points - repmat(sum(points, 2) / pointsN, 1, pointsN);

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
%Cholskey factorization takes positive definite matrices by definition. 
%There is an option in MATLAB? that [R,p] = chol(L) where L is not positive definite then p is a positive integer and MATLAB? does not generate an error. 
%Note that matrix L is a symmetric matrix by construction of the affine ambiguity matrix, so make sure that L is constructed correctly. 
L = lsqnonlin(@myfun,L0);
% Recover C

% find the nearest PD matrix
Lhat = nearestSPD(L);
C = chol(Lhat,'lower');

%C = chol(L,'lower');

% Update M and S
M = M*C;
S = pinv(C)*S;
%plot3(S(1,:),S(2,:),S(3,:),'.b');

end
