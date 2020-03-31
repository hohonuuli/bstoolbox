function chl = oc2b(Rrs443, Rrs555)
% OC2B      - Chlorophyll alogrithmn
%
% Use as: chl = oc2b(Rrs443, Rrs555)

% Brian Schlining
% 02 Jun 2000

a   = [0.1909 -1.9961 1.3020 -0.5091 -0.0815];
R   = log10(Rrs443./Rrs555);
chl = 10.^(a(1) + a(2).*R + a(3).*R.*R + a(4).*R.*R.*R) + a(5);