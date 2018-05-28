%Generation of a Gaussain kernal.
% G =  gaussian(sigma);
% INPUT
%   sigma   Standard deviation of the Gaussian       
%
% OUTPUT
%   G       A discrete Gaussian kernal with size 2*(3*sigma)+1

function G = gaussian (sigma)
a = 3*sigma;
x = -a:1:a;
G = (1/(sigma*sqrt(2*pi)))*exp(-x.^2./(2*sigma^2));
end