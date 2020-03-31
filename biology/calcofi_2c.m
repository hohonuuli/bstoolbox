function chl = calcofi_2c(Rrs490, Rrs555)
% CALCOFI_2C - CalCOFI two band cubic chlorphyll alogrithmn
%
% Use as: chl = calcofi_2c(Rrs490, Rrs555)

% Brian Schlining
% 02 Jun 2000

a   = [0.450 -2.860 0.996 -0.3674];
R   = log10(Rrs490./Rrs555);
chl = 10.^(a(1) + a(2).*R + a(3).*R*R + a(4).*R.*R.*R);