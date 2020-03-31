function [P,Eq] = par_(lambda,Ew,WaveMin,WaveMax) 
 
% PAR_ - Photosynthetically Available Radiation uMoles/(m^2 s) 
% 
% This procedure returns the "total quanta_ available for photosynthesis 
% within the wavelength limits 350 to 700 nm" (SCOR Working Group 15, 1970). 
% If the original spectrum does not contain these wavelengths, 
% they are linearly interpolated from the input spectrum. 
% The input spectral irradiance is converted to uMoles/(m^2 s nm) 
% at the original wavelengths and returned.  
% 
% Use As:  [P,Eq] = par_(lambda,Ew,WaveMin,WaveMax) 
% 
% Input:   lambda  = wavelength (nm) of spectral irradiance
%          Ew      = Irradiance uW/(cm^2 nm)  
%          WaveMin = Minimum wavelength (nm) of integral (typically 350 or 400 nm) 
%          WaveMax = Maximum wavelength (nm) of integral (typically 700 nm) 
% Output:  P       = PAR photosynthetically available radiation uMoles Photons/(m^2 sec) 
%                    or uEinsteins/(m^2 s) for waveband from WaveMin to WaveMax nm 
%          Eq      = Quantum spectral irradiance in uMoles/(m^2 s nm) 
% 
% See Also:   QUANTA_ 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 18 May 96; W. Broenkow 
%  8 Aug 96; W. Broenkow split out quanta_.m
%  6 Feb 97; M. Feinholz added WaveMin|Max, cleaned up and checked 
%  8 Sep 97; w. Broenkow fixed to work with either row or column vectors
 
[mL,nL] = size(lambda); 
[mE,nE] = size(Ew); 
if (mL ~= mE) | (nL ~= nE) 
  error('PAR requires that wavelength and irradiance are vectors of same length ') 
end 
if (min(mL,nL) ~=1 | min(mE,nE) ~= 1) 
  error('PAR requires that wavelength and irradiance are vectors') 
end 
if mL > 1
  lambda = lambda';            % use row vectors
  Ew     = Ew';
end   

Eq = quanta_(lambda,Ew);       % umole/(m^2 sec nm) for given wavelength in nm 
 
i = finite(Eq);                % these are the valid data 
L = lambda(i);                 % the observed wavelengths 
E = Eq(i);                     % the quantum irradiances 
 
s = 1; 
while L(s) < WaveMin 
  s = s+1; 
end 
if s~= 1, s = s-1; end;        % starting index  
e = length(L); 
while L(e) > WaveMax 
  e = e-1; 
end 
if e~= length(L), e = e+1; end; % ending index 

L  = L(s:e);                   % Valid wavelengths 400- to 700+
E  = E(s:e);                   % Corresponding quantum irradiances 
LI = L;                        % Make an array for interpolated wavelengths 
i  = min(find(L>WaveMin));     % The following lines add 400 and 700 nm 
j  = max(find(L<WaveMax));     % to the observed spectrum if they are not 
ii = find(L==WaveMin);         % already present. Then values for those 
jj = find(L==WaveMax);         % two wavelengths are linearly interpolated 
if isempty(jj)                 % from adjacent values. 
  LI = [LI(1,1:j) WaveMax LI(1,j+1)]; 
  j  = j + 1; 
end 
if isempty(ii) 
  LI = [LI(1,1) WaveMin LI(1,2:j+1)]; 
end 
EI = interp1(L,E,LI,'linear'); % interpolate to include WaveMin and WaveMax 
 s = find(LI == WaveMin); 
 e = find(LI == WaveMax); 
 
 P = trapz(LI(s:e),EI(s:e));   % PAR is the integrated irradiance 

