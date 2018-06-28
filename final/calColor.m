function averRGB = calColor(point_matrix_cell,images)
c = [1:length(image) 1 2];
averRGB = cell(size(point_matrix_cell));
num = 3;
for i = 1:length(images)
    points = point_matrix_cell{i};
    color = zeros(3,size(points,2),3);
    
    % round all coordinate to integer
    points = round(points);
       
    % get rgb per matches
    for k = 1:num
        color(1,:,k) = images{c(i+k-1)}(points(2,:), points(1,:), 1);
        color(2,:,k) = images{c(i+k-1)}(points(2,:), points(1,:), 2);
        color(3,:,k) = images{c(i+k-1)}(points(2,:), points(1,:), 3);
    end
    averRGB{i} = mean(color,1);
end

end