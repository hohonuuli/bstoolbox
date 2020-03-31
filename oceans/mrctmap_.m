function lh = mrctrmp(usrlat,usrlon,lcolor,option,limits) 
 
% MRCTRMP_ - Mercator mapping 
% 
% Creates a mercator map of lat's and long's, you can then 
% add other lines, filled polygons or add text to the existing map. 
% Changing the Lat and Long lines requires closing the map figure 
% and creating the map again with new Lat's and Long's specified. 
% 
% Use As:  mrctmap_(usrlat,usrlon,lcolor,option,limits) 
% Inputs:  usrlat = Latitude's to Map (DD.dd w/ -S/+N) 
%          usrlon = Longitude's to Map (DD.dd w/ -W/+E) 
%          lcolor = (optional) line ('g-'), fill ('g' or [R G B]) color 
%                   ,text string to add to plot at usrlat and usrlon 
%                   or direction in degs of arrows 
%          option = (optional) 
%                   0 plot lines (default) 
%                   1 fill lines 
%                   2 add text 
%                   3 add arrow 
%          limits = (optional) Matrix of Map limits (1X6 or 1X8) 
%                   Latmin = Latitude Min (DD.dd)           
%                   Latmax = Latitude Max (DD.dd) 
%                   Lonmin = Longitude Min (DD.dd) 
%                   Lonmax = Longitude Max (DD.dd)  
%                   delLat = Latitude spacing (DD.dd)        
%                   delLon = Longitude spacing (DD.dd)         
%                   keyLat = If not missing, Latitude you want in the middle (DD.dd)         
%                   keyLon = If not missing, Longitude you want in the middle (DD.dd)          
% 
% Output:  Mercator Map 
% CAUTION: When changing the figures 'PaperPosition' the map may not maintain 
%          Mercator spacing. 
 
 
% Mercator mapping is a plot of longitude in minutes vs latitude in "meridional parts". 
% To make the appearance correct the X and Y scales must be adjusted relative to each other. 
% To convert longitude and latitude (both in degrees): 
%      mapX = 60*longitude*Xslope + Xoffset 
%      mapY = meridn1_(latitude)*Yslope + Yoffset 
% To convert map coordinates to longitude and latitude: 
%      long = (mapX - Xoffset)/(60*Xslope) 
%      lat  =  invmerd_((mapY - Yoffset)/Yslope) 
% The conversion between latitude and meridional parts is done by the function 
%      meridin1.m       mapY = meridn1_(latitude) 
% The inverse conversion between meridional parts is done by the function  
%      invmerd_.m       latitude = invmerd_(mapY) 
% The default world outline database is taken from Matlab mapping toolbox
% User-entered map coordinates are passed to this program via variables usrlat,usrlon. 
 
% FUNCTIONS REQUIRED: MERIDN1_, INVMERD_, STRPAD_, DEG2DMS_, PLOTFILL
 
 
% W. Broenkow 
% Copyright 1996 Moss Landing Marine Laboratories 
% 29 Mar 95; W. Broenkow
% 28 Mar 96; W. Broenkow changed names of mercator.m to meridn1_.m 
% 10 Feb to 13 Mar 97; S. Flora - cleared up code, added style elements, like a second axis with a thicker box 
 
%  We still ned to figure out how to set paper ratio for  
%  hardcopy to make exactly scaled Mercator charts. 
 
if nargin == 0 
  help mrctrmap 
  return 
end 
 
if nargin < 2 
  disp('  mrctmap_ Error (2 Inputs required)') 
  return 
end 
 
if nargin < 3 
  lcolor = 'g-'; 
end 
 
if nargin < 4 
  option = 0; 
end 
 
if any(size(usrlat) ~= size(usrlon)) 
  disp('  mrctmap_ Error (usrlat and usrlon must the the same size)') 
  return 
end 
 
% Colors, linewidths and line styles for axis and grids 
gridcolor = [0 0 0];         % Grey 
gridlinestyle = ':';            % Dotted 
axiscolor = [0 0 0];            % White 
axiswidth = 3;                  % Axis box width 
 
% Make the Map figure 
[st,fh] = makefig_('Mercator Map',0, 1); 
if st == 0 
  [st,fh] = makefig_('Mercator Map',1,0); 
end 
screen = get(0,'ScreenSize');           % Make figure the size of the screen 
set(fh,'position',screen);              % set figure position 
set(fh,'visible','on')                  % Make the figure visible 
 
% Add to existing plot if one already exists, do not change the plot labels !!! 
if st == 1 
  % add lines to existing map 
  hold on 
  % Get map axis from figures userdata 
  userdata = get(fh,'Userdata'); 
  maxisH = userdata(3,1);
  axes(maxisH);                         % Make axis with plots in it current 
  set(gca,'nextplot','add') 
  set(gca,'YLimMode','manual') 
  set(gca,'XLimMode','manual') 
  X  = usrlon.*60;        % X in minutes 
  Y  = meridn1_(usrlat); % Y in meridional parts 
  if isnan(Y) 
    disp('  mrctmap_ Error (Latitude Error)') 
    return 
  end 
  
  % Get slope and offset to scale to mercator from figures userdata 
  Xslope = userdata(1,1);
  Xoffst = userdata(1,2);
  Yslope = userdata(2,1); 
  Yoffst = userdata(2,2); 
 
  % Apply slope and offset to unput data 
  Xx = X.*Xslope + Xoffst;
  Yy = Y.*Yslope + Yoffst;
  if option == 0 | isempty(option) 
    lh   = plot(Xx,Yy,lcolor);                                        % plot handle 
  elseif option == 1 
    lh   = plotfll_(Xx,Yy,lcolor);                                    % plot handle 
  elseif option == 2 
    lh   = text(Xx,Yy,lcolor,'color',[0 0 0]);                                        % plot handle 
  elseif option == 3 
    [x,y] = pol2cart(lcolor*pi/180,.2); 
    lh = compass_(y,x,Xx,Yy,'w');                                     % plot handle 
  end 
  y = get(fh,'children'); 
  axes(y(1)); 
  return 
end 
 
if nargin < 5 
  % Create Map limits if not are input 
  Latmin = floor(nanmin(usrlat));                 % Latmin and max are intergers 
  Latmax = ceil(nanmax(usrlat)); 
  Lonmin = floor(nanmin(usrlon));                 % Lonmin and max are intergers 
  Lonmax = ceil(nanmax(usrlon)); 
  delLat = abs(floor((Latmax-Latmin)/5));         % Allows for integer delLat  
  delLon = abs(floor((Lonmax-Lonmin)/5));         % Allows for integer delLon  
  keyLat = [];                                  
  keyLon = [];          
else 
  % Get Map limits if are input 
  [Ml Nl] = size(limits); 
  if Ml ~=1 & Nl ~= 1 
    disp('  mrctmap_ Error (Limits must be a Vector)') 
    close(fh) 
    return 
  end 
  if Ml*Nl < 6 
    disp('  mrctmap_ Error (Limits must contain at lest 6 numbers)') 
    close(fh) 
    return 
  end 
 
  % Get Map limits 
  Latmin = limits(1);                  
  Latmax = limits(2); 
  Lonmin = limits(3);                  
  Lonmax = limits(4); 
  delLat = limits(5);          
  delLon = limits(6);  
  if Ml*Nl == 8   
    keyLat = limits(7);                                  
    keyLon = limits(8);          
  else     
    keyLat = [];                                  
    keyLon = [];          
  end 
end 
 
% If the lat or lon range is very small the delLat or delLon will 
% be returned 0, so recalculate allowing for tenth's of a degree 
if delLat == 0   
  delLat = abs(floor(10*(Latmax-Latmin)/5)/10);   % Allows for delLat in tenth's 
end 
if delLon == 0   
  delLon = abs(floor(10*(Lonmax-Lonmin)/5)/10);   % Allows for delLon in tenth's 
end 
 
% If the lat or lon range is very small the delLat or delLon will 
% be returned 0, so recalculate allowing for hundred's of a degree 
if delLat == 0   
  delLat = abs(floor(100*(Latmax-Latmin)/5)/100);   % Allows for delLat in hundred's 
end 
if delLon == 0   
  delLon = abs(floor(100*(Lonmax-Lonmin)/5)/100);   % Allows for delLon in hundred's 
end 
 
% Convert to meridional parts 
X  = usrlon*60;        % X in minutes 
Y  = meridn1_(usrlat); % Y in meridional parts 
if isnan(Y) 
  disp('  mrctmap_ Error (Latitude Error)') 
  close(fh) 
  return 
end 
 
% Check that mins and maxs are ordered correctly 
if Latmin > Latmax, 
  tmp = Latmin; Latmin = Latmax; Latmax = tmp; 
end; 
if Lonmin > Lonmax, 
  tmp = Lonmin; Lonmin = Lonmax; Lonmax = tmp; 
end; 
 
% Get Meridional Max and Min 
Ymin    = meridn1_(Latmin);     % mercator scales  
Ymax    = meridn1_(Latmax);     % X and Y coordinates 
Ymid    = (Ymax + Ymin)/2;      % midpoints 
Dy      = Ymax - Ymin; 
 
Xmin    = 60*Lonmin; 
Xmax    = 60*Lonmax; 
Xmid    = (Xmax + Xmin)/2; 
Dx      = Xmax - Xmin; 
        
Pr      = (Ymax-Ymin)/(Xmax-Xmin);      % Slope 
 
% Default values X or Y values are changed below 
mapYmin = Ymin; 
mapYmax = Ymax; 
mapXmin = Xmin; 
mapXmax = Xmax; 
 
if Pr > 1                  % latitude range > longitude range 
  W = Dx*Pr/2;             % must increase longitude range 
  mapXmin = Xmid - W; 
  mapXmax = Xmid + W; 
end; 
 
if Pr < 1                 % longitude range > latitude range 
  W = (Dy/2)/(Pr);        % must increase latitude range 
  mapYmin = Ymid - W; 
  mapYmax = Ymid + W; 
end; 
 
% Slope and offset of original to new meridional parts 
Xslope = (mapXmax - mapXmin)/(Xmax - Xmin); 
Xoffst =  mapXmin - Xmin*Xslope; 
Yslope = (mapYmax - mapYmin)/(Ymax - Ymin); 
Yoffst =  mapYmin - Ymin*Yslope; 
 
% Put slopes and offsets in userdata so you can add to this plot 
set(fh,'Userdata',[Xslope Xoffst;Yslope Yoffst;gca 0]); 
 
% Determine grid interval from graphed max and min 
% The grids must be at even degrees in latitude or longitude, 
% and must be within the map extents. 
if Xslope == 1, 
  sclXmin = Lonmin;     % use user-input longitude min and max 
  sclXmax = Lonmax; 
  sclYmin = ceil(invmerd_(mapYmin)); 
  sclYmax = floor(invmerd_(mapYmax)); 
 
  if abs(invmerd_(mapYmin) - invmerd_(mapYmax)) < 1 
    sclYmin = ceil(invmerd_(mapYmin)*100)/100; 
    sclYmax = floor(invmerd_(mapYmax)*100)/100; 
  end 
 
  % Make sure there will more than one tick 
  if sclYmax == sclYmin 
    sclYmin = ceil(invmerd_(mapYmin)*100)/100; 
    sclYmax = floor(invmerd_(mapYmax)*100)/100; 
  end 
end; 
 
if Yslope == 1, 
  sclXmin = ceil((mapXmin-Xoffst)/(60*Xslope)) 
  sclXmax = floor((mapXmax-Xoffst)/(60*Xslope)); 
 
  if abs(invmerd_(mapXmin) - invmerd_(mapXmax)) < 1 
    sclXmin = ceil(invmerd_(mapXmin)*100)/100; 
    sclXmax = floor(invmerd_(mapXmax)*100)/100; 
  end 
  % Make sure there will more than one tick 
  if sclXmax == sclXmin 
    sclXmin = ceil(invmerd_(mapXmin)*100)/100; 
    sclXmax = floor(invmerd_(mapXmax)*100)/100; 
  end 
  sclYmin = Latmin;     % use user-input latitude min and max 
  sclYmax = Latmax; 
end; 
 
lonOK = (mapXmax/(60*Xslope)-mapXmin/(60*Xslope))>=(sclXmax-sclXmin);              % the Map extents must be larger than the Scale extents 
latOK = (invmerd_(mapYmax)-invmerd_(mapYmin))>=(sclYmax-sclYmin);                  % both latOK and lonOK must be positive 
 
% Debugging Stuff keep this 
% fprintf('LonOK: %3.0f  LatOK: %3.0f \n',lonOK,latOK) 
% fprintf('USER %6.2f %6.2f %6.2f %6.2f \n',Lonmin,Lonmax,Latmin,Latmax) 
% fprintf('MAP  %6.2f %6.2f %6.2f %6.2f \n',... 
%        mapXmin/60,mapXmax/60,invmerd_(mapYmin)/Yslope,invmerd_(mapYmax)/Yslope) 
% fprintf('SCL  %6.2f %6.2f %6.2f %6.2f \n',sclXmin,sclXmax,sclYmin,sclYmax) 
 
% These scaled values are plotted 
Xx = X*Xslope + Xoffst; 
Yy = Y*Yslope + Yoffst; 
 
% Plot Lines or fill plots 
if option == 0 | isempty(option) 
  lh   = plot(Xx,Yy,lcolor);                                        % plot handle 
elseif option == 1 
  lh   = plotfll_(Xx,Yy,lcolor);                                    % fill handle 
end 
 
%........................................................................................... 
% Set Axis properies 
ah   = gca;                                                         % axis handle 
set(ah,'YtickMode','manual'); 
set(ah,'XtickMode','manual'); 
 
set(ah,'YtickLabelMode','manual'); 
set(ah,'XtickLabelMode','manual'); 
 
set(ah,'ylim',[mapYmin mapYmax]); 
set(ah,'clipping','on'); 
set(ah,'climmode','auto'); 
set(ah,'ylimMode','auto'); 
set(ah,'xlim',[mapXmin, mapXmax]); 
axis([mapXmin mapXmax mapYmin mapYmax]);                           % makes correct proportion... now 
 
%........................................................................................... 
% Draw and label meridians 
Longrid = sclXmin:delLon:sclXmax; 
 
% If there is a longitude you want to center the map on the move the scales 
% so that it is in the center. 
if ~isempty(keyLon) 
  % Check to see if key longitude is in the list 
  diffx    = min(abs(Longrid - keyLon)); 
  newgrid = Longrid + diffx; 
  ok      = find(newgrid==0); 
  if (~ok), newgrid = Longrid + diffx; end; % might need to add the difference 
  Longrid = newgrid; 
end 
 
% Set ticks and labels 
set(ah,'Xtick',Xslope*Longrid*60 + Xoffst); 
set(ah,'Xgrid','on'); 
[mm nn] = size(Longrid); 
if any(floor(floor(Longrid.*10) - floor(Longrid).*10) > 0) 
  lablen = 11; 
  xlbl = zeros(nn,lablen); 
  for kk = 1:nn, 
    [londeg lonmin] = deg2dms_(abs(Longrid(kk)),2); 
    if (Longrid(kk)  > 0),  
      degstr = sprintf('%3.0f',abs(londeg)); 
      minstr = sprintf('%4.1f',abs(lonmin)); 
      xlbl(kk,1:lablen) = strpad_([degstr setstr(176) minstr ''' E'],lablen); 
    end; 
    if (Longrid(kk)  == 0),  
      degstr = sprintf('%3.0f',abs(londeg)); 
      minstr = sprintf('%4.1f',abs(lonmin)); 
      xlbl(kk,1:lablen) = strpad_([degstr setstr(176) minstr ''''],lablen); 
    end; 
    if (Longrid(kk)  < 0),  
      degstr = sprintf('%3.0f',abs(londeg)); 
      minstr = sprintf('%4.1f',abs(lonmin)); 
      xlbl(kk,1:lablen) = strpad_([degstr setstr(176) minstr ''' W'],lablen); 
    end; 
  end; 
else 
  lablen = 7; 
  xlbl = zeros(nn,lablen); 
  for kk = 1:nn, 
    if (Longrid(kk)  > 0),  
      degstr = sprintf('%3.0f',abs(Longrid(kk))); 
      xlbl(kk,1:lablen) = strpad_([degstr setstr(176) ' E'],lablen); 
    end; 
    if (Longrid(kk)  == 0),  
      degstr = sprintf('%3.0f',Longrid(kk)); 
      xlbl(kk,1:lablen) = strpad_([degstr setstr(176) ],lablen); 
    end; 
    if (Longrid(kk)  < 0),  
      degstr = sprintf('%3.0f',abs(Longrid(kk))); 
      xlbl(kk,1:lablen) = strpad_([degstr setstr(176) ' W'],lablen); 
    end; 
  end; 
end 
 
%........................................................................................... 
Latgrid = sclYmin:delLat:sclYmax; 
% Make sure 0 have a tick 
if sclYmin < 0 & sclYmax > 0 
  Latgrid = [Latgrid 0]; 
end 
Latgrid = sort(Latgrid); 
 
% If there is a lat you want to center the map on the move the scales 
% so that it is in the center. 
if ~isempty(keyLat) 
  % Check to see if key latitude is in the list 
  diffy    = min(abs(Latgrid - keyLat)); 
  newgrid = Latgrid + diffy; 
  ok      = find(newgrid==0); 
  if (~ok), 
    newgrid = Latgrid + diffy; 
  end 
  bad     = find(abs(newgrid)>89.9); 
  if (bad), 
    newgrid(bad) = NaN; 
  end 
  Latgrid = newgrid; 
end 
 
ticks = Yslope*meridn1_(Latgrid) + Yoffst; 
 
% Set Ticks and Labels 
set(ah,'Ytick',ticks);      % correct for scaling 
set(ah,'Ygrid','on'); 
[mm nn] = size(Latgrid); 
if any(floor(floor(Latgrid.*10) - floor(Latgrid).*10) > 0) 
  lablen = 11; 
  ylbl = zeros(nn,lablen); 
  for kk = 1:nn, 
    [latdeg latmin] = deg2dms_(abs(Latgrid(1,kk)),2); 
    if (Latgrid(1,kk)  > 0), 
      degstr = sprintf('%3.0f',abs(latdeg)); 
      minstr = sprintf('%4.1f',abs(latmin)); 
      ylbl(kk,1:lablen) = strpad_([degstr setstr(176) minstr ''' N'],lablen); 
    end; 
    if (Latgrid(1,kk)  == 0), 
      degstr = sprintf('%3.0f',abs(latdeg)); 
      minstr = sprintf('%4.1f',abs(latmin)); 
      ylbl(kk,1:lablen) = strpad_([degstr setstr(176) minstr ''''],lablen); 
    end; 
    if (Latgrid(1,kk)  < 0), 
      degstr = sprintf('%3.0f',abs(latdeg)); 
      minstr = sprintf('%4.1f',abs(latmin)); 
      ylbl(kk,1:lablen) = strpad_([degstr setstr(176) minstr ''' S'],lablen); 
    end; 
  end; 
else 
  lablen = 6; 
  ylbl = zeros(nn,lablen); 
  for kk = 1:nn, 
    if (Latgrid(1,kk)  > 0), 
      degstr = sprintf('%2.0f',abs(Latgrid(1,kk))); 
      ylbl(kk,1:lablen) = strpad_([degstr setstr(176) ' N'],lablen); 
    end; 
    if (Latgrid(1,kk) == 0), 
      degstr = sprintf('%2.0f',abs(Latgrid(1,kk))); 
      ylbl(kk,1:lablen) = strpad_([degstr setstr(176) ],lablen); 
    end; 
    if (Latgrid(1,kk)  < 0),  
      degstr = sprintf('%2.0f',abs(Latgrid(1,kk))); 
      ylbl(kk,1:lablen) = strpad_([degstr setstr(176) ' S'],lablen); 
    end; 
  end; 
end 
 
% Scale the map correctly for 3/4 full screen depending on paper ratio, Pr 
% 3/4  p1 = 40; p2 = 30; p3 = 440; p4 = 330; 
x1 = screen(1); y1 = screen(2); x2 = screen(3); y2 = screen(4);
 
if (Pr < 1), 
  y2 = y1+Pr*(y2-y1);           % Pr <1 so shrink Y 
end; 
if (Pr > 1), 
  x2 = x1+(x2-x1)/Pr;           % Pr >1 so shrink X 
end;  
 
%set(fh,'position',[x1 y1 x2 y2]) 
if Xslope == 1 
  set(ah,'aspectratio',[1 1/Pr]); 
else 
  set(ah,'aspectratio',[1/Pr 1]); 
end 
 
orient = 0; 
if ((orient ~= 0) & (orient ~= 1)), 
  orient = 1;                   % default orientation is landscape 
end; 
if (orient == 0), 
  disp('Set Orientation to Portrait') 
  set(fh,'PaperOrientation','portrait'); 
end; 
 
if (orient == 1), 
  disp('Set Orientation to Landscape') 
  set(fh,'PaperOrientation','landscape'); 
  set(fh,'PaperPosition',[2.75 1.5 4.5 6]); 
end 
 
% Do not set the paperpsotion here aspect ratio will make sure the map  
% has mercator spacing, I THINK???? 
%set(fh,'PaperUnits','Inches'); 
%set(fh,'PaperPosition',[left bottom width height]); 
 
set(gca,'Box','On'); 
set(gca,'XColor',gridcolor); 
set(gca,'YColor',gridcolor); 
set(gca,'GridLineStyle',gridlinestyle); 
 
% Create a extra axis so you can have a wider box 
gcapos = get(gca,'position'); 
gcaasp = get(gca,'AspectRatio'); 
axes('Position',gcapos); 
ah   = gca                                                         % axis handle 
set(ah,'AspectRatio',gcaasp); 
set(ah,'Box','on'); 
set(ah,'linewidth',axiswidth); 
%set(ah,'XColor',axiscolor); 
%set(ah,'YColor',axiscolor); 
 
set(ah,'YtickMode','manual'); 
set(ah,'XtickMode','manual'); 
 
set(ah,'YtickLabelMode','manual'); 
set(ah,'XtickLabelMode','manual'); 
 
set(ah,'ylim',[mapYmin mapYmax]); 
set(ah,'clipping','on'); 
set(ah,'climmode','auto'); 
set(ah,'xlim',[mapXmin, mapXmax]); 
 
set(ah,'Xtick',Xslope*Longrid*60 + Xoffst); 
set(ah,'Ytick',ticks);      % correct for scaling 


xlbl = char(xlbl);
ylbl = char(ylbl);
set(ah,'XTickLabel',xlbl); 
set(ah,'YTickLabel',ylbl); 
 
 
