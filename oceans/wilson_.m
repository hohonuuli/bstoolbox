function yyy = wilson_(S,T,Z) 
% WILSON_ - Speed of sound in seawater by Wilson (1960)
% 
% Use As:   wilson_(S,T,Z) 
% 
% Input:    S = Salinity (psu) 
%           T = Temperature (C) 
%           Z = depth (m) 
% Output:   Speed of Sound (m/s) 
% 
% Example:  wilson_(35,10,2000) -> 1523.80 
% 
% See Also: SVEL_ 
% Ref:      Wilson, W.D. 1960. J. Acoust. Soc. Amer. 32:641-644.

% Copyright (c) 1996 by Moss Landing Marine Laboratories   
% Matlabized from UNESCO83.FOR 
% 18 Jan 1996; W. Broenkow 
 
if (nargin <3), 
  Z = zeros(size(S)); 
end; 
 
if (nargin <2) 
  disp('Wilson requires both salinity and temperature') 
  disp('        eg. wilson_(34.567,12.345)') 
  disp('or S,T,Z as wilson_(34.567,12.345,4321)') 
  break; 
end; 
 
A0 = 1449.0; 
A1 =    4.6; 
A2 =   -0.055; 
A3 =    0.0003; 
A4 =    1.39; 
A5 =   -0.012; 
A6 =    0.017; 
 
yyy = A0 + (A1 + (A2 + A3.*T).*T).*T + (A4 + A5.*T).*(S - 35) + A6.*Z; 
 
