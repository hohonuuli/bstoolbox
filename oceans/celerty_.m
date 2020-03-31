function [c,Ld,L] = celerty_(T,Z) 
% CELERTY_ - Ideal wave phase speed = f(Period, Depth) 
%  
% Use As:  [C,Ld,L] = celerty_(T,Z) 
%  Input:       T = ideal wave period (seconds) 
%               Z = water depth (meters) 
%                   depth is optional: if missing use deep water approximation 
%  Output:      C = wave phase speed (m/s) 
%              Ld = deep water wavelength (m) 
%               L = wavelength in water of depth, Z   
% 
% Example:  [C,Ld] = celerty_(8,15) 
%            -> C  = 10.7129 
%               Ld = 99.8220 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 16 Oct 1996; W. Broenkow 
% 14 Dec 1996; W. Broenkow added wavelength in water of depth, Z 
 
Ld = 9.8*T.^2/(2*pi);     % deep water wavelength 
if nargin == 2 
  c = 9.8.*Ld/(2*pi).*tanh(2*pi.*Z./Ld);  
  c = sqrt(c); 
elseif nargin == 1 
  c = 9.8*T/(2*pi); 
else 
  disp('ERROR: CELERTY_ requires at least one input') 
  c = inf; 
end 
L = c.*T; 
