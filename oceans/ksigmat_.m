function yyy = ksigmat_(S,T) 
% KSIGMAT_ - Seawater potential density anomaly   
% 
% Knudsen's Equations (1901) 
% 
% Use As:   ksigmat_(S,T) 
% 
% Input:    S = Salinity (psu) 
%           T = Temperature (C) 
% Output:   Potential depth_ anomaly (g/liter)  
% 
% Example:  ksigmat_(34.567,12.345) ->  26.2059 
%    
%           With vectors  
%           S = [33 34 35] 
%           T = [10 11 12] 
%           ksigmat_(S,T) ->  25.4143  26.01789  26.60767 
% 
% See Also: DENSITY_, KEDNSTY_, LDENSTY_, SIGMAT_, BULKMOD_ 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories              
% Taken from the IES-80 HPL program then parameterized to REAL*8 
% William Broenkow 
% 31 August 1987; changed 28 Sept 1987  
% Matlab-ized 21 July 1995 
% Vectorized  30 Sep 1995 

if nargin < 2
  disp('KSIGMAT_ ERROR: Must input Salinity and Temperature')
  help ksigmat_
  break
end
 
A0 =  1.80655; 
A1 =  0.069; 
A2 =  1.4708; 
A3 =  0.00157; 
A4 =  0.0000398; 
A5 =  3.98; 
A6 =  283.0;                     
A7 =  503.57; 
A8 =  67.26; 
A9 =  4.7867; 
A10 =  0.098185; 
A11 =  0.0010843; 
A12 = 18.03;  
A13 =  0.8164;  
A14 =  0.01667;  
A15 =  0.1324; 
 
C  =   S/A0;                                    % Chlorinity 
P1 =  - A1 + A2.*C - A3.*C.*C + A4.*C.*C.*C;    % Sigma-0 
 
% This is the nested form of the Sigma-0 equation, 
% and it gives identical results. 
%  P1 =  - A1 + (A2 + (- A3 + A4.*C).*C).*C      
 
P2 =  -(T-A5).*(T-A5).*(T+A6)./(A7.*(T+A8));    % St 
 
% This form of the above expression is incorrect. It cannot be 
 
% written without second () in the denominator. 
%       P2 =  -(T-A5)*(T-A5)*(T+A6)/A7*(T+A8)      
 
P3  =   (A9.*T  - A10.*T.*T + A11.*T.*T.*T)*1E-3;   % At 
P4  =   (A12.*T - A13.*T.*T + A14.*T.*T.*T)*1E-6;   % Bt 
D   =   - P2 - A15 + (P1+A15).*(P3-P4.*(P1-A15));   % D   
yyy =   P1 - D;
