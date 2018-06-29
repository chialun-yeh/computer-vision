function [optimal_M,optimal_S] = local_bundle_adjustment_lsqnonlin(point_matrix_cell,threeDpoints,camera)

point_matrix = cell2Matrix(point_matrix_cell);
threeDpoints_matrix = cell2Matrix(threeDpoints);

MS = [];
op_MS = [];

for i = 1:length(camera)
    a = camera(:,:,i);
    b = threeDpoints_matrix(:,:,i)';
    MS(:,:,i) = [a;b];

disp(['start optimization: frame', num2str(i)]);

lsqnonlinoptions=optimset('Algorithm','Levenberg-Marquardt');
optimal_MS = lsqnonlin(@(x)bundle_adjustment_function(x,point_matrix(:,:,i)), MS(:,:,i),[],[],lsqnonlinoptions);
op_MS(:,:,i) = optimal_MS;
end

optimal_M = [];
optimal_S = [];

disp('start reconstruct M and S');

for i = 1:size(op_MS,3)
    MS_i = op_MS(:,:,i);
    optimal_M(:,:,i) = MS_i(1:6,:);
    optimal_S(:,:,i) = MS_i(7:end,:)';
end
end