function T = c2t_(C,L) 
% C2T_ - Convert beam attenuation (/m) to percent beam transmission 
%  
% Input:   C = beam attenuation coefficient (/m) 
%          L = pathlength (m)    default = 1.0 m    
% Output:  T = beam transmission (percent per pathlength) 
% 
% Example: T = c2t_(.045)     -> 95.5997 
%          T = c2t_(.045,.25) -> 98.8813 
% 
% See Also: T2C_
 
% 25 Jul 1997; W. Broenkow 
 
if nargin < 2 
  L = 1;     % default to a 1-m transmissometer 
end 
 
T = 100*exp(-C.*L); 
