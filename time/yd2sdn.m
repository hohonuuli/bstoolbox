function sdn = yd2sdn(yd)
% YD2SDN    - Convert year-day (like 2002163) to serial datenumbers

% Brian Schlining
% 13 Jun 2002

year = floor(yd/1000);
day =  yd - (year)*1000;
sdn = jul2date(day, year);