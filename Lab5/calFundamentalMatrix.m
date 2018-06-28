function F_new = calFundamentalMatrix(points1, points2)
x1 = points1(1,:);
y1 = points1(2,:);
x2 = points2(1,:);
y2 = points2(2,:);
one = ones(length(points1),1);

%compute A
A = [(x1.*x2)' (x1.*y2)' x1' (y1.*x2)' (y1.*y2)' y1' x2' y2' one];
[U,S,V] = svd(A);

%F is the colume of V corresponding to the smallest singular value
F = reshape(V(:,9),[3 3]);

%enforce singularity of F
[Uf, Sf, Vf] = svd(F);
Sf(3,3) = 0;
F_new = Uf*Sf*Vf';

end