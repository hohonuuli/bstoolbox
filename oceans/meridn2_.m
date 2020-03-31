function [mp] = meridn2_(lat) 
% MERIDN2_ - Meridional parts for Clark spheroid used in rhumb-line distance & Mercator charts 
% 
% Use As:   mp  = meridn2_(lat) 
% Input:    lat = Latitude (decimal degrees) 
% Output:   mp  = Meridional parts (minutes of latitude per degree longitude) 
% 
% Example:  meridn2_(45) ->  3013.5 
% 
% See Also: MERIDN1_, INVMERD_, RHUMBL_, MRCTMAP_, DEADRKN_  
% Ref: H.O. 9 (1958) American Practical Navigator page 1187 

% MP = r*ln(tan(pi/4 + lat/2) - r*(e^2*sin(lat + e^4*sin^3(lat)/3 + e^6*sin^5(lat)/5)) 
%      where r = equatorial radius of earth: 3437.747 minutes of arc at the equator = nautical miles 
%            e = ellipticity of the earth:   0.0822717 = sqrt(2*f-f^2) 
%            f = flattening of the earth:    1/294.98    Clarke Spheriod (1866) 
% Perfect agreeement with H.O. 9 Table 5 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 3 Aug 96; W. Broenkow 
 
r  = 3437.747;                     % r = 7915.704 when used with log10                    
a  = log(tan((45+lat/2)*pi/180)); 
b  = 23.268932*sin(lat*pi/180);    % Omitting terms b,c,d produces spherical meridional parts  
c  = 0.0525000*sin(lat*pi/180).^3; % As in meridn1_.m 
d  = 0.0002130*sin(lat*pi/100).^5;  
mp = r*a - b - c - d; 

