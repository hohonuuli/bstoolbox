function AM = airmas2_(ZEN) 
 
% AIRMAS2_ - Atmospheric thickness for ozone (Platridge & Platt,1976) 
% 
% Ozone requires a slightly longer path length or atmospheric thickness  
% than for the major atmospheric constituents. Paltridge and Platt's (1976)
% formula is used to calculate ozone optical thickness.  The airmass is
% valid for all angles. 
% 
% Use As:   AM  = airmas2_(ZEN)
% 
% Input:    ZEN = solar zenith angle (deg) 
% Output:   AM  = ozone Atmospheric thickness 
% 
% Example:  airmas2_([45 85]) -> 1.4093 8.3061 
% 
% Ref: Paltridge and Platt, 1976. Radiative Processes in Meteorology  
%      and Climatology. Elsevier. 
% See Also: AIRMASS, AIRMAS1_
 
% 15 May 1997; Stephanie Flora 
 
ZENR = (pi/180).*ZEN; 
AM   = 1.0035./(cos(ZENR).^2 + 0.007).^.5;  % G&C(90) eq 14  
 
