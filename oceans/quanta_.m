function Eq = quanta_(lambda,E) 
 
% QUANTA_ - Convert irradiance from uW/(cm^2 nm s) to uMoles/(m^2 s) 
% 
% The input spectral irradiance is converted to uEinsteins/(m^2 nm s) 
% 
% Use As:  Eq = quanta_(lambda,Ew) 
% 
% Input:   lambda = wavelength (nm) of spectral irradiance 
%          Ew     = Irradiance uW/(cm^2 nm)  
% Output:  Eq     = Quantum irradiance in uEinstein/(m^2 nm sec) 
%
% Example: quanta_(100,443) ->  3.7032
%
% See Also:  PAR_, NECKLAB_, PLANCK_ 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
%  8 Aug 96; W. Broenkow adapted from PAR 
%  6 Feb 97; M. Feinholz cleaned up and checked 
 
 h     = 6.6260755e-34;    % planck's constant      (J s quanta^-1) 
 c     = 299792458;        % speed of light         (m s^-1) 
 Na    = 6.0221367e23;     % Avagadrodo's number:   (Quanta mole^-1) 
 nm2m  = 1e9;              % nm to m conversion     (nm m^-1) 
 cm2m2 = 1e-4;             % cm^2 to m^2 conversion (cm^2 m^-2)
 
 
%     E     Lambda   1/h     1/c    1/Na    1/nm2m     1/cm2m2 
%     uW      nm    quanta    s     mole         m         cm^2
%  ---------*-----*--------*-----*--------*---------*---------- 
%   cm^2 nm          J s      m    quanta   10^9 nm   10^-4 m^2
%                   W s                  
 
Eq = E.*lambda/(h*c*Na*nm2m*cm2m2);   % umole/(m^2 sec nm) for given wavelength in nm 
 
