function chl = oc1d(Rrs490, Rrs555)
% OC1D      - Chlorophyll alogrithmn
%
% Use as: chl = oc1d(Rrs490, Rrs555)

% Brian Schlining
% 02 Jun 2000

a   = [0.3335 -2.9164 2.4686 -2.5195];
R   = log10(Rrs490./Rrs555);
chl = 10.^(a(1) + a(2).*R + a(3).*R.*R + a(4).*R.*R.*R);