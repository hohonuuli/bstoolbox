function [aH,q] = geopolr_(theta,rho,line_style,TTitle) 

% GEOPOLR_ - Polar coordinate plot using geographic angle 
% 
% Use As: aH = geopolr_(theta,rho,line_style) 
% 
% Input:    theta_ = vector containing angle (degrees geographic) 
%              rho = vector containing magnitude 
%        linestyle = string containing line style 
%            title = string containing graph title
%
% Output:       aH = axis handle to polar plot so we can change things
% 
% See Also: POLAR, PLOT, LOGLOG, SEMILOGX, SEMILOGY, GEOCMPS_ 
% Note: This was adapted from MathWorks POLAR.M and requires  
%       DEG2RAD_ and GEO2MATH_ 
 
% Copyright (c) 1984-94 by The MathWorks, Inc. 
% 5 Aug 96; W. Broenkow adapted from POLAR.M 
% 2 Jul 97; W. Broenkow changed help 
% 22 Jun 98; S. Flora - Rewritten and Works in Matlab 5.2
% 02 Dec 98; S. Flora - fixed the 240 label 

theta = deg2rad_(geo2mth_(theta)); % change input from geographic degrees to math radians
 
aH = [];

if nargin < 1 
  error('Requires 2 or 3 input arguments.') 
elseif nargin == 2  
  if isstr(rho) 
    line_style = rho; 
    rho = theta; 
    [mr,nr] = size(rho); 
    if mr == 1 
      theta = 1:nr; 
    else 
      th = (1:mr)'; 
      theta = th(:,ones(1,nr)); 
    end 
  else 
    line_style = 'auto'; 
  end 
elseif nargin == 1 
  line_style = 'auto'; 
  rho = theta; 
  [mr,nr] = size(rho); 
  if mr == 1 
    theta = 1:nr; 
  else 
    th = (1:mr)'; 
    theta = th(:,ones(1,nr)); 
  end 
end 
if isstr(theta) | isstr(rho) 
  error('Input arguments must be numeric.'); 
end 
if any(size(theta) ~= size(rho)) 
  error('THETA and RHO must be the same size.'); 
end 
 
% Get hold state 
cax = newplot; 
next = lower(get(cax,'NextPlot')); 
hold_state = ishold; 
 
% Get x-axis text color so grid is in same color 
tc = get(cax,'xcolor'); 
 
% Hold on to current Text defaults, reset them to the 
% Axes' font attributes so tick marks use them. 
fAngle  = get(cax, 'DefaultTextFontAngle'); 
fName   = get(cax, 'DefaultTextFontName'); 
fSize   = get(cax, 'DefaultTextFontSize'); 
fWeight = get(cax, 'DefaultTextFontWeight'); 
set(cax, 'DefaultTextFontAngle',  get(cax, 'FontAngle'), ... 
        'DefaultTextFontName',   get(cax, 'FontName'), ... 
        'DefaultTextFontSize',   get(cax, 'FontSize'), ... 
        'DefaultTextFontWeight', get(cax, 'FontWeight') ) 
 
% Only do grids if hold is off 
if ~hold_state 
 
% Make a radial grid 
  hold on; 
    hhh = plot([0 max(theta(:))],[0 max(abs(rho(:)))]); 
      v = [get(cax,'xlim') get(cax,'ylim')]; 
  ticks = length(get(cax,'ytick')); 
  delete(hhh); 
% Check radial limits and ticks 
  rmin = 0; rmax = v(4); rticks = ticks-1; 
  if rticks > 5   % see if we can reduce the number 
    if rem(rticks,2) == 0 
      rticks = rticks/2; 
    elseif rem(rticks,3) == 0 
      rticks = rticks/3; 
    end 
  end 

% Return the axis handle as aH
  aH = gca;

% Define a circle 
     th = 0:pi/50:2*pi; 
  xunit = cos(th); 
  yunit = sin(th); 

% Now really force points on x/y axes to lie on them exactly 
  inds = [1:(length(th)-1)/4:length(th)]; 
  xunits(inds(2:2:4)) = zeros(2,1); 
  yunits(inds(1:2:5)) = zeros(3,1); 
 
  rinc = (rmax-rmin)/rticks; 
  for i=(rmin+rinc):rinc:rmax 
    plot(xunit*i,yunit*i,'-','color',tc,'linewidth',1); 
    th = text(0,i+rinc/20,['  ' num2str(i)],'verticalalignment','bottom' ); 
    set(th,'FontName','Times','FontWeight','demi','FontSize',14);% WB added this
  end 
 
% Plot spokes 
   th = (1:6)*2*pi/12; 
  cst = cos(th); snt = sin(th); 
   cs = [-cst; cst]; 
   sn = [-snt; snt]; 
  plot(rmax*cs,rmax*sn,'-','color',tc,'linewidth',1); 
 
% Annotate spokes in degrees 
   rt = 1.1*rmax; 
   for i = 1:max(size(th)) 
     lblangle = mth2geo_(i*30);         % change math angle to geographic 
     th = text(rt*cst(i),rt*snt(i),int2str(lblangle),'horizontalalignment','center' ); 
     set(th,'FontName','Times','FontWeight','demi');     % W. Broenkow was here
     if i == max(size(th)) 
       loc = int2str(mth2geo_(210));      % change math angle to geographic 
     else
       lblangle = mth2geo_(180+i*30); 
       loc = int2str(lblangle);         % change math angle to geographic 
     end 
     th = text(-rt*cst(i),-rt*snt(i),loc,'horizontalalignment','center' ); 
     set(th,'FontName','Times','FontWeight','demi');     % and here
   end 
 
% Set viewto 2-D 
   view(0,90); 
% Set axis limits 
   axis(1.4*rmax*[-1 1 -1.1 1.1]);      % make axes smaller use my 1.4 fudge factor
end 
 
% Reset defaults. 
set(cax, 'DefaultTextFontAngle', fAngle , ... 
         'DefaultTextFontName',   fName , ... 
         'DefaultTextFontSize',   fSize, ... 
         'DefaultTextFontWeight', fWeight ); 
 
% Add title
if exist('TTitle')
  XXlim = get(gca,'Xlim');
  YYlim = get(gca,'Ylim');
  DX    = diff(XXlim);
  DY    = diff(YYlim);
  tx    = XXlim(1)-DX/10;
  ty    = YYlim(2)-DY/9;
  tH = text(tx,ty,TTitle);
  set(tH,'FontSize',14,'FontWeight','Demi','FontName','Times')
end

% Transform data to Cartesian coordinates. 
xx = rho.*cos(theta); 
yy = rho.*sin(theta); 
 
% Plot data on top of grid 
if strcmp(line_style,'auto') 
  q = plot(xx,yy); 
else 
  q = plot(xx,yy,line_style); 
end 

if nargout > 0 
  hpol = q; 
end 
if ~hold_state 
  axis('equal');axis('off'); 
end 
 
% Reset hold state 
if ~hold_state, set(cax,'NextPlot',next); end 
 
