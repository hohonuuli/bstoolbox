function K = calc_k(EdTop,EdBottom,dZ)
% CALC_K   - Calculate the diffuse attenuation coefficient profile
%
% Use as: K = calc_k(EdTop, EdBottom, dZ)
% 
% Inputs: EdTop    = Downwelled Irradiance (Shallower than EdBottom) 
%         EdBottom = Downwelled Irradiance  
%         dZ       = Depths difference between Ed sensors (m) 
%                    This function uses abs(dZ) for calculations. So depth can be 
%                    negative or positive. For example, if EdTop is at 3m depth
%                    and EdBottom is at 13m depth, dZ can be used as -10m or 10m.
%      
% Output: K  = Diffuse attenuation coefficeint (1/m)
%
% Note: The units of Ed are not important as long as they both 
%  use the same units. Also Lu's may be substituted for Es and Ed's. 
% 
%
% If using Es as EdTop, don't forget to loss throught the air-sea interface due to reflection.
% This loss is  afunction of solar angle. To calculate loss due to reflectance use
% 1 - fresnel_(solarzenith(GMTDateNumber, lat, long))

% Brian Schlining
% 09 Dec 1999

K = -(log(EdTop./EdBottom))./(-abs(dZ));

