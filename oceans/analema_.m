function [dec,eqt,alt,azm] = analema_(lat,lon,place) 
% ANALEMA_ - Use a low precision sun almanac to draw the analema_ which 
%            is a plot of solar declination against the equation of time. 
% 
% Use As:  analema_  without parameters to plot analemma and noon sun 
%                    position for MLML 36.8 N 121.8 W 
%     or:  [dec,eqt,alt,azm] = analema_(lat,lon) to plot analemma and 
%                   noon sun position for any latitude or longitude 
% 
% Inputs:  lat   = latitude of position (decimal degrees) 
%          lon   = longitude of position (decimal degrees) 
%          place = string containing text to annotate local noon sun graph 
%                  default = '12:08 Local Time at MLML'
% Outputs: dec = sun declination (decimal degrees) 
%          eqt = Equation of Time (decimal degrees) 
%          alt = sun altitude at noon for given position (decimal degrees) 
%          azm = solar azimuth at noon for given position (decimal degrees) 
% 
%          Note: All outputs are computed for 365 days for a "generic" year 
%          using a low precision ephemeris sunang2_.m by Howard Gordon which 
%          is a simplified version of that by Wayne H. Wilson (1980) Solar  
%          Ephemeris Algorithm, Scripps Institution of Oceanography  
%          Ref. 80-13. July 1980  
% 
% See Also:  SUNANG2_ ALMANAC_  
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 29 May 96; W. Broenkow 
%  5 Aug 96; W. Broenkow added polar plot and use of geopolr_.m
 
% 21 Feb 97; W. Broenkow Matlab 5.0 compatible 
 
MLML = 0;                                 % Flag to use hardlined scales 
if nargin < 3; place = ' '; end; 
if nargin <2 
  lon   = dms2deg_(121.48,0);             % MLML N latitude 
  place = '12:08 Local Time at MLML';     % header for noon_ altitude plot 
  MLML  = 1; 
end 
if nargin <1 
  lat = dms2deg_(36.48,0);                % MLML W longitude 
end 
lan = 12 + lon/15;                        % mean local noon at place 
 
zen = zeros(365,1); 
azm = zeros(365,1); 
dec = zeros(365,1); 
eqt = zeros(365,1); 
 
% Plot the Analemma 
for m = 1:12 
  first(m) = julday_(1996,m,1);        % julian day of first of the month 
end 
months=(['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec']); 
for d = 1:365   
  [zen(d,1),azm(d,1),dec(d,1),eqt(d,1)] = sunang2_(d,lan,lat,lon); 
end 
alt = 90 - zen; 
figure(1);clf;plot(eqt,dec); 
xlabel('Equation of Time (degrees)'); 
ylabel('Declination (degrees)'); 
title('The Analemma'); 
axis([-5 +5 -25 +25]); 
axis('square'); 
hold on; 
plot(eqt(first),dec(first),'+'); 
for m = 1:12 
  tH = text(eqt(first(m))+.2,dec(first(m)),months(m,:)); 
  set(tH,'color','g'); 
end 
aH = gca; 
set(aH,'XTickMode','manual'); 
set(aH,'Xlim',[-5 5]); 
set(aH,'Xtick',[-5:5]); 
grid on; 
hold off; 
 
% Plot the mean noon sun position for the given positions 
figure(2);clf; 
if lat < 0                % in southern hemisphere azimuth changes from 
  sazm = azm;             % near 360 to near 0 
  i = find(sazm >180);    
  sazm(i) = sazm(i) - 360; 
  plot(-sazm,alt); 
else 
  plot(-azm,alt);         % make west azimuth negative 
end 
xlabel('Sun noon Azimuth'); 
ylabel('Sun noon Altitude'); 
title(place) 
axis('square'); 
hold on; 
if lat < 0 
  plot(-sazm(first),alt(first),'+'); 
  for m = 1:12 
    tH = text(-sazm(first(m))+.2,alt(first(m)),months(m,:)); 
    set(tH,'color','g'); 
  end 
else 
  plot(-azm(first),alt(first),'+'); 
  for m = 1:12 
    tH = text(-azm(first(m))+.2,alt(first(m)),months(m,:)); 
    set(tH,'color','g'); 
  end 
end 
aH = gca; 
if MLML == 1 
  axis([-187 -173 25 80]); 
  set(aH,'XTickMode','manual'); 
  set(aH,'Xlim',[-187 -173]); 
  set(aH,'Xtick',[-187:-173]); 
  set(aH,'XtickLabelMode','manual'); 
  set(aH,'XTickLabel',['   ';'186';'   ';'184';'   ';'182';'   ';'180';'   ';'178';'   ';'176';'   ';'174';'   ']); 
end 
grid on; 
hold off; 
 
 figure(3); 
geopolr_(azm,alt);                     % geopolr_ uses geographic angles 
hold on; 
geopolr_(azm(first),alt(first),'+r'); 
title(place); 
hold off; 
