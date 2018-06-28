function [optimal_M,optimal_S]= bundle_adjustment_lsqnonlin(point_matrix_cell,threeDpoints,camera)

point_matrix = cell2Matrix(point_matrix_cell);
threeDpoints_matrix = cell2Matrix(threeDpoints);

MS = [];
for i = 1:length(camera)
    a = camera(:,:,i);
    b = threeDpoints_matrix(:,:,i)';
    MS(:,:,i) = [a;b];
end

lsqnonlinoptions=optimset('Algorithm','Levenberg-Marquardt');
optimal_MS = lsqnonlin(@(x)bundle_adjustment2(x,point_matrix),MS,[],[],lsqnonlinoptions);

optimal_M = [];
optimal_S = [];

for i = 1:size(optimal_MS,3)
    MS_i = optimal_MS(:,:,i);
    optimal_M(:,:,i) = MS_i(1:6,:);
    optimal_S(:,:,i) = MS_i(7:end,:)';
end

end