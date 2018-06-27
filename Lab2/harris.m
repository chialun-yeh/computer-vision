function [r, c] = harris(img, sigma)
% inputs: 
% img: double grayscale image
% sigma: integration-scale
% outputs:  The row and column of each point is returned in r and c
% This function finds Harris corners at integration-scale sigma.
% The derivative-scale is chosen automatically as gamma*sigma

gamma = 0.7; % The derivative-scale is gamma times the integration scale
dScale = gamma*sigma;

% Calculate Gaussian Derivatives at derivative-scale
Ix = conv2(img, gaussianDerivative(dScale), 'same');
Iy = conv2(img, gaussianDerivative(dScale)', 'same');

% Allocate an 3-channel image to hold the 3 parameters for each pixel
M = zeros(size(Ix,1), size(Ix,2), 3);

% Calculate M for each pixel
M(:,:,1) = Ix.*Ix;
M(:,:,2) = Ix.*Iy;
M(:,:,3) = Iy.*Iy;

% Smooth M with a gaussian at the integration scale sigma.
M = imfilter(M, fspecial('gaussian', ceil(sigma*6+1), sigma), 'replicate', 'same');

% Compute the cornerness R
k=0.05; % empirical 0.04-0.06
trace = M(:,:,1)+ M(:,:,3);
det = M(:,:,1).*M(:,:,3)-(M(:,:,2).* M(:,:,2));
R = zeros(size(Ix,1), size(Ix,2));
R = det- (k.*(trace.^2));

% Set the threshold 
threshold = 0.01*max(max(R));

% Find local maxima
% Dilation will alter every pixel except local maxima in a 3x3 square area.
% Also checks if R is above threshold
R_thres = ((R>threshold) & ((imdilate(R, strel('square', 3))==R))) ; %.* sigma;

% Display corners
%figure
%imshow(R_thres,[]);

% Return the coordinates
[r,c] = find(R_thres);

end
