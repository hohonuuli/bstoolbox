function R=deg2rad(D)

%DEG2RAD Converts angles from degrees to radians
%
%  rad = DEG2RAD(deg) converts angles from degrees to radians.
%
%  See also RAD2DEG, DEG2DMS, ANGLEDIM, ANGL2STR

%  Written by:  E. Byrns, E. Brown


if nargin==0
	error('Incorrect number of arguments')
elseif ~isreal(D)
     warning('Imaginary parts of complex ANGLE argument ignored')
     D = real(D);
end

R = D*pi/180;
