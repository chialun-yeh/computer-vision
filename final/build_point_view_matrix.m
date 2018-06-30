function point_view_matrix = build_point_view_matrix(new_matches)
numFrame = length(new_matches);

% Build the point-view matrix
point_view_matrix = zeros(numFrame+1,size(new_matches{1},2));
point_view_matrix(1,1:size(new_matches{1},2)) = new_matches{1}(1,:)';
point_view_matrix(2,1:size(new_matches{1},2)) = new_matches{1}(2,:)';
tmp = size(point_view_matrix,2);
% Append matches in following frames except the last frame
for i = 2:numFrame
    current_size = size(point_view_matrix,2);
    [C, IA, Ib] = intersect(new_matches{i}(1,:)', point_view_matrix(i,:));
    [C,ia] = setdiff(new_matches{i}(1,:)', point_view_matrix(i,:));
    point_view_matrix(i+1,Ib) = new_matches{i}(2,IA);
    point_view_matrix = [point_view_matrix zeros(size(point_view_matrix,1),length(ia))];
    point_view_matrix(i, current_size+1:size(point_view_matrix,2)) = new_matches{i}(1,ia);
    point_view_matrix(i+1, current_size+1:size(point_view_matrix,2)) = new_matches{i}(2,ia);
end
% Append the last frame
% match 16-1 with current 16
[~, b, a] = intersect(point_view_matrix(numFrame+1,:)', point_view_matrix(1,1:tmp));
point_view_matrix(numFrame-2:numFrame,a) = point_view_matrix(numFrame-2:numFrame,b);
point_view_matrix(:,b) = [];
point_view_matrix = point_view_matrix(1:numFrame,:);
id = find((sum(point_view_matrix > 0, 1) < 2)~=0, 1);
point_view_matrix = point_view_matrix(:,1:id);

end