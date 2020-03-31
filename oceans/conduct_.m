function x = conduct_(S,T,P) 
% CONDUCT_ - Electrical conductivity ratio of seawater 
% 
% Practical Salinity Scale 1978 
% 
% Use As:  conduct_(S,T,P) 
% 
% Input:   S = Salinity (psu) 
%          T = Temperature (C) 
%          P = Pressure (dbar) 
% Output:  Conductivity Ratio 
% 
% Example: conduct_(34,10,4000)        -> 0.9009676
%          conduct_(37.245628,20,2000) -> 1.2000001 UNESCO 36 p17
%  
% See Also: sbcond(F,T,P) to convert SeaBird conductivity signals 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% W. Broenkow 28 June 1994 from 
% MLLIB SOURCE NAME:  UNESCO_83.FOR 
% 25 Mar 96; WWB vectorized see line 24 
% 27 Jan 98; Erich Reinecker found bug for vector inputs 
%       conduct_([28 37 35],[5 20 15],[1500 2000 .0001]) ->    1     1     1
 
if (S < 0.001) 
  x = 0.0; 
else          
  CondGuess = ones(size(S)); 
  Eps       = 1.0E-5*ones(size(S)); 
  Iter      = 0; 
    CalcSalin = salin_(CondGuess,T,P); 
 
  while (((abs(CalcSalin-S) > Eps)) & (Iter < 20));  % the trick to test any array 
    CondGuess = CondGuess./(CalcSalin./S); 
    Iter      = Iter+1; 
    CalcSalin = salin_(CondGuess,T,P); 
%   disp(Iter); 
%   disp(CalcSalin - S); 
%   Serror = abs(CalcSalin - S) > Eps; 
  end 
 
  if (Iter > 20) 
    CondGuess = 999.0; 
  end 
  x = CondGuess; 
end 
