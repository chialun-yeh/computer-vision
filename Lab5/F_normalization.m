function F_norm = F_normalization(points1,points2)
T1 = calSimilarityT(points1);
one = ones(1,length(points1));
p1 = T1*[points1;one];
p1 = p1(1:2,:);

T2 = calSimilarityT(points2);
one = ones(1,length(points2));
p2 = T2*[points2;one];
p2 = p2(1:2,:);

% calculate new F
F_norm = calFundamentalMatrix(p1, p2);
%denormalize
F_norm = T2'*F_norm*T1;
end