function chl = morel_1(Rrs443, Rrs555)
% MOREL_1   - Chlorphyll alogrithmn
%
% Use as: chl = morel_1(Rrs443, Rrs555)

% Brian Schlining
% 02 Jun 2000

a   = [0.2492 -1.768];
R   = log10(Rrs443./Rrs555);
chl = 10.^(a(1) + a(2)*R);