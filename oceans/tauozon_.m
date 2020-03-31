function tauoz = tauozon_(aoz,Hoz) 
% TAUOZON_ - Ozone optical thickness; Gregg & Carder (1990) 
% 
% Use As:  Toz   = tauozon_(ZEN,Hoz) 
%
% Input:   aoz   = ozone absorption coefficient (1/cm)  
%          Hoz   = ozone scale height (cm) eg 350 DU = 0.350 cm or 
%                  [lat lon jday] to calculate ozone scale height
%                  lat = latitude degrees (+N/-S)
%                  lon = longitude degrees (+W/-E)
%                  jday = julial day of the year (1-365)
%
% Output:  tauoz = ozone optical thickness  
% CHECK EXAMPLE FOR VALID OZONE ABSORPTION COEFFICIENT AND GIVE WAVELENGTH 
% Example: tauozon_(.034,.35)             -> 0.0119
%          tauozon_(.034,[-60 -160 180])  -> 0.0110
% 
% See Also: OZONE_, AIRMAS2_ 
%
% Ref:      Gregg and Carder, 1990. A simple spectral solar irradiance 
% model for cloudless maritime atmospheres. Limnology and Oceanography
% 35(8): 1657-1675. 
%  
% Note:   Gregg and Carder used the formula Ozone Transmittance = e^(-aoz*Hoz*Moz),
% Where Moz is the ozone atmospheric path length. Tau oz is -aoz*Hoz. Moz is not
% included in this function and must be applied separately. The ozone transmittance
% may be computed as Moz = 1.0035./sqrt((cos(ZENR).^2 +0.007)), where ZENR is the
% zenith angle in radians (Paltridge and Platt, 1976). Our function airmas2_.m can
% be used to calculate Moz. 
 
% 20 May 97; S. Flora 
% 20 Sep 97; W. Broenkow edited help 

if nargin == 0 
  help tauozone 
  return 
end 
if nargin < 1 
  disp('  TAUOZON_ Error (1 Input required)') 
  return 
end 
if nargin == 1  
  Hoz = .35;              % Global average (350 Dobson units) 
end 
 
if length(Hoz) == 3 
% Calculate the ozone_ scale height with inputs 
  Hoz = ozone_(Hoz(1),Hoz(2),Hoz(3))/1000;  % Scale height in cm, Van Heuklon 1979 
end 
 
if isempty(Hoz) 
  disp('  TAUOZON_ Error (Hoz is empty)') 
  return 
end 
 
tauoz = aoz.*Hoz;
 
 
