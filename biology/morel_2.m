function chl = morel_2(Rrs490, Rrs555)
% MOREL_2   - Chlorophyll algorithmn
%
% Use as: chl = morel_2(Rrs490, Rrs555)

% Brian Schlining
% 02 Jun 2000

a   = [1.077835 -2.542605];
R   = log(Rrs490./Rrs555);
chl = exp(a(1) + a(2).*R);