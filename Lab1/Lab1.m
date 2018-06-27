img = imread('zebra.png');
imgR = img(:,:,1);
%% Do a Gaussian filtering using Matlab built-in function
sigma = 3;
G = fspecial('gaussian',10, sigma);
imOut = conv2(imgR,G,'same');
figure(1)
montage([imgR, imOut]);
title('Gaussian Filtering using Matlab function')

%% Do a Gaussian filtering using self-written Gaussian
imOut = gaussianConv(imgR, sigma, sigma);
figure(2)
montage([imgR, imOut]);
title('Gaussian Filtering using self-written function')

%% Finf gradient
[magnitude1, orientation1] = gradmag(imgR, 3);
[magnitude2, orientation2] = gradmag(imgR, 5);
[magnitude3, orientation3] = gradmag(imgR, 10);
%% Show results
subplot(2,3,1), imshow(magnitude1,[])
hold on 
title('Magnitude of the gradient (sigma = 3)')
subplot(2,3,2), imshow(magnitude2,[])
title('Magnitude of the gradient (sigma = 5)')
subplot(2,3,3), imshow(magnitude3,[])
title('Magnitude of the gradient (sigma = 10)')

subplot(2,3,4), imshow(orientation1, [-pi pi], 'colormap', hsv);
title('Orientation of the gradient (sigma = 3)')
colorbar;
subplot(2,3,5), imshow(orientation2, [-pi pi], 'colormap', hsv);
title('Orientation of the gradient (sigma = 5)')
colorbar;
subplot(2,3,6), imshow(orientation3, [-pi pi], 'colormap', hsv);
title('Orientation of the gradient (sigma = 10)')
colorbar;

%% Impulse Image
impulse = zeros(301,301);
impulse(151, 151) = 255;
G = gaussian(sigma);
Gd = gaussianDerivative(sigma);
c2 = ImageDerivatives(impulse, sigma, 'xy');
c = conv2(G, G, impulse);
c1 = conv2(Gd, Gd, impulse);
subplot(1,3,1), imshow(c,[])
hold on
title('Impulse response of Gaussian')
subplot(1,3,2), imshow(c1,[])
title('Impulse response of derivative of Gaussian')
subplot(1,3,3), imshow(c2,[])
title('Impulse response of second derivative of Gaussian')


%% Try some image filtering
sigma=3;
gaus = gaussianConv(imgR, sigma, sigma);
Gd = gaussianDerivative(sigma);
derGau = conv2(Gd, Gd, imgR);
second = ImageDerivatives(imgR, sigma, 'xy');

subplot(2,4,1), imshow(imgR,[])
hold on
title('Original Image')
subplot(2,4,2), imshow(gaus,[])
title('Gaussian (sigma=3)')
subplot(2,4,3), imshow(derGau,[])
title('Derivative of Gaussian (sigma=3)')
subplot(2,4,4), imshow(second,[])
title('Second derivative of Gaussian (sigma=3)')

sigma = 7;
gaus = gaussianConv(imgR, sigma, sigma);
Gd = gaussianDerivative(sigma);
derGau = conv2(Gd, Gd, imgR);
second = ImageDerivatives(imgR, sigma, 'xy');

subplot(2,4,6), imshow(gaus,[])
title('Gaussian (sigma=7)')
subplot(2,4,7), imshow(derGau,[])
title('Derivative of Gaussian (sigma=7)')
subplot(2,4,8), imshow(second,[])
title('Second derivative of Gaussian (sigma=7)')

