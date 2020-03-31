function yyy = depth_(P,LAT)
% DEPTH_ - Ocean depth (P, Latitude) 
%
% Use As:  depth_(P,LAT)
%
% Input:   P   = Pressure (dbar), 
%          LAT = Latitude (decimal degrees)
% Output:  Depth (m)
%
% Example: depth_(5000,36) -> 4906.08
%          depth_(1000,90) -> 9674.23  UNESCO 44 p28
%
% Note:    For more accurate results an additional factor of the
%          ratio of the actual geopotential anomaly/gravity must 
%          be added. This correction will be less than 2 m.
%
% Ref:  UNESCO Tech Paper Mar Sci 44 (1983)

% Copyright (c) 1996 by Moss Landing Marine Laboratories
% 17 Jan 1996; W. Broenkow Matlabized from UNESCO83.FOR
% 25 Mar 1996; vectorized

C1 =  9.72659;
C2 = -2.2512E-5;
C3 =  2.279E-10;
C4 = -1.82E-15;

G0 = 9.780318;
G1 = 5.2788E-3;
G2 = 2.36E-5;

GAMMA = 2.184E-6;

      X = (sin(pi.*LAT./180)).^2;
GRAVITY = G0*(1.0 + (G1 + G2.*X).*X) + (GAMMA./2).*P;
      Z = (C1 + (C2 + (C3 + C4.*P).*P).*P).*P;
    yyy = Z./GRAVITY;
