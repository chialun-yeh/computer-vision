function [averRGB] = threedAverRGB(point_matrix_cell,images)
%point_matrix_cell: 1x19
%image_cell: 1x19
%averRGB: 1x19 cell
averRGB = cell(size(point_matrix_cell));
c = [1:length(images) 1 2];

% iterate images
for i = 1:length(point_matrix_cell)
    twoDpoints = point_matrix_cell{i};
    num = length(twoDpoints(:,1))/2;
    averRGB_i = zeros(num,length(twoDpoints));
    
    % iterate matches per image
    for j = 1:length(twoDpoints)
        redValue = 0;
        greenValue = 0;
        blueValue = 0;
        
        % get rgb per matches
        for k = 1:num
            positionx = round(twoDpoints(k,j));
            positiony = round(twoDpoints(k+1,j));
            redValue = redValue + images{c(i+k-1)}(positiony, positionx, 1);
            greenValue = greenValue + images{c(i+k-1)}(positiony, positionx, 2);
            blueValue = blueValue + images{c(i+k-1)}(positiony, positionx, 3);
        end
        redValue = images{i}(positiony, positionx, 1);
        greenValue = images{i}(positiony, positionx, 2);
        blueValue = images{i}(positiony, positionx, 3);
        averRGB_i(:,j) = [uint8(redValue); uint8(greenValue) ; uint8(blueValue)];
        
        % take average rgb 
        %averRGB_i(:,j) = [redValue/num; greenValue/num ; blueValue/num];
        
    end
    averRGB{i} = averRGB_i;
end      
end