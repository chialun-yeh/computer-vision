function G = gaussian (sigma)
a = 3*sigma;
x = -a:1:a;
G = (1/(sigma*sqrt(2*pi)))*exp(-x.^2./(2*sigma^2));
end