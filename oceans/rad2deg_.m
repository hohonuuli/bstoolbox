function y = rad2deg_(x) 
% rad2deg_ - Converts angle in radians to degrees 
%  
% Use As:   rad2deg_(angle) 
% 
% Input:    angle in radians 
% Output:   angle in degrees 
% 
% Example:  rad2deg_(3*pi/2) -> 270 
% 
% See Also: DEG2RAD_
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 28 Jan 1996; W. Broenkow 
% 20 Jun 96; changed name wwb 
 
y = x*180/pi;  
