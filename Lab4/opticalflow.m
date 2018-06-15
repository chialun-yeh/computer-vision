%function F = flow(im1,im2)
% calculates the optical flow between images im1 and im2
%
%INPUT
%- im1: first image (in time) should be in black and white
%- im2: second image (in time) should be in black and white
%- sigma: how much you smooth the image
%
%OUTPUT
%- F: vector of flows
%- ind: indexes of the flow vectors
function [F,ind] = opticalflow(im1, im2, sigma)
addpath('C:\Users\sharo\Documents\Delft\CV\computer-vision\Lab1')
% if no images are provided load standard images
if nargin < 1
    im1 = imread('sphere1.ppm');
    im2 = imread('sphere2.ppm');
    sigma = 1;
end

% convert images to double precision
im1 = double(im1);
im2 = double(im2);

% devide regions
[h,w] = size(im1);

hDevide = floor(h/15);
wDevide = floor(w/15);

%Calculate the center coordinates of the regions
ind = zeros(hDevide,wDevide,2);
ind(:,:,1) = repmat((0:wDevide-1)',1,hDevide)*15+7.5;
ind(:,:,2) = repmat((0:hDevide-1),wDevide,1)*15+7.5;

%Find image derivatives
Gd = gaussianDerivative(sigma);
Ix = ImageDerivatives(im1, sigma, 'x');
Iy = ImageDerivatives(im1, sigma, 'y');
It = im1-im2;

%For every patch find flow vector and store in F
F = zeros(hDevide,wDevide,2);
for i=0:hDevide-1
    for j=0:wDevide-1
        % make a matrix consisting of derivatives along the patch
        Ax = Ix(1+15*i:15+15*i,1+15*j:15+15*j);
        Ay = Iy(1+15*i:15+15*i,1+15*j:15+15*j);
        A = [Ax(:) Ay(:)];
        % make b matrix consisting of derivatives in time
        b = It(1+15*i:15+15*i,1+15*j:15+15*j);
        b = b(:);
        v = inv(A'*A)*A'*b;
        F(i+1,j+1,:) = v;
    end
end

end