function [lat] = invmerd_(mp) 
% INVMERD_ - Inverse meridional parts, use in digitizing Mercator maps. 
%            Determine latitude from meridional parts.  
% 
% Use As:    lat = invmerd_(mp) 
% 
% Input:     mp  = meridional parts 
% Output:    lat = latitude (deg) 
% 
% Example:   invmerd_(3029.9392) -> 45.0000 
% Note:      This algorithm uses spherical meridional parts as in meridn2_.m 
%            not that for the oblate spheroid as in meridn1_.m 
% See Also:  MERIDN1_, MERIDN2_, MRCTMAP_, RHUMBL_.M 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% H.O. 9 (1958) American Practical Navigator p 1186 
% 25 Mar 96; W. Broenkow 
 
lat = 90 - (2.0*180/pi)*atan(exp(-(mp/3437.74677078)));   
 
