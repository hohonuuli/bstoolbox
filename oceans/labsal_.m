function yyy = labsal_(R,T) 
% LABSAL_ - Salinity from laboratory salinometer conductivity and temperature 
% 
% Use As:   labsal_(R,T) 
% 
% Input:    R = Conductivity Ratio C(S,T)/C(35,15) 
%           T = Temperature (C) 
% Output:   Salinity (psu) 
% 
% Example:  labsal_(.98765,15.0) -> 34.517 
% 
% See Also: SALIN_ 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
 
yyy = salin_(R,T); 

