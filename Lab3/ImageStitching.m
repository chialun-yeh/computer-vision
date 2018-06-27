addpath('C:\Users\sharo\Documents\Delft\CV\computer-vision\Lab2');

Img1 = imread('left.jpg');
Img2 = imread('right.jpg');
T = imageAlign('left.jpg', 'right.jpg')
[h, w, channel] = size(Img1);
[h2, w2, channel] = size(Img2);
if channel == 3
    gray1 = rgb2gray(Img1);
    gray2 = rgb2gray(Img2);
end
tform = maketform('affine', T');
image1_transformed = imtransform(gray1,tform, 'bicubic');
tform = maketform('affine', inv(T)' );
image2_transformed = imtransform(gray2,tform, 'bicubic');


%% Stitch image together
cornerMatrix = [ 1 w2 1 w2;
                 1 1 h2 h2;
                 1 1 1 1];

m2 = cornerMatrix' * inv(T)' ;
matrix = cat(2, cornerMatrix, m2');
maxValue = max(matrix,[],2);
x1 = 212;
x2 = 493;
y1= 16;
y2 = 369;
panorama1 = NaN([y2 x2]);
panorama2 = NaN([y2 x2]);
panorama1(1:h, 1:w) = gray1;
panorama2(y1:y2, x1:x2) = image2_transformed;

for i =1:y2
    for j = 1:x2
       pixels = [panorama1(i,j) panorama2(i,j)];
       panorama(i,j) = nanmean(pixels);
    end
end
imshow(panorama,[])


