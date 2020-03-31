function yyy = sigmat(S,T)
% SIGMAT    - Computes the potential density anomaly sigma-t
%
% International Equation of State of Seawater (1980) 
%
% Use As:   sigmat(S,T)
%
% Input:    S = Salinity (psu);
%           T = Temperature (Celsius)
% Output:   Potential Density Anomaly (g/liter)
%
% Example:  sigmat(34.567,12.345) -> 26.1870
%
% See Also: DENSITY, KEDENSTY, KSIGMAT

% Copyright (c) 1996 by Moss Landing Marine Laboratories
% Requires density.m function in this module
% Matlabized 17 Jan 1996; W. Broenkow

yyy = 1000*(density(S,T,0) - 1);

