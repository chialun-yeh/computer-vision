
function [F_best,inliers_index,distance] = Normalized_Eight_point_RANSAC(points1,points2,threshold)

%init
[d length]= size(points1);
F_current = zeros(d);
max_inliers = 0;
k_max = 5000;
k = 0;

while k < k_max
    %First pick 8 point correspondences randomly 
    perm = randperm(size(points1,2));
    sel = perm(1:8);
    %calculate a normalized fundamental matrix F
    F_norm = F_normalization(points1(:,sel), points2(:,sel));
    %get the other correspondences that agree with this fundamental matrix
    [distance,inliers_index] = inliersList(F_norm, points1, points2, threshold);
    %count the number of inliers
    if isempty(inliers_index) ~= 0
        if max_inliers < length(inliers_index)
            max_inliers = length(inliers_index);
            F_current = F_norm;
        end
    end
    %Repeat this process many times, pick the largest set of inliers obtained
    k = k + 1;
end

 %apply fundamental matrix estimation step the set of all inliers.
F_best = F_normalization(points1(:,inliers_index), points2(:,inliers_index))
end