function es = erthsun_(D) 
% ERTHSUN_ - Earth-Sun Distance (julian day of year) 
% 
% This is a low precision formula from Gordon, et al. (1983) 
% 
% Use As:  es = erthsun_(D) 
% 
% Input:   D  = Julian day of the year 
% Output:  es = Earth-Sun distance in astronomical units 
% 
% Example: erthsun_([3 185]) -> 0.9836  1.0170
% 
% See Also: EPHEMS_ 
% 
% Note:    Correct extra-terrestrial fluxes for variable earth-sun 
%          distance. The correction used in solar-normalized radiances  
%          is the reciprocal square of the earth-sun distance. 

% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 23 Apr 1995; W. Broenkow for MS-262 
% 28 May 96; W. Broenkow corrected  
 
es = 1./(1+0.0167*cos(2*pi*(D-3)./365));
