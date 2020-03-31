function D = ldensty_(S,T) 
% LDENSTY_ - Linearized density of seawater useful for simple hydrostatic  
%            stability models 
% 
% Use As:   ldensty_(S,T) 
% 
% Input:    T   = Temperature (C) 
%           S   = Salinity (psu) 
% Output:   Approximate density (kg/liter) 
% 
% Example:  ldensty_(34,10) -> 1.0260 
%           density_(34,10) -> 1.0262 
%           kednsty_(34,10) -> 1.0262
%                    
% See Also: DENSITY_, KEDNSTY_ 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories     
% 6 May 96; W. Broenkow 
 
alpha = .97227;   % Standard Specific Volume       35 psu  0 C 0 dbar 
beta  = 165e-6;   % Thermal Expansion Coefficient  34 psu 10 C 0 dbar 
gamma = 759e-6;   % Haline Contraction Coefficient 34 psu 10 C 0 dbar 
 
D = 1./(alpha + beta.*T - gamma.*(S-35)); 
 
