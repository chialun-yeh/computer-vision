function [averRGB] = threedAverRGB(point_matrix_cell,image_cell)
%point_matrix_cell: 1x19
%image_cell: 1x19
%averRGB: 1x19 cell
averRGB = cell(size(point_matrix_cell))

% iterate images
for i = 1:length(point_matrix_cell)
    
    twoDpoints = point_matrix_cell{i};
    image = image_cell{i};
    num = length(twoDpoints(:,1))/2;
    averRGB_i = zeros(num,length(twoDpoints));
    
    % iterate matches per image
    for j = 1:length(twoDpoints)
        redValue = 0;
        greenValue = 0;
        blueValue = 0;
        
        % get rgb per matches
        for k = 1:num
            position = twoDpoints(k:(k+1),j);
            redValue = redValue + image(position(2), position(1), 1);
            greenValue = greenValue + image(position(2), position(1), 2);
            blueValue = blueValue + image(position(2), position(1), 3);
        end
        % take average rgb 
        averRGB_i(:,j) = [redValue/num; greenValue/num ; blueValue/num]
    end
    averRGB{i} = averRGB_i;
end      
end