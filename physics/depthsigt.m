function d = depthsigt(S,T,Pressure,SigT)
% DEPTHSIGT - Calculate the depth of a given sigma-t
%
% Use as:    d = depthsigt(Sal,Temp,Pressure,SigmaT)
%         or d = depthsigt(CTD,SigmaT)
%
% Inputs:   Sal      = salinity (psu)
%           Temp     = temperature (C)
%           Pressure = pressure (dbar)
%           SigmaT   = sigma-t of interest
% 
%        or CTD = structure containing field 'Sal','Temp',and'Pressure'
%
% Output: Depth where SigmaT occurs, defualt is 26.4 which is generally 
%         accepted as the heart of the california undercurrent.
%
% Requires: SIGMAT from Ocean toolbox

% B. Schlining
% 31 Jul 1997

if nargin <= 2,
   if isstruct(S)
      Sal = S.Sal;
      Temp = S.Temp;
      Pressure = S.Pressure;
      if nargin == 1
         SigT = 26.4;
      else
         SigT = T;
      end
   else
      disp('DEPTHCUC requires inputs of salinity, temperature and pressure')
      return
   end
else
   Sal = S;
   Temp = T;
   clear S T
   if nargin == 3
      SigT = 26.4;
   end
end

SigmaT = sigmat(Sal,Temp);
d = interp1q(SigmaT,Pressure,SigT);
    