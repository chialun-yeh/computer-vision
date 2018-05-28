function T = calSimilarityT(points)
mx = mean(points(1,:));
my = mean(points(2,:));
d = mean(sqrt((points(1,:)-mx).^2 + (points(2,:)-my).^2));
T = [sqrt(2)/d 0 -mx*sqrt(2)/d;
     0 sqrt(2)/d -my*sqrt(2)/d;
     0          0             1];
end