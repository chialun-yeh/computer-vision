function point_view_matrix = build_point_view_matrix(new_matches)

%% Build the point-view matrix
point_view_matrix = zeros(size(new_matches,2),size(new_matches{1},2));
point_view_matrix(1,1:size(new_matches{1},2)) = new_matches{1}(1,:)';
point_view_matrix(2,1:size(new_matches{1},2)) = new_matches{1}(2,:)';

% Append matches in following frames except the last frame
for i = 2:length(new_matches)-1
    current_size = size(point_view_matrix,2);
    [C, IA, IB] = intersect(new_matches{i}(1,:)', point_view_matrix(i,:));
    [C,ia] = setdiff(new_matches{i}(1,:)', point_view_matrix(i,:));
    point_view_matrix(i+1,IB) = new_matches{i}(2,IA);
    point_view_matrix = [point_view_matrix zeros(size(point_view_matrix,1),length(ia))];
    point_view_matrix(i, current_size+1:size(point_view_matrix,2)) = new_matches{i}(1,ia);
    point_view_matrix(i+1, current_size+1:size(point_view_matrix,2)) = new_matches{i}(2,ia);
end

% Append the last frame
end