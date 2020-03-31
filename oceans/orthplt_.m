**function HANDLE = orthplt_(LON,LAT,ORG,CPT,LTP) 
**% orthplt_  - Plot orthographic projection of the world 
% 
**% Use As: orthplt_(Longitude,Latitude,CenterLongitude,CenterLatitude,LineType) 
% 
% Inputs: CenterLongitude = Longitude of Center of Map 
%         CenterLatitude  = Latitude of Center of Map 
%         LineType        = optional string designating linetypes  
%                           (see PLOT for valid strings) 
% 
% Outputs: Returns two plot handles. The first is to the data in LON  
%          and LAT, the second is to the earth's outline. 
% 
**% See Also: orthmap_.M, ORTHOLBL.M 
 
% CenterPoint = Latitude of viewer (USGS term) 
% Origin      = Longitude of Viewer (USGS term) 
 
% B. Schlining 
% 21 Jun 96 
 
mlglobal 
 
if nargin < 5 
   LTP = 'y'; 
end 
 
% Radius of the earth in miles?.............................................. 
Rad = 3437.746771;       
 
% Convert degrees to radians................................................. 
CPT = CPT*pi/180; 
LAT = LAT*pi/180; 
LON = LON*pi/180; 
ORG = ORG*pi/180; 
 
% Calculate position in miles of all the coastlines........................... 
X   = Rad*cos(LAT).*sin((LON - ORG)); 
Y   = Rad*(cos(CPT).*sin(LAT) - sin(CPT).*cos(LAT).*cos(LON - ORG)); 
 
% Calculate which lines are hidden........................................... 
h   = sin(CPT).*sin(LAT) + cos(CPT).*cos(LAT).*cos(LON - ORG); 
 
% Plot only the visible lines................................................ 
i   = find(h < 0); 
mNaN = ones(size(i))*NaN; 
Y(i) = mNaN; 
X(i) = mNaN; 
hold on 
opH = plot(X,Y,LTP); 
hold off 
axis off 
axis equal 
 
if nargout == 1 
   HANDLE = opH; 
end 
