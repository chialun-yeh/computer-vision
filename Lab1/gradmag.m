function [magnitude, orientation] = gradmag(img, sigma)
g = gaussianDer(sigma);
[r, c] = size(img);
gradx = zeros(r,c);
grady = zeros(r,c);
mag = zeros(r,c);
orientation = zeros(r,c);
for i = 1:r
    gradx(i,:) = conv(img(i,:), g, 'same');
end
for i = 1:c
    grady(:,i) = conv(img(:,i), g, 'same');
end
magnitude = sqrt(gradx.*gradx + grady.*grady);
thres = 30;
%binaryImg = magImg;
%binaryImg(magImg > thres) = 255;
%binaryImg(magImg <= thres) = 0;

orientation = atan2(grady,gradx);

end
