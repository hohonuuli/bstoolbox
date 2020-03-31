function AMprime = airmas1_(ZEN,P) 
 
% airmas1_ - Atmospheric thickness for all constituents; Kasten (1966) 
% 
% Atmospheric thickness or path length calculated using Kastens (1966) 
% empirical formula.  The airmass_ is valid for all angles (by correcting 
% for the sphericity of the earth) and can be corrected for nonstandard 
% atmospheric pressure. 
% 
% Use As:   AM  = airmas1_(ZEN,P) 
%
% Input:    ZEN = solar zenith angle (deg) 
%           P   = nonstandard atmospheric pressure (mbar) 
%                 if not input P = 1013.25 mbar standard atmospheric pressure 
% Output:   AM  = Atmospheric thickness 
% 
% Example:  airmas1_([45 85]) ->  1.4132 11.4061 
% 
% ref Kasten (1966) Arch. Meteorol. Geophys. Bioklimatol. B14: 206-223 
% See Also: AIRMASS, AIRMAS2_
 
% 15 May 97; Stephanie Flora 
 
if nargin == 0 
  help airmass1 
  return 
end 
Po = 1013.25;                     % standard atmospheric pressure (mbar) 
if nargin == 1 
  P = 1013.25; 
end 
 
% M = Atmospheric path length (slant path through the atmosphere) 
% may be expressed as M = 1/cos(ZEN) for ZEN < 75 deg 
% but a correction for the sphericity of the earth-atomosphere system 
%  is required at larger zenith angles. 
% ref Kasten (1966) Arch. Meteorol. Geophys. Bioklimatol. B14: 206-223 
% Mprime = path length corrected for nonstandard atmospheric pressure 
 
ZENR = (pi./180).*ZEN; 
     AM = 1./(cos(ZENR)+0.15*(93.885-ZENR).^(-1.253));  % G&C(90) eq 13 
AMprime = AM.*(P./1013.25); 
 
