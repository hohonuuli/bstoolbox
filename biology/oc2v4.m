function chl = oc2v4(Rrs490,Rrs555)
% OC2V4     - 2-band ocean chlorphyll algorithm (version 4)
%
% OC2V4 calculates ocean chlorphyll from in water upwelled radiance (Lu).
% The algorithm is from Jay O'Reilly <oreilly@fish1.gso.uri.edu>
%
% Use as: c = oc2v4(Rrs490, Rrs555)
%
% Inputs: Rrs490 = Remote sensing reflectance at 490 nm
%         Rrs555 = Remote sensing reflectance at 555 nm
%         Note: the units of Rrs490 and Rrs555 are not important.
%         however they must be the same for both inputs. If Rrs is 
%         unavailable use Lw or Lwn.
%
% Output: chl = Chlorophyll (ug/L)

% Brian Schlining
% 19 May 2000


% Calculate chlorophyll
a      = [0.319 -2.336 0.879 -0.135 -0.071];
R      = log10(Rrs490./Rrs555);
chl    = 10.0.^(a(1) + a(2).*R + a(3).*R.^2   + a(4).*R.^3)  + a(5);
