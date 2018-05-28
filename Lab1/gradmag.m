%Calculate magnitude and orientation of gradient image
function [magnitude, orientation] = gradmag(img, sigma, showBinary, threshold)
if nargin == 3
    showBinaryImage = showBinary;
    thres = 30;
elseif nargin == 4
    showBinaryImage = showBinary;
    thres = threshold;
else
    showBinaryImage = false;
    thres = 30;
end

Gd = gaussianDerivative(sigma);
[r, c] = size(img);
gradx = zeros(r,c);
grady = zeros(r,c);
for i = 1:r
    gradx(i,:) = conv(img(i,:), Gd, 'same');
end
for i = 1:c
    grady(:,i) = conv(img(:,i), Gd, 'same');
end
magnitude = sqrt(gradx.*gradx + grady.*grady);
orientation = atan2(grady,gradx);

if showBinaryImage
    binaryImg = magImg;
    binaryImg(magImg > thres) = 255;
    binaryImg(magImg <= thres) = 0;
    imshow(binaryImg)
end

end
