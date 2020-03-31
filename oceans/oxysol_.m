function yyy = oxysol_(S,T,units) 
% OXYSOL_ - Seawater oxygen solubility f(S,T)  
% 
% Use As:   oxysol_(S,T,units) 
% 
% Input:    S     = Salinity (psu) 
%           T     = Temperature (c) 
%           units   0 = ml(stp)/liter
%                   1 = umole/kg
% Output:   Oxygen solubility   
% 
% Example:  oxysol_(35,10)   -> 6.318
%           oxysol_(35,10,1) -> 
%
% Ref: Postma, et al. (1976) Oceanology 15:240-241.
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 26 July 94; Stephanie Flora 
%  5 Aug 97; W. Broenkow added umoles/kg

if nargin < 2
  disp('OXYSOL_ ERROR: Function requires Temperature and Salinity')
  help oxysol_
  break
end

if nargin < 3
  units = 0;
end
if units > 0
  units = 1;
end
  
    a1 = 273.15; 
    a2 = 100.0; 
    a3 = -173.4292; 
    a4 = 249.6339; 
    a5 = 143.3483; 
    a6 = 21.8492; 
    a7 = -0.033096; 
    a8 = 0.014259; 
    a9 = -0.0017; 
 
    p1 = (T + a1)./a2; 
    p2 = a3 + a4./p1 + a5*log(p1) - a6*p1; 
 
    yyy = exp(p2 + S.*(a7 + (a8 + a9.*p1).*p1)); 
   
    if units == 1
      rho = density_(S,T);     % density kg/liter
      yyy = yyy/22.38;         % mmoles O2/liter
      yyy = 1000*yyy./rho;     % umoles O2/kg
    end
               
