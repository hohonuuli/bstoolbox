function chl = oc2v1(Rrs490, Rrs555)
% OC2V1       - Chlorophyll alogrithmn
%
% Use as: chl = oc2v1(Rrs490, Rrs555)

% Brian Schlining
% 02 Jun 2000

a   = [0.3410 -3.0010 2.8110 -2.0410 -0.0400];
R   = log10(Rrs490./Rrs555);
chl = 10.^(a(1) + a(2).*R + a(3).*R.*R + a(4).*R.*R.*R) + a(5);