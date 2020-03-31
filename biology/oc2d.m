function chl = oc2d(Rrs510, Rrs555)
% OC2D      - Chlorophyll alogrithmn
%
% Use as: chl = oc2d(Rrs510, Rrs555)

% Brian Schlining
% 02 Jun 2000

a   = [0.4487 -4.3665 2.7130 -0.2698 -0.0821];
R   = log10(Rrs510./Rrs555);
chl = 10.^(a(1) + a(2).*R + a(3).*R.*R + a(4).*R.*R.*R) + a(5);