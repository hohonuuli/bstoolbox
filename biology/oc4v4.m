function chl = oc4v4(Rrs443, Rrs490, Rrs510, Rrs555)
% OC4V4     - 4-band ocean chlorphyll algorithm (version 4)
%
% OC4V4 calculates ocean chlorphyll from in water upwelled radiance (Lu).
% The algorithm is from Jay O'Reilly <oreilly@fish1.gso.uri.edu>
%
% Use as: c = oc4v4(Rrs443, Rrs490, Rrs510, Rrs555)
%
% Inputs: Rrs443 = Remote sensing reflectance at 490 nm
%         Rrs490 = Remote sensing reflectance at 555 nm
%         Rrs510 = Remote sensing reflectance at 490 nm
%         Rrs555 = Remote sensing reflectance at 555 nm
%         Note: the units of Rrs490 and Rrs555 are not important.
%         however they must be the same for both inputs. If Rrs is 
%         unavailable use Lw or Lwn.
%
%         The inputs should all be scalars or vectors of the same 
%         size and orientation.
%
% Output: chl = Chlorophyll (ug/L)

% Brian Schlining
% 19 May 2000

orientFlag = 0;
[r c] = size(Rrs555);
if c > r
   Rrs443 = Rrs443';
   Rrs490 = Rrs490';
   Rrs510 = Rrs510';
   Rrs555 = Rrs555';
   orientFlag = 1;
end
  
% Calculate chlorophyll
a      = [0.366 -3.067 1.930 0.649 -1.532];
R      = nanmax(log10([Rrs443./Rrs555 Rrs490./Rrs555 Rrs510./Rrs555])')';
chl    = 10.0.^(a(1) + a(2).*R + a(3).*R.^2   + a(4).*R.^3  + a(5).*R.^4);

if orientFlag
   chl = chl';
end
