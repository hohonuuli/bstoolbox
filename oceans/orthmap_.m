**function orthmap_(ORG,CPT,LTP,GDI,GLF,LCL) 
**% orthmap_  Create orthographic map of the world on the default display 
% 
**% Use As: orthmap_(CenterLongitude,CenterLatitude,LineType,GridInterval,... 
%                  GridLabelFlag,LabelColor) 
% 
% Inputs: Data from WORLDMAP.MLD 
%         CenterLongitude = Longitude of Center of Map(-W +E) 
%         CenterLatitude  = Latitude of Center of Map (-S +N) 
%         LineType        = Optional argument defining Line Type 
%                           (see PLOT for valid types) 
%         GridInterval    = Optional Argument defining the interval in  
%                           degrees of the grid (default = 10) 
%         GridLabelFlag   = 0 or none specified: no lat and lon labels 
%                           1 labels all line 
%                           2 labels every other line 
%         LabelColor      = optional argument 1x3 color matrix defining 
%                           label colors. default = LineType Color 
%          
**% See Also: orthplt_.M, ORTHOLBL.M 
 
% CenterPoint = Latitude of Center of map (USGS term) 
% Origin      = Longitude of center of map (USGS term) 
% 
% To adjust coast colors: H = findobj('Color',[Color matrix for LPT]); 
%                         set(H,'Color',[Color matrix of the new color] 
% 
% To adjust grid colors:  H = findobj('Color',[Color matrix for LPT]/3); 
%                         set(H,'Color',[new color matix]) 
% 
% For Custom maps: 1) Use the zoom function to adjust view 
%                  2) set(gca,'box','on') 
% 
% To plot additional data on the map:  
%                     hold on;ORTHOPLT(DataLat, DataLon,ORG,CPT) 
 
% Brian Schlining 
**% 25 June 96, rev.26Jun96 placed circle outline in orthmap_ to speed up  
% drawing time. 
 
% Load WORLDMAP.MLD unless the user supplies another map 
mlglobal 
if ~exist('Xdat') 
   mlload('..\mlcommon\worldmap.mld'); 
end 
 
% Set the Default line type................................................ 
if nargin < 3 
   LTP = 'y'; 
end 
 
if nargin < 4 
   GDI = 10; 
end 
 
% Radius of the earth in miles............................................. 
Rad = 3437.746771;       
 
% Plot the outline of the world............................................ 
x   = linspace(-pi,pi); 
pH  = plot(cos(x)*Rad,sin(x)*Rad,LTP); 
Color = get(pH,'Color'); 
set(pH,'Color',Color)          % Removed  To Mute the outline Color/3  
 
% Create lines of equal latitude........................................... 
Lon = linspace(-180,180,100); 
Lat = ones(size(Lon)); 
 
for i = -90:GDI:90 
   hold on 
**   pH = orthplt_(Lat*i,Lon,ORG,CPT,LTP); 
   set(pH,'Color',Color/2)                      % Mute the grid colors 
   hold off 
end 
 
% Create Lines of equal logitude........................................... 
Lat = linspace(-90,90,100); 
Lon = ones(size(Lat)); 
 
for i = -180:GDI:180 
   hold on 
**   pH = orthplt_(Lat,Lon*i,ORG,CPT,LTP); 
   set(pH,'Color',Color/3) 
   hold off 
end 
 
% Create map............................................................... 
hold on 
**orthplt_(Xdat(:,2),Xdat(:,1),ORG,CPT,LTP) 
hold off 
 
% Add Lat and Lon Labels .................................................. 
if nargin < 5 
   GLF = 0; 
end 
if nargin < 6 
   LCL = Color/1.5; 
end 
if GLF > 0,  
   GDI = GDI*GLF; 
**   orthlbl_(ORG,CPT,GDI,LCL) 
end 
 
