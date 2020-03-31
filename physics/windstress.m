function t = windstress(Wdir,Wspd,H)
% WINDSTRESS - Calculate wind stress products
%
% Use As: t = windstress(Wdir,Wspd,H)
%
% OUTPUT:
%  A structure with the following fields:
%    Tau  = stress in the direction of the wind (nx1) (kg/m/s^2)
%    Taux = stress in the x direction (positive east)(nx1)
%    Tauy = stress in the y direction (positive north)(nx1)
%    Cd   = Drag Coefficient (nx1)
%    u    = u-component of measured wind velocity(nx1)
%    v    = v-component of measured wind velocity(nx1)
%    u10  = u component of wind velocity estimated at 10m(nx1)
%    v10  = v component of wind velocity estimated at 10m(nx1)
%
% INPUT:
%    Wdir = measured wind direction(deg) positive cw from North=0(nx1)
%    Wspd = measured wind speed in meters / sec(nx1)
%    H    = height (meters) of wind sensor above sea surface(nx1)
%
% To convert Tau from Kg/m/s^2 (mks) to dynes/cm^2 multiply Tau by 10

%   Solution is found as described
%   in "Large and Pond" Journal of Physical
%   Oceanography Vol 11, 1981 pp324-336
%
%   method has been 'vectorized' for efficiency in matlab

% Jerry Hatcher
% 22 Feb 1999 - Delivered to Brian Schlining
% 23 Feb 1999 - Modified output to a single structure

%Parameters
rho=1.22; %kg/m^3 

%check for correct number of args
if nargchk(3,3,nargin)
	%eval(['help wstress']);
	error('Incorrect Input');
end


% get Wdir into radians
theta   = 2*pi*Wdir/360;

%calculate u and v components at the sensor
u       = Wspd.*sin(theta);
v       = Wspd.*cos(theta);

%calculate wind speeds and dragg coefficients at 10 m above surface
[W10,Cd]= uten(Wspd,H);
u10     = W10.*sin(theta);
v10     = W10.*cos(theta);

%calculate the wind stress and its u v components
Taw     = rho*Cd.*W10.*W10;
Tawx    = Taw.*sin(theta);
Tawy    = Taw.*cos(theta);

% Put data into a structure
t.Tau = Taw;
t.Taux = Tawx;
t.Tauy = Tawy;
t.Cd   = Cd;
t.u    = u;
t.v    = v;
t.u10  = u10;
t.v10  = v10;


%===================================================================
function [u10,Cdn]=uten(u,h)
%function [u10,Cdn]=uten(u,h)
% u10 is the estimate of wind speed(m/s) at 10m
% Cdn is the estimate of drag coefficient
% u is measured wind stress(nx1)
% h is height of wind sensor above surface(meters)(nx1)

%   Solution is found iteratively as described
%   in "Large and Pond" Journal of Physical
%   Oceanography Vol 11, 1981 pp324-336
%
%   method has been 'vectorized' for efficiency in matlab

%Parameters
tol=0.2; %acceptable error tolorance
k=0.41;  %Von Karmen's constant

%check for correct number of args
if nargchk(2,2,nargin)
	eval(['help uten']);
	error('Incorrect Input');
end

% set matricies
utmp=u;u10=zeros(size(u));Cdn=zeros(size(u));

%keep looping until all values are within tol
while max(abs(u10-utmp)) > tol,   
	u10=utmp;
        %first set Cdn's for u < 11 m/s
	I=find(u10 < 11);
	Cdn(I)=(1.2E-03)*ones(size(I));

	%next set Cdn's for u >= 11 m/s
	I=find(u10 >=11);
	Cdn(I)=(0.49+0.065*u10(I))*.001;
	
	%now calculate new utmps
	utmp=u./(1+(sqrt(Cdn)/k).*log(h/10));
end




