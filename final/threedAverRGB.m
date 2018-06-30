function [averRGB] = threedAverRGB(point_matrix_cell,images)
%point_matrix_cell: 1x19
%image_cell: 1x19
%averRGB: 1x19 cell
averRGB = cell(size(point_matrix_cell));
c = [1:length(images) 1 2];

% iterate images
for i = 1:length(point_matrix_cell)
    twoDpoints = round(point_matrix_cell{i});
    num = length(twoDpoints(:,1))/2;
    averRGB_i = zeros(num,length(twoDpoints));
    
    % iterate matches per image
    for j = 1:size(twoDpoints,2)
        redValue = 0;
        greenValue = 0;
        blueValue = 0;
        
        % get rgb per matches
         for k = 1:num
             positionx = twoDpoints(2*k-1,j);
             positiony = twoDpoints(2*k,j);
             redValue = redValue + images{c(i+k-1)}(positiony, positionx, 1)/3;
             greenValue = greenValue + images{c(i+k-1)}(positiony, positionx, 2)/3;
             blueValue = blueValue + images{c(i+k-1)}(positiony, positionx, 3)/3;
         end     

        averRGB_i(:,j) = [redValue; greenValue ; blueValue];
        
    end
    averRGB{i} = averRGB_i;
end      
end