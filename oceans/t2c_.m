function C = t2c_(T,L) 
% T2C_ - Convert percent beam transmission to beam attenuation (1/m) 
%  
% Input:   T = beam transmission (percent per pathlength) 
%          L = pathlength (m)    default = 1.0 m    
% Output:  C = beam attenuation coefficient (/m) 
% 
% Example: C = t2c_(85.6)     -> 0.1555 
%          C = t2c_(85.6,.25) -> 0.6219 
% 
% See Also: C2T_ 
 
% 25 Jul 1997; W. Broenkow 
 
if nargin < 2 
  L = 1;     % default to a 1-m transmissometer 
end 
C = -log(T/100)./L; 
 
