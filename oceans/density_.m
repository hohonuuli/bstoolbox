function yyy = density_(S,T,P) 
% DENSITY_ - Seawater density (S,T,P)  
% 
% International Equation of State of Seawater (1980) 
% UNESCO Tech Paper Mar Sci 44 (1983) 
%  
% Use As:   density_(S,T,P) 
%      or   density_(S,T)    P is assumed to be zero 
% 
% Input:    S = Salinity (psu) 
%           T = Temperature (C) 
%           P = Pressure (dbar) 
% Output:   density (kg/liter) 
% 
% Example:  density_(34.567,5.00,2000) -> 1.036409
%           density_(35,25,10000)      -> 1.06253817  UNESCO 44 p19  
% 
% See Also: DELTA_, BULKMOD_, KEDNSTY_, SIGMAT_  
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% William Broenkow 
% Checks perfectly with UNESCO 44.
% This function requires bulkmod_.M  
% Matlabized 17 Jan 1996; W. Broenkow 
 
% split out bulk_modulus_83 to separate function 
% 13 February 1992  W. Broenkow 
% Input pressure in DBARS...  USE bulk_modulus in BARS... 
 
% use constant names exactly as in UNESCO 1983 

if nargin < 2
  disp('DENSITY_ Error  Must supply S and T')
  help density_;
  return
end
if nargin < 3
  P = zeros(size(S));
end
 
 A0 = 999.842594; 
 A1 =   6.793952E-2; 
 A2 =  -9.095290E-3; 
 A3 =   1.001685E-4; 
 A4 =  -1.120083E-6; 
 A5 =   6.536332E-9; 
 B0 =   8.24493E-1; 
 B1 =  -4.0899E-3; 
 B2 =   7.6438E-5; 
 B3 =  -8.2467E-7; 
 B4 =   5.3875E-9; 
 C0 =  -5.72466E-3; 
 C1 =   1.0227E-4; 
 C2 =  -1.6546E-6; 
 D0 =   4.8314E-4; 

if nargin < 2
  error([mfilename ' requires two inputs: S and T '])
end 

if nargin == 2 
  P = zeros(size(S)); 
end 
 
RHOW = A0 + (A1 + (A2 + (A3 + (A4 + A5.*T).*T).*T).*T).*T;    % eq 4 
B    = (B0 + (B1 + (B2 + (B3 + B4*T).*T).*T).*T).*S; 
C    = (C0 + (C1 + C2.*T).*T).*S.*sqrt(S); 
D    = D0.*S.*S; 
RHO  = RHOW + B + C + D;           % rho(S,T,0), eq 13 
 
if (nargin == 3)                   % secant bulk modulus 
  KSTP = bulkmod_(S,T,P);          % separate subroutine 
  RHO  = RHO./(1 - P./(10.*KSTP)); % eq 07  
end                                % NOTE: 10 since K in bars; P in dbars  
 
yyy = RHO./1000;                   % scale to kg/liter 
