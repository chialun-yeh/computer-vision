G=fspecial('gaussian',10,3)
imOut=conv2(img,G,'same')

imshow(magnitude, [0 100])
[magnitude, orientation] = gradmag(img, 5);
imshow(orientation, [-pi pi], 'colormap', hsv);
colorbar

%% Impulse Image
impulse = zeros(301,301);
impulse(151, 151) = 255;
G = gaussian(10);
Gd = gaussianDer(3);
c = conv2(G, G, impulse);
c1 = conv2(Gd, Gd, impulse);
min1 = min(min(c1))
max1 = max(max(c1))
imshow(c1,[min1 max1])
c2 = conv2(Gdd, Gdd, impulse);

%% Zebra
temp = zeros(size(img));
G = gaussianDer(1)
for i=1:3
     temp(:,:,i) = conv2(G,G,img(:,:,i), 'same');
end
temp = uint8(round(50*temp));
imshow(temp,[0 255])
