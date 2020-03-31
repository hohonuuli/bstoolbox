function density = kednsty_(S,T,P) 
% KEDNSTY_ - Seawater in-situ density (S,T,P) 
% 
% Sigma(S,T,P) by Knudsen's Equations (1901) with  
% compressibility correction from Ekman (1908) 
% 
% Use As:   kednsty_(S,T,P) 
% 
% Input:    S = Salinity (psu) 
%           T = Temperature (C) 
%           P = Pressure (dbar) 
% Output:   Absolute seawater density (kg/liter) 
% 
% Example:  S,T,P can be matricies 
%           S = [33 34 34]; 
%           T = [10 11 12]; 
%           P = [0 2000 4000]; 
%           kednsty_(S,T,P) -> 1.025414   1.034880   1.043113 
%  
% See Also: DENSITY_, KSIGMAT_, EKMANMU_, LDENSTY_, SIGMAT_  
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
%  Written without nested polynomials exactly in order shown in handout 
%  William Broenkow 
%  28 Sept 1987, revised 11 Sept 88 
%  Matlab-ized 20 July 1995 
%  Vectorized 17 Sep 1995 

if nargin < 2
  disp('KEDNSTY_ ERROR: Must input Salinity and Temperature')
  help kednsty_
  break
end

if nargin < 3
  P = zeros(size(S));
end 
A1  =  4886.0;  
A2  =     1.83E-5;  
A3  =   227.0;  
A4  =    28.33;  
A5  =     0.551;  
A6  =     0.004;  
A7  =   105.5;  
A8  =     9.50;  
A9  =     0.158;  
A10 =     1.5E-8;  
A11 =   147.3;  
A12 =     2.72;  
A13 =     0.04;  
A14 =    32.4;  
A15 =     0.87;  
A16 =     0.02;  
A17 =     4.5;  
A18 =     0.1;  
A19 =     1.8; 
A20 =     0.06;  
A21 =    28.0; 
                                                     
SIGMA_ZERO =  ksigmat_(S,0.0); 
 
%  It is very interesting that DENSITY00 (33,0.0,0.0) = 26.51666364..  
%  following the call to KNUDSEN, but inside KNUDSEN the same SIGMA_0 
%  is 26.51661728..  This once again demonstrates the strangeness of 
%  dealing with REAL numbers, which presumeably will not be a problem 
%  in Matlab. 
 
P2 =  A1./(1.0 + A2.*P) - ( A3 + A4.*T - A5.*T.*T + A6.*T.*T.*T); 
P3 =  1E-4.*P.*(A7 + A8.*T - A9.*T.*T) - A10.*T.*P.*P; 
P4 =  A11 - A12.*T + A13.*T.*T - 1E-4.*P.*(A14 - A15.*T + A16.*T.*T); 
P5 =  A17 - A18.*T - 1E-4.*P.*(A19 - A20.*T); 
P6 =  1E-1.*(SIGMA_ZERO - A21); 
MU =  (P2 + P3 - P6.*P4 + P5.*P6.*P6)*1.0E-9;   % compressibility 
 
DENSITY_ST0 = 1.0 + ksigmat_(S,T)/1000;         % density(ST0) 
density     = DENSITY_ST0./(1.0 - MU.*P);       % depth_(STP) 
 
