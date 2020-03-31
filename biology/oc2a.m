function chl = oc2a(Rrs412, Rrs555)
% OC2A      - Chlorophyll alogrithmn
%
% Use as: chl = oc2a(Rrs412, Rrs555)

% Brian Schlining
% 02 Jun 2000

a   = [0.2457 -1.7620 0.2830 0.1035 -0.0388];
R   = log10(Rrs412./Rrs555);
chl = 10.^(a(1) + a(2).*R + a(3).*R.*R + a(4).*R.*R.*R) + a(5);