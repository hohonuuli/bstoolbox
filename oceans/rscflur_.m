function F680p = rscflur_(f680,algorm) 
% rscflur_ - Convert MLML Chlorophyll fluorescence to approximate  pigment concentration 
% Use As:  F680p = rscflur_(f680,algorm) 
% 
% Input:   f680   = chlorophyll fluorescence @ 680 nm (Volts) 
%          algorm = algorithm
%                   1 = MLML Fluorometer/Seabird CTD
%                   2 = Variosens Flurometer
% Output:  F680p = rescaled chlorophyll flourescence (mg/m^3) 
%                  to approximate chlorophyll a concentrations 
% 
% Example: rscflur_(0.4,2) -> 0.088 
% Based on a regression-determined equation developed by Yuen (1990). 
 
% Copyright (c) 1997 by Moss Landing Marine Laboratories 
% 21 May 1997; Darryl Peters 
% 27 May 1997; S. Flora - added f680*100 to convert from Volts to hundreths of volts 
 
Nargs = nargin; 
if Nargs <  1 
  help rscfluor 
  return
elseif Nargs < 2
  algorm = 2;    
end 

if algorm == 2 
  % f680 units are hundreths of Volts so to convert from 
  % Volts (input) to hundreths of volts you multiply by 100. 
  F680p = 10.^(0.0384.*f680.*100-2.59);                       % (mg/m^3) 
elseif algorm == 1
  F680p = NaN*ones(size(f680));           % We must get algorithm by comparison with C Trees
end


