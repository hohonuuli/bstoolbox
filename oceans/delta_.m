function yyy = delta_(S,T,P) 
% DELTA_ - Specific volume anomaly (S,T,P) 
% 
% International Equation of State of Seawater (1980) 
%  
% Use As:  delta_(S,T,P) 
% 
% Input:   S = Salinity (psu); 
%          T = Temperature (Celsius) 
%          P = Pressure (db)         Supply P = 0 to obtain delta-t 
% Output:  Specific Volume Anomaly (centiliters/ton or 1E-8 m^3/kg) 
% 
% Example: delta_(34.567,5.00,2000) ->  94.884 
%          delta_(40,40,10000)      -> 981.302   UNESCO 44 p22
%
% See Also:  DENSITY_
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 17 Jan 1996; W. Broenkow Matlabized from FORTRAN 
% 20 Feb 1996; lower case and vectorized 
% 26 Jan 1998; debugged

if nargin < 2
  disp('DELTA_ Error: Must supply S and T')
  help delta_;
  return
end
if nargin < 3
  P = zeros(size(S));
end
 
yyy = 1.0E5*(1./density_(S,T,P) - 1./density_(35,0,P)); 
 
