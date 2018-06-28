
function [F_final, max_idx] = Normalized_Eight_point_RANSAC(points1,points2,threshold)

    % Normalize all points
    T1 = calSimilarityT(points1);
    one = ones(1,length(points1));
    p1 = T1*[points1;one];
    p1 = p1(1:2,:);
    T2 = calSimilarityT(points2);
    one = ones(1,length(points2));
    p2 = T2*[points2;one];
    p2 = p2(1:2,:);
    
    % RANSAC
    max_inliers = 0;
    max_idx = 0;
    iter = 1000;
    k = 0;
    while k < iter
        %First pick 8 point correspondences randomly 
        perm = randperm(size(points1,2));
        sel = perm(1:8);
        %calculate a normalized fundamental matrix F
        F_norm = calFundamentalMatrix(p1(:,sel), p2(:,sel));
        F_norm = T2'*F_norm*T1;
        %get the other correspondences that agree with this fundamental matrix
        inliers_index = inliersList(F_norm, points1, points2, threshold);
        %count the number of inliers
        if max_inliers < length(inliers_index)
            max_inliers = length(inliers_index);
            max_idx = inliers_index;
        end
        %Repeat this process many times, pick the largest set of inliers obtained
        k = k + 1;
    end

    %apply fundamental matrix estimation to all inliers.
    F_best = calFundamentalMatrix(p1(:,max_idx), p2(:,max_idx));
    F_final = T2'*F_best*T1;
    
end