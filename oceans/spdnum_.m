function speed = spdnum_(nt,ns,nh,np) 
% SPDNUM_ - Compute tidal speed numbers (degrees/hr) as beat frequencies 
%           of fundamental astronomical periods 
% 
% Use As:      S = spdnum_(nt,ns,nh,np) 
% Input:      nt = integer number of mean solar days 
%             ns = integer number of year 
%             nh = integer number of sideral months 
%             np = integer number of lunar perigee cycles 
% Output       S = constituent speed number (degrees/hour) 
% 
% Example     spdnum_(2,2,-2,0) -> 14.9497 
 
% W. Broenkow; 7 Dec 1996 
 
t = 15.00000000;  % Schureman Table 1 page 163 
s =  0.54901653; 
h =  0.04106864; 
p =  0.00461483; 
 
speed = nt*t + ns*s + nh*h + np*p; 
 
 
