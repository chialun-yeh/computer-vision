function inliers_index = inliersList(F, p1, p2, t)
%x1: correspondences ponit 1
%x2: correspondences ponit 2
%t : threshold to determine inliers

one = ones(1,length(p1));
x1 = [p1;one]; %%?
x2 = [p2;one];

x2tFx1 = zeros(1,length(x1));

for n = 1:length(x1)
    x2tFx1(n) = x2(:,n)'*F*x1(:,n);
end
Fx1 = F*x1;
Ftx2 = F'*x2; 
% Evaluate sampson distances
d =  x2tFx1.^2 ./((Fx1(1,:).^2 + Fx1(2,:).^2 + Ftx2(1,:).^2 + Ftx2(2,:).^2));
inliers_index = find(abs(d) < t);   % Indices of inlying points	
end
	