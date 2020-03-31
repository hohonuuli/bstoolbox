function taur = tauray1_(lambda) 
% TAURAY1_ - Rayleigh optical thickness f(wavelength); Gordon et al. (1988) 
% 
% Use As:  taur   = tauray1_(lambda)
%   
% Inputs:  lambda = wavelength (nm)  
% Outputs: taur   = Rayleigh scattering optical thickness 
%
% Example: tauray1_(443) -> 0.2361
% 
% Ref: Hansen and Travis (1974) Space Sci. Rev. 16, 527- 
%  via Gordon, Brown, Evans (1988) Applied Optics 27(5)862- 
% 
% See Also: TAURAY_, TAURAY2_ 
 
% 05 Feb 97; M.Feinholz 
% 22 May 97; S. Flora   Removed P/Po 
 
if nargin == 0 
  help tauray1_ 
  return 
end 
 
% Gordon et al (1988) Eq. 7 
% tauR0 = Rayleigh scattering optical thickness at standard atmospheric pressure 
% derived by Hansen and Travis (1974) using the depolarization factor delta_ = 0.031 
% NOTE: wavelength in um 
 
taur = 0.008569.*(lambda/1000).^(-4).*(1 + 0.0113.*(lambda/1000).^(-2) + 0.00013.*(lambda/1000).^(-4)); 
 
