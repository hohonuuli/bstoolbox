function sdn = rjday2sdn(rjday)
% RJDAY2SDN - Convert Running julian day (Days since 1 Jan 1988) to datenumbers
%
% Use as: sdn = rjday2sdn(rjday)

% Brian Schlining
% 24 May 2000

sdn = rjday + datenum('31 Dec 1987 00:00:00');