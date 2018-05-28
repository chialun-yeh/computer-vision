function F = ImageDerivatives(img, sigma, type)
a = 3*sigma;
x = -a:1:a;
[r, c] = size(img);
F = zeros(r,c);
tmp = zeros(r,c);
g = gaussianDerivative(sigma);
Gdd = ((-sigma^2 + x.^2)./sigma^4).*gaussian(sigma);
switch type
    case 'x'
        for i = 1:r
            F(i,:) = conv(img(i,:), g, 'same');
        end
    case 'y'
        for i = 1:c
            F(:,i) = conv(img(:,i), g, 'same');
        end
    case 'xx'
        for i = 1:r
            F(i,:) = conv(img(i,:), Gdd, 'same');
        end
    case 'yy'
        for i = 1:c
            F(:,i) = conv(img(:,i), Gdd, 'same');
        end
    case'xy'
        for i = 1:r
            tmp(i,:) = conv(img(i,:), g, 'same');
        end
        for i = 1:c
            F(:,i) = conv(tmp(:,i), g, 'same');
        end
    case'yx'
        for i = 1:c
            tmp(:,i) = conv(img(:,i), g, 'same');
        end
        for i = 1:r
            F(i,:) = conv(tmp(i,:), g, 'same');
        end
end
end