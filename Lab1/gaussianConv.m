%Convolve an image with 2 separate 1D Gaussian kernal
function imOut = gaussianConv(img, sigma_x, sigma_y)
[r, c] = size(img);
F = zeros(r,c);
x = gaussian (sigma_x);
y = gaussian (sigma_y);
for i = 1:r
    F(i,:) = conv(img(i,:), x, 'same');
end
for i = 1:c
    F(:,i) = conv(F(:,i), y, 'same');
end
imOut = F;
end