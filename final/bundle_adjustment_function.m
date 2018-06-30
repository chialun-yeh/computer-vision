function E = bundle_adjustment_function(MS,point_matrix)%(threeDpoints,camera) 
% camera: 6 x 3 x num_frame
% threeDpoints: 3d points (3 x max_col x num_frame)
% point_matrix: 3 2d points in images (6 x max_col x num_frame)
% project:  6 x max_col x num_frame
% Error to minimize
E = [];

[m n numImg] = size(point_matrix);

for i = 1:numImg
    MS_i = MS(:,:,i);
    M = MS_i(1:m,:);
    S = MS_i(m+1:end,:)';
    dis = M*S - point_matrix(:,:,i);
    %error =  sum(sum( (M*S - point_matrix(:,:,i)).^2));
    E = [E,dis];
end 

% then Using lsqnonlin Matlab function.
end