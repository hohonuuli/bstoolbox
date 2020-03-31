function s = gmtstr
% GMTSTR - Geneartes a string of the current time in GMT 
%
% Use as: s = gmtstr

% Brian Schlining
% 20 Feb 2004

c = java.util.GregorianCalendar(java.util.TimeZone.getTimeZone('GMT'));
c.setTime(java.util.Date);

Y = c.get(c.YEAR);
M = c.get(c.MONTH) + 1;
D = c.get(c.DAY_OF_MONTH);
h = c.get(c.HOUR_OF_DAY);
m = c.get(c.MINUTE);
s = c.get(c.SECOND);

s = sprintf('%04i-%02i-%02i %02i:%02i:%02iGMT', Y, M, D, h, m, s);