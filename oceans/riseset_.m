function [T_noon,T_rise,T_set,doy] = riseset_(lat,lon,days) 
% RISESET_ - Plot yearly graph giving time of sunrise, sunset_, local 
%            apparent noon_, and length of daylight for a given position. 
% 
% Use As:   [T_noon,T_rise,T_set,doy] = riseset_(lat,lon,days)
% 
% Input:    lat    = latitude (decimal degrees +N-S) 
%           lon    = longitude(decimal degrees +W-S) 
%           days   = number of days between calculations (default = 1) 
%           doy    = day of year (1-365) 
% Output:   T_noon = local hour of local apparent noon for each day/year
%           T_rise =   "    "      sunrise 
%           T_set  =   "    "      sunset 
%           day    = day of the year for plotting 
%           Graph for yearly daylight, etc 
%  
% Note:     This procedure uses a low precision ephemeris (SUNANG2) 
% 
% See Also: ALMANAC_, NOON_, SUNRISE_, SUNSET_ 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 29 May 96; W. Broenkow 
 
if nargin < 2
  disp('RISESET Error: Must input Latitude and Longitude')
  break
end
if nargin == 2 
  days = 1; 
end 
zone = round(lon/15); 
mpts = floor(366/days) + 1;
doy    = NaN*ones(mpts,1); 
T_noon = NaN*ones(mpts,1); 
T_rise = NaN*ones(mpts,1); 
T_set  = NaN*ones(mpts,1); 
A_rise = NaN*ones(mpts,1); 
A_set  = NaN*ones(mpts,1); 
  
for m = 1:12 
  first(m) = julday_(1996,m,1);     % julian day of first of the month 
end 
dayperm = [diff(first) 31]; 
months=(['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec']); 
 
% The following loop is cleaner, but cannot be used with variable day increment 
% dy = 0; 
% for m = 1:12 
%   for d = 1:dayperm(m) 
%     dy = dy + 1; 
%     [T_rise(dy,1),A_rise(dy,1)] = sunrise_(1996,m,d,lat,lon); 
%     [T_noon(dy,1)]              = noon_(1996,m,d,lon); 
%     [T_set(dy,1),A_set(dy,1)]   = sunset_(1996,m,d,lat,lon); 
%   end 
% end 
 
N = 0; 
dayone = floor(juldate(1996,1,0));   % any year will do this is a leap year 
fprintf('Calculating Sunrise Sunset Noon ')
for dy = 1:days:366
  if rem(dy,7) == 0;
    fprintf('.') 
  end
  N = N + 1; 
  [dmy y m d] = caldate_(dayone + dy); 
  doy(N) = dy;                                            % for plotting 
  [T_rise(N,1),A_rise(N,1)] = sunrise_(1996,m,d,lat,lon); 
  [T_noon(N,1)]             = noon_(1996,m,d,lon); 
  [T_set(N,1),A_set(N,1)]   = sunset_(1996,m,d,lat,lon); 
end 
fprintf('\n')
 
figure(1);clf; 
pH = plot(doy,T_set-zone,'r'); 
set(pH,'LineWidth',3); 
hold on; 
pH = plot(doy,T_set-T_rise,'c'); 
set(pH,'LineWidth',3); 
pH = plot(doy,T_noon-zone,'y'); 
set(pH,'LineWidth',3); 
pH = plot(doy,T_rise-zone,'g'); 
set(pH,'LineWidth',3); 
ylabel('Local Hour'); 
axis('square'); 
aH = gca; 
set(aH,'Ylim',[floor(nanmin(T_rise)-zone) ceil(nanmax(T_set)-zone)]); 
xlabel('Month'); 
set(aH,'XTickMode','manual'); 
set(aH,'Xlim',[-15 365+15]); 
set(aH,'Xtick',[first 365]); 
set(aH,'XTickLabelMode','manual'); 
set(aH,'XTickLabel',[months; '   ']); 
 
set(aH,'YTickMode','manual'); 
set(aH,'Ylim',[0 24]); 
set(aH,'Ytick',[0 2 4 6 8 10 12 14 16 18 20 22 24]); 
set(aH,'YTickLabelMode','manual'); 
set(aH,'YTickLabel',['  ';' 2';' 4';' 6';' 8';'10';'12';'14';'16';'18';'20';'22';'  ']); 
grid on; 
legend('Sunset','Day Length','Noon','Sunrise'); 
if lat < 0 
  ns = 'S'; 
else 
  ns = 'N'; 
end 
if lon < 0 
  ew = 'E'; 
else 
  ew = 'W'; 
end 
tS = sprintf('Latitude: %5.1f %s Longitude %6.1f %s',abs(lat),ns,abs(lon),ew); 
title(tS); 
hold off; 
