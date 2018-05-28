%Generation of a Gaussain kernal.
% Gd =  gaussianDerivative(sigma);
%
% INPUT
%   sigma   Standard deviation of the Gaussian to be derived       
% OUTPUT
%   Gd      A discrete first order derivative of Gaussian kernal with size 2*(3*sigma)+1

function Gd = gaussianDerivative(sigma)
a = 3*sigma;
x = -a:1:a;
Gd = sigma.*(x./sigma^2).*gaussian(sigma);
end