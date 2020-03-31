function yyy = sigmat_(S,T) 
% SIGMAT_ - Computes the potential density anomaly sigma-t 
%           International Equation of State of Seawater (1980)  
% 
% Use As:   sigmat_(S,T) 
% 
% Input:    S = Salinity (psu); 
%           T = Temperature (Celsius) 
% Output:   Potential depth anomaly (g/liter) 
% 
% Example:  sigmat_(34.567,12.345) -> 26.1870 
%           sigmat_(35,20)         -> 24.7630 UNESCO 44 p23 
% 
% See Also: DENSITY_, KEDNSTY_, KSIGMAT_ 
% Ref:      UNESCO Tech Paper Mar Sci 44 (1983)

% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% Matlabized 17 Jan 1996; W. Broenkow 
 
yyy = 1000*(density_(S,T,0) - 1); 
 
