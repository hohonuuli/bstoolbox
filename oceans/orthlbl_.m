**function HANDLES = orthlbl_(ORG,CPT,GDI,LCL) 
**% orthlbl_ - Creates grid labels for orthographic projection maps 
% 
**% Use as: orthlbl_(CenterLongitude,CenterLatitude,GridInterval,LineColor) 
% 
% Inputs: CenterLongitude = The center of the map's longitude 
%         CenterLatitude  = The center of the map's latitude 
%         GridInterval    = the grid interval used in ORTHOMAP 
%         LineColor       = The Desired Color of the labels 
% 
**% See Also: ORTHOMAP.M orthplt_.M 
 
% Brian Schlining 
% 29 Jun 96 
 
% Radius of the earth in miles .............................................. 
Rad  = 3437.746771; 
 
% Convert data to Radians .................................................. 
ORG  = ORG*pi/180; 
CPT  = CPT*pi/180; 
 
% Assign default color ..................................................... 
if nargin < 4 
   LCL = [1 1 1]; 
end 
 
% Create and position the Latitude Labels ................................... 
Lat  = [-90:GDI:90]';                   % This recreates grid in orthomap 
bufS = sprintf('%4i',Lat);              % Forms a row of string values 
 
[m n]= size(bufS); 
j    = [1:4:n];                         % Indirect index used below 
for i = 1:n/4,                          % Convert LatS from a row of values 
   LatS(i,:) = bufS(1,j(i):j(i)+3);     %  to a column for ease of use with 
end                                     %  TEXT 
 
Lon  = ones(size(Lat))*ORG;             % Defines Lon of Lat Labels 
Lon  = Lon*pi/180;                      % Convert to radians 
Lat  = Lat*pi/180; 
 
% Define Lon and Lat of Labels on the orthographic projection 
X    = Rad*cos(Lat).*sin(Lon - ORG); 
Y    = Rad*(cos(CPT).*sin(Lat) - sin(CPT).*cos(Lat).*cos((Lon - ORG))); 
 
% Only plot the labels that are on the front of the earth 
Hide = sin(CPT).*sin(Lat) + cos(CPT).*cos(Lat).*cos(Lon - ORG);
 
i    = find(Hide > 0); 
tHLat = text(X(i),Y(i),LatS(i,:)); 
 
% Create and Position the longitude labels ................................... 
Lon  = [-180:GDI:180]';                 % Recreate Lon grid used in ORTHOMAP 
bufS = sprintf('%4i',Lon);              % Forms a row of string values 
 
[m n]= size(bufS);                      
j    = [1:4:n];                         % Index used below 
for i = 1:n/4, 
   LonS(i,:) = bufS(1,j(i):j(i)+3);     % Convert the row to a volumn of labels 
end 
%[m n] = size(LonS); 
%LonS(1,:) = LonS(m,:); 
 
Lat  = ones(size(Lon))*CPT; 
Lat  = Lat*pi/180; 
Lon  = Lon*pi/180; 
X    = Rad*cos(Lat).*sin(Lon - ORG); 
Y    = Rad*(cos(CPT).*sin(Lat) - sin(CPT).*cos(Lat).*cos(Lon - ORG)); 
Hide = sin(CPT).*sin(Lat) + cos(CPT).*cos(Lat).*cos(Lon - ORG);
 
i    = find(Hide > 0); 
tHLon = text(X(i),Y(i),LonS(i,:)); 
 
tH   = [tHLat;tHLon]; 
set(tH,'Color',LCL, ... 
       'FontSize',8, ... 
       'HorizontalAlignment','center', ... 
       'VerticalAlignment','middle') 
 
 
if nargout == 1 
   HANDLES = tH; 
end 
