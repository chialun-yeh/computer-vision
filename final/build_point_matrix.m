function point_matrix = build_point_matrix(index, frames)
    point_matrix = zeros(6,size(index,2));
    for num = 1:3
        point_matrix( (num-1)*2 +1,:) = frames{num}(1,index(num,:));
        point_matrix( (num-1)*2 +2,:) = frames{num}(2,index(num,:));
    end
end