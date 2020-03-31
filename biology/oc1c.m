function chl = oc1c(Rrs490, Rrs555)
% OC1C      - Chlorophyll alogrithmn
%
% Use as: chl = oc1c(Rrs490, Rrs555)

% Brian Schlining
% 02 Jun 2000

a   = [0.3920 -2.8550 0.6580];
R   = log10(Rrs490./Rrs555);
chl = 10.^(a(1) + a(2).*R + a(3).*R.*R);