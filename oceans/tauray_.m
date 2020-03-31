function taur = tauray_(lambda) 
% tauray_ - Rayleigh optical thickness f(wavelength); Bird & Riordan (1986) 
% 
% Use As:  taur    = tauray_(lambda) 
%  
% Input:   lambda  = wavelength (nm)  
% Output:  taur    = Rayleigh scattering optical thickness 
%
% Example: tauray_(443) -> 0.2286
% 
% Ref: Bird and Riordan, 1986. Simple Solar Spectral Model for 
%      direct and diffuse irradiance on horizontal and tilted 
%      planes at the earth's surface for cloudless atmospheres. 
%      J. CLimatol. Appl. Meteorol. 25: 87-97. 
% 
% See Also: TAURAY1_ TAURAY2_ 
 
% 24 Jan 97; M. Feinholz  
% 29 Jan 97; M. Feinholz 
% 20 May 97; S. Flora removed M and Mprime 
 
% Paper the equations were found in: Gregg and Carder, 1990. A simple spectral solar  
% irradiance model for cloudless maritime atmospheres. Limnology and Oceanography 35(8): 1657-1675. 
% 
% Note: In the Gregg and Carder Paper the formula was 
%       Transmittance_r = e^(-Mprime/(115.6406*lambda^4 - 1.335*lambda^2)).  
%       where Mprime is the rayleigh atmospheric path length corrected for 
%       nonstandard pressure. taur is the above eq without Mprime and (-1). Mprime is 
%       applied to taur to get transmittance. 

%  M = 1/(cos(ZENR)+0.15*(93.885-ZENR)^(-1.253));        G&C(90) eq 13 
%  Mprime = path length corrected for nonstandard atmospheric pressure 
%  Mprime = M*P/Po;                                      G&C(90) eq 16 
%  Po     = 1013.25 mbars, P = atmospheric pressure 
%  airmas1_.m is the Matlab program that calculates Mprime 
 
if nargin == 0 
  help tauray_
  return 
end 
 
% tauR = Rayleigh total scattering coefficient 
% NOTE: wavelength in um ! 
 
taur = 1./(115.6406.*(lambda./1E3).^4-1.335.*(lambda./1E3).^2);  % G&C(90) eq 15 
 
 
