function pointsXY = getInliersXY(frame,newmatches)
%% assume the frame cell and image cell has the same index 
l = length(newmatches)
pointsXY = cell(1,l);
for i = 1:l
    matches = newmatches{i}
    points1 = frame{i}(1:2,matches(1,:));
    points2 = frame{i+1}(1:2,matches(2,:));
    pointsXY{i} = [points1;points1]
end
end