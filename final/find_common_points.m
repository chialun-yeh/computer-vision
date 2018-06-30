function commonPoints = find_common_points(points3, common)
numImg = size(common,1);
commonPoints = cell(1,numImg);
c = [1:numImg 1 2 3];
for i = 1:numImg
    twoDpoints1 = points3([c(i) c(i+1) c(i+2)], ((points3(c(i),:) ~= 0) & (points3(c(i+1),:) ~= 0) & (points3(c(i+2),:) ~= 0)) );
    twoDpoints2 = points3([c(i+1) c(i+2) c(i+3)], ((points3(c(i+1),:) ~= 0) & (points3(c(i+2),:) ~= 0) & (points3(c(i+3),:) ~= 0)) );
    commonpoints = common([c(i) c(i+1) c(i+2) c(i+3)], ((common(c(i),:) ~= 0) & (common(c(i+1),:) ~= 0) & (common(c(i+2),:) ~= 0) & (common(c(i+3),:) ~= 0)) );
    % eliminate repeating values in common
    [~,IA,IC] = unique(commonpoints(1,:));
    commonpoints = commonpoints(:,IA);
    % 
    [~, idx1, idx2] = intersect(twoDpoints1(1,:), commonpoints(1,:));  
    [~, idx3, idx4] = intersect(twoDpoints2(1,:), commonpoints(2,:)); 
    mat = zeros(2,length(idx1));
    for id = 1:length(idx2)
        mat(1,id) = idx1(idx2()==id);
        mat(2,id) = idx3(idx4==id);
    end
    commonPoints{i} = mat;
end
end