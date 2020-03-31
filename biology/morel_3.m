function chl = morel_3(Rrs443, Rrs555)
% MOREL_3   - Chlorophyll algorithmn
%
% Use as: chl = morel_3(Rrs443, Rrs555)

% Brian Schlining
% 02 Jun 2000

a   = [0.20766 -1.82878 0.75885 -0.73979];
R   = log10(Rrs443./Rrs555);
chl = 10.^(a(1) + a(2)*R + a(3).*R.*R + a(4).*R.*R.*R);