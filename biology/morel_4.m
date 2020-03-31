function chl = morel_4(Rrs490, Rrs555)
% MOREL_4   - Chlorophyll algorithmn
%
% Use as: chl = morel_4(Rrs490, Rrs555)

% Brian Schlining
% 02 Jun 2000

a   = [1.03117 -2.40134 0.3219897 -0.291066];
R   = log10(Rrs490./Rrs555);
chl = 10.^(a(1) + a(2)*R + a(3).*R.*R + a(4).*R.*R.*R);