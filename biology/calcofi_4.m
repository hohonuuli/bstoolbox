function chl = calcofi_4(Rrs412, Rrs443, Rrs510, Rrs555)
% CALCOFI_4 - CalCOFI four band chlorphyll alogrithmn
%
% chl = calcofi_4(Rrs412, Rrs443, Rrs510, Rrs555)

% Brian Schlining
% 02 Jun 2000

a   = [0.753 -2.583 1.389];
R1  = log10(Rrs443./Rrs555);
R2  = log10(Rrs412./Rrs510);
chl = exp(a(1) + a(2).*R1 + a(3).*R2);