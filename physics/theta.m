function yyy = theta(S,T,PO,PR)
% THETA     - Local potential temperature at the reference pressure, PR
%
% UNESCO Tech Paper Mar Sci 44 (1983)
%
% Use As:  theta(S,T,PO,PR)
%
% Input:   S  = Salinity (practical salinity scale 1978)
%          T  = Temperature (Celsius)
%          PO = In Situ Pressure (decibars)
%          PR = Reference Pressure (decibars)
%               {optional if not entered, 0 is assumed}
% Output:  Potential Temperature at the reference pressure (Celsius)
%
% Example: theta(35,10,5000)      -> 9.2906
%          theta(35,10,5000,4000) -> 9.8341

% Copyright (c) 1996 by Moss Landing Marine Laboratories
% Algorithm in UNESCO 1983.  Variable nomenclature follows that reference exactly.
% Matlabized 17 Jan 1996; W. Broenkow

 if nargin < 4
   PR = zeros(size(S));
 end
    
 P   = PO;
 T2  = T;        % the input temperature in changed iteratively
 H   = PR - P;
 XK  = H.*atg(S,T2,P);
 T2  = T2 + 0.5*XK;
 Q   = XK;
 P   = P + 0.5*H;
 XK  = H.*atg(S,T2,P);
 T2  = T2 + 0.29289322*(XK - Q);
 Q   = 0.58578644*XK + 0.121320344*Q;
 XK  = H.*atg(S,T2,P);
 T2  = T2 + 1.70710678*(XK - Q);
 Q   = 3.414213562*XK - 4.121320344*Q;
 P   = P + 0.5*H;
 XK  = H.*atg(S,T2,P);

yyy = T2 + (XK - 2*Q)/6;
