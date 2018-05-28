%Convolve an image with GaussianDerivative kernal
function imOut = gaussianConv(img_path, sigma_x, sigma_y)
img = imread(img_path);
imOut = conv2(gaussianDerivative(sigma_y), gaussianDerivative(sigma_x), img, 'same');
end