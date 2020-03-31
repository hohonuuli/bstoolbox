function CHL = morel_chl2(K, w)
% MOREL_CHL2 - Calulate Morel CHL as a function of Ed and Wavelength
%
% Use as: c = morel_chl2(K, w)
%
% Inputs: K   = Diffuse attenuation coefficient (1/m)
%         w   = Wavelength of Ed measurements (nm)
%
% Output: c = Chl concentration in ug/L
%
% Requires: MOREL.COEF

% Brian Schlining
% 31 Aug 1999

% Morel, A. 1988. Optical Modeling of the Upper Ocean in Relation to 
%   Its Biogenous Matter Content (Case I Waters). Journal of Geophysical
%   Research. Vol. 93, No. C9, Pages 10749-10768.

% Load a text file with all of Morels coefficients
load morel.coef

% Calculate the attenuation coefficients
%K = log(0.98 .* Ed0./EdZ)./Z;

% Get the correct coefficients for the wavelength
A = interp1(morel(:,1), morel(:,2), w);
B = interp1(morel(:,1), morel(:,3), w);
C = interp1(morel(:,1), morel(:,4), w);

% Calculate the CHL
CHL = ((K - A)./B).^(1./C);


   