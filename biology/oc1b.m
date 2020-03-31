function chl = oc1b(Rrs490, Rrs555)
% OC1B      - Chlorophyll alogrithmn
%
% Use as: chl = oc1b(Rrs490, Rrs555)

% Brian Schlining
% 02 Jun 2000

a   = [0.3636 -2.3500 -0.0100];
R   = log10(Rrs490./Rrs555);
chl = 10.^(a(1) + a(2).*R) + a(3);