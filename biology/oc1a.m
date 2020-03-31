function chl = morel_1(Rrs490, Rrs555)
% OC1A      - Chlorophyll alogrithmn
%
% Use as: chl = oc1a(Rrs490, Rrs555)

% Brian Schlining
% 02 Jun 2000

a   = [0.3734 -24529];
R   = log10(Rrs490./Rrs555);
chl = 10.^(a(1) + a(2).*R);