function imOut = gaussianConv(img_path, sigma_x, sigma_y)
img = imread(img_path);
c = conv2(gaussianDer(sigma_y), gaussianDer(sigma_x), img,'same');
end