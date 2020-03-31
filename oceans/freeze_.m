function yyy = freeze_(S,P) 
% FREEZE_ - Freezing point of seawater (S,P) 
% 
% 
% Use As:  freeze_(S,P) 
% 
% Input:   S = Salinity (psu) 
%          P = Pressure (dbar) 
% Output:  Freezing Point (Celsius) 
% 
% Example: freeze_(33)     -> -1.808  P assumed to equal 0 
%          freeze_(35,500) -> -2.299  UNESCO 44 p30
%
% Ref: UNESCO Tech Paper Mar Sci 44 (1983) 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% Matlabized from UNESCO_83.FOR 
% 17 Jan 1996; W. Broenkow 
 
if nargin == 1 
  P = zeros(size(S)); 
end 
 
A0  =  -0.0575; 
A1  =   1.710523E-3; 
A2  =  -2.154996E-4; 
 B   = -7.53E-4; 
 
yyy = (A0 + A1.*sqrt(S) + A2.*S).*S + B.*P; 
