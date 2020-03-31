function [localtime,alt,am,azm,noontime,noonalt] = sunalt_(year,month,day,timezone,lat,long,delT,prtOpt) 
 
% SUNALT_ - Determine solar altitude & azimuth angles from date and position; 
%           plot daily altitude and airmass vs time. 
%  
% Use As:  [alt,am,azm,noontime,noonalt] = sunalt_(year,month,day,timezone,lat,long,delT,prtOpt) 
%  
% Input:    year     = Year as 1997 
%           month    = month as 1..12 
%           day      = day of month as 1..31 
%           timezone = Numeric timezone (+W / -E)  
%                      PST = +8, Hawaii = +10 
%           lat      = Latitude   (decimal degrees +N/-S) 
%           long     = Longitude  (decimal degrees +W/-E) 
%           delT     = Time interval between calculations (default = 0.5 hr) 
%           prtOpt   = Print Option:  0 = print to screen (default = 0) 
%                                or   1 = print to file 'SUNALT.TXT' 
%                                     'FileName.txt' to name the file 
% Output    time     = Local time (decimal hours)  
% Output    alt      = Solar azimuth from sunrise to sunset (degrees) 
%           am       = dimensionless airmas for atm pressure = 1025 mb  
%           azm      = solar azimuth (degrees) 
%           noontime = Time of local noon (hours) 
%           noonalt  = Altitude of local noon 
%
% Example: [alt,am,azm]=sunalt_(1997,07,21,10,20.82,157.18,1,1); 
% 
% See Also: ALMANAC_, ALTAZM_, SUNRISE_, SUNSET_, NOON_, SUNANG2_ 
 
% Copyright 1997 Moss Landing Marine Laboratories 
% 20 July 1997; S. Flora 
% 22 July 1997; W. Broenkow 
% 24 July 1997; W. Broenkow allowed for 24 and 0 hours of daylight change setstr to char 
% 26 July 1997; W. Broenkow added print to file option 
 
if nargin < 6 
  help sunalt_ 
  return 
end 
if nargin < 7 
  delT = 0.5;          % half hour interval  
  prtOpt = 0; 
end 
if nargin < 8 
  prtOpt = 0; 
end 
if prtOpt == 1; 
  FnameS = 'sunalt.txt';  
  fid = fopen(FnameS,'wt'); 
else 
  fid = 1; 
end 
  
% Get the gmt time of sunrise and sunset using the Van Flandern & Pulikken ephemeris 
srise = sunrise_(year,month,day,lat,long); 
sset  =  sunset_(year,month,day,lat,long); 
noontime   = noon_(year,month,day,long);              % GMT time of local noon 
[decl,gha] = almanac_(year,month,day,noontime);       % noon declin and gha 
[noonalt,noonazm] = altazm_(decl,gha,lat,long);       % noon altitude 
sriseL = srise - timezone; 
ssetL  = sset - timezone; 
noonL  = noontime - timezone; 
 
  [D,M] = deg2dms_(noontime-timezone,2); 
  timeS = [num2str(D) ':' num2str(round(M))]; 
  [D,M] = deg2dms_(lat,2); 
  if lat > 0 
    latdir = 'N'; 
  elseif lat < 0 
    latdir = 'S'; 
  else 
    latdir = ''; 
  end 
  degS  = sprintf('%6.0f',D); 
  minS  = sprintf('%04.1f''',0); 
  latS = [degS char(176) ' ' minS latdir]; 
 
  [D,M] = deg2dms_(long,2); 
  if long > 0 
    longdir = 'W'; 
  elseif long < 0 
    longdir = 'E'; 
  else 
    longdir = ''; 
  end 
 
  degS  = sprintf('%6.0f',D); 
  minS  = sprintf('%04.1f''',0); 
  longS = [degS char(176) ' ' minS longdir]; 
  months = ['Jan'; 'Feb'; 'Mar'; 'Apr'; 'May'; 'Jun'; 'Jul'; 'Aug'; 'Sep'; 'Oct'; 'Nov'; 'Dec']; 
 
if ~isfinite(sriseL)   % check for the possibility that the sun does not rise above horizon 
  fprintf(fid,'\nSun Altitude Predictions:\n'); 
  fprintf(fid,'Date:   %7.0f %3s %4.0f Local Zone %3.0f\n',day,months(month,:),year,timezone); 
  fprintf(fid,'Position: %14s %14s\n',latS,longS); 
  fprintf(fid,'Sun does not appear above horizon.\n\n'); 
  localtime = NaN; 
  alt       = NaN; 
  am        = NaN; 
  azm       = NaN; 
  noontime  = NaN; 
  noonalt   = NaN; 
else 
  if isfinite(srise) 
    beginT     = srise; 
    endT       = sset;                                   % old way...round(sset/delT)*delT;                                  
    gmtime     = [beginT:delT:endT srise sset noontime]; % do calculations between sunrise and sunset 
  else         % When sun does not rise or set use 24 hour day 
    beginT = floor(noontime) - 12; 
    endT   = ceil(noontime) + 12 ; 
    gmtime     = [beginT:delT:endT noontime]; % do calculations between sunrise and sunset 
  end 
  gmtime     = sort(gmtime); 
  localtime  = gmtime - timezone; 
  [decl,gha] = almanac_(year,month,day,gmtime);        % Van Flanderen and Pulkkinen (1979) 
  [alt,azm]  = altazm_(decl,gha,lat,long);             % Wayne Wilson (1980) 
  am         = airmas1_(90-alt,1025);                  % Kasten (1966) 
  [m,n]      = size(alt); 
  dT = [diff(gmtime) 999];                             % look for duplicate times 
 
  if prtOpt > 0 
    fprintf(1,'\n*****************************************\n');
 
    fprintf(1,'Sun Altitude Predictions written to file:\n'); 
    fprintf(1,'%s\n',upper(FnameS)); 
    fprintf(1,'*****************************************\n'); 
  end 
   
  fprintf(fid,'\nSun Altitude Predictions:\n'); 
  fprintf(fid,'Date:   %7.0f %3s %4.0f Local Zone %3.0f\n',day,months(month,:),year,timezone); 
  fprintf(fid,'Position: %14s %14s\n',latS,longS); 
  fprintf(fid,'Local Time  Altitude  Azimuth  Airmass\n'); 
  fprintf(fid,'   HH.MM     DD.MM     DD.MM\n'); 
  for i = 1:n 
    if dT(i) ~= 0      % do not print duplicate times 
      if alt(1,i) > 0  
        fprintf(fid,'   %05.2f  %8.2f  %8.2f %8.3f ',deg2dms_(localtime(1,i)),deg2dms_(alt(1,i),1),deg2dms_(azm(1,i),1),am(1,i)); 
      else 
        fprintf(fid,'   %05.2f  %8.2f  %8.2f         ',deg2dms_(localtime(1,i)),deg2dms_(alt(1,i),1),deg2dms_(azm(1,i),1)); 
      end 
      if gmtime(1,i) == srise 
        if isfinite(srise); 
          fprintf(fid,'  Sunrise'); 
        end 
      elseif gmtime(1,i) == sset 
        if isfinite(sset); 
          fprintf(fid,'  Sunset'); 
        end 
      elseif gmtime(1,i) == noontime 
      fprintf(fid,'  Noon'); 
      end 
      fprintf(fid,'\n'); 
    end 
  end 
  fprintf(fid,'% \n'); 
  if fid ~= 1 
    fclose(fid); 
  end 
 
  plot(localtime,alt) 
  xlabel('Local Time (Hrs)') 
  ylabel('Sun Altitude (deg)') 
  Btic = floor(beginT-timezone); 
  Etic = ceil(endT-timezone); 
  set(gca,'Xlim',[Btic Etic],'XTick',[Btic:1:Etic]) 
  set(gca,'Ylim',[-5,90],'Ytick',[0:10:90]) 
  
  title([date_fmt(year,month,day,3) '   ' latS  longS '    noon ' timeS '   Alt ' num2str(noonalt) char(176)]) 
  grid 
  if isfinite(srise); 
    text(localtime(1),0,'Sun Rise'); 
  end 
  if isfinite(sset) 
    tH = text(localtime(length(alt)),alt(length(alt)),'Sun Set'); 
    set(tH,'HorizontalAlignment','right') 
  end 
end 
