function K = morel_k(Chl, lambda)
% MOREL_CHL - Model K as a function of Chl and Wavelength
%
% Use as: K = morel_k(Chl, labmda)
%
% Inputs: Chl = chlorophyll concentration (scalar) in mg/m3 or ug/l
%         w   = Wavelength (can be a vector or a scalar) in nanometers
%
% Output: K = Attenuation coefficient at wavelengths in w
%
% Requires: MOREL.COEF

% Brian Schlining
% 31 Aug 1999
%
% Morel, A. 1988. Optical Modeling of the Upper Ocean in Relation to 
%   Its Biogenous Matter Content (Case I Waters). Journal of Geophysical
%   Research. Vol. 93, No. C9, Pages 10749-10768.

% Load a text file with all of Morels coefficients into variable morel
load morel.coef 

K = ones(size(lambda))*NaN;   % Initalize memory

for i = 1:length(lambda)
   
   % Get the correct coefficients for the wavelength
   A = interp1(morel(:,1), morel(:,2), lambda(i));
   B = interp1(morel(:,1), morel(:,3), lambda(i));
   C = interp1(morel(:,1), morel(:,4), lambda(i));
   
   % K(lambda) = Kw(lambda) + Chi(lambda)*Chl^e(lambda)
   K(i) = A + B*Chl^C;
   
end
