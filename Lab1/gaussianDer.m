function Gd = gaussianDer(sigma)
a = 3*sigma;
x = -a:1:a;
Gd = (x./sigma^2).*gaussian(sigma);
end