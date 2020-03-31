function hpol = polargeo(theta,rho,line_style)
% POLARGEO  -  Polar coordinate plot.
%   POLARGEO(THETA, RHO) makes a plot using polar coordinates of
%   the angle THETA, in degrees north, versus the radius RHO.
%   POLARGEO(THETA,RHO,S) uses the linestyle specified in string S.
%   See PLOT for a description of legal linestyles.
%
%   See also PLOT, LOGLOG, SEMILOGX, SEMILOGY, POLAR.

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 2005/04/13 20:38:33 $
% Brian Schlining; 15 Oct 1998; modified POLAR to plot geographically

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
if ~isequal(size(theta),size(rho))
    error('THETA and RHO must be the same size.');
end

theta = deg2rad(geo2mth_(theta)); % Added BS

% get hold state
cax = newplot;
next = lower(get(cax,'NextPlot'));
hold_state = ishold;

% get x-axis text color so grid is in same color
tc = get(cax,'xcolor');
ls = get(cax,'gridlinestyle');

% Hold on to current Text defaults, reset them to the
% Axes' font attributes so tick marks use them.
fAngle  = get(cax, 'DefaultTextFontAngle');
fName   = get(cax, 'DefaultTextFontName');
fSize   = get(cax, 'DefaultTextFontSize');
fWeight = get(cax, 'DefaultTextFontWeight');
fUnits  = get(cax, 'DefaultTextUnits');
set(cax, 'DefaultTextFontAngle',  get(cax, 'FontAngle'), ...
    'DefaultTextFontName',   get(cax, 'FontName'), ...
    'DefaultTextFontSize',   get(cax, 'FontSize'), ...
    'DefaultTextFontWeight', get(cax, 'FontWeight'), ...
    'DefaultTextUnits','data')

% only do grids if hold is off
if ~hold_state

% make a radial grid
    hold on;
    maxrho = max(abs(rho(:)));
    hhh=plot([-maxrho -maxrho maxrho maxrho],[-maxrho maxrho maxrho -maxrho]);
    axis image; v = [get(cax,'xlim') get(cax,'ylim')];
    ticks = sum(get(cax,'ytick')>=0);
    delete(hhh);
% check radial limits and ticks
    rmin = 0; rmax = v(4); rticks = max(ticks-1,2);
    if rticks > 5   % see if we can reduce the number
        if rem(rticks,2) == 0
            rticks = rticks/2;
        elseif rem(rticks,3) == 0
            rticks = rticks/3;
        end
    end

% define a circle
    th = 0:pi/50:2*pi;
    xunit = cos(th);
    yunit = sin(th);
% now really force points on x/y axes to lie on them exactly
    inds = 1:(length(th)-1)/4:length(th);
    xunit(inds(2:2:4)) = zeros(2,1);
    yunit(inds(1:2:5)) = zeros(3,1);
% plot background if necessary
    if ~isstr(get(cax,'color')),
       patch('xdata',xunit*rmax,'ydata',yunit*rmax, ...
             'edgecolor',tc,'facecolor',get(gca,'color'));
    end
% draw radial circles
    c82 = cos(82*pi/180);
    s82 = sin(82*pi/180);
    rinc = (rmax-rmin)/rticks;
    for i=(rmin+rinc):rinc:rmax
        hhh = plot(xunit*i,yunit*i,ls,'color',tc,'linewidth',1);
        text((i+rinc/20)*c82,(i+rinc/20)*s82, ...
            ['  ' num2str(i)],'verticalalignment','bottom')
    end
    set(hhh,'linestyle','-') % Make outer circle solid

% plot spokes
    th = (1:6)*2*pi/12;
    cst = cos(th); snt = sin(th);
    cs = [-cst; cst];
    sn = [-snt; snt];
    plot(rmax*cs,rmax*sn,ls,'color',tc,'linewidth',1)

% annotate spokes in degrees
    rt = 1.1*rmax;
    for i = 1:length(th)
        text(rt*cst(i),rt*snt(i),int2str(mth2geo_(i*30)),'horizontalalignment','center') % Changed BS
        if i == length(th)
            loc = int2str(mth2geo_(0));   % Changed BS
        else
            loc = int2str(mth2geo_(180+i*30)); % Changed BS
        end
        text(-rt*cst(i),-rt*snt(i),loc,'horizontalalignment','center') %Changed BS
    end

% set view to 2-D
    view(2);
% set axis limits
    axis(rmax*[-1 1 -1.15 1.15]);
end

% Reset defaults.
set(cax, 'DefaultTextFontAngle', fAngle , ...
    'DefaultTextFontName',   fName , ...
    'DefaultTextFontSize',   fSize, ...
    'DefaultTextFontWeight', fWeight, ...
    'DefaultTextUnits',fUnits );

% transform data to Cartesian coordinates.
xx = rho.*cos(theta);
yy = rho.*sin(theta);

% plot data on top of grid
if strcmp(line_style,'auto')
    q = plot(xx,yy);
else
    q = plot(xx,yy,line_style);
end
if nargout > 0
    hpol = q;
end
if ~hold_state
    axis image; axis off; set(cax,'NextPlot',next);
end
set(get(gca,'xlabel'),'visible','on')
set(get(gca,'ylabel'),'visible','on')

%===============================================================================
function gdeg = mth2geo_(mdeg) 
% MTH2GEO_ - Convert math angle in degrees to geographic 
% 
% Use As:   geoangle = mth2geo_(mathangle) 
% 
% Input:    math angle       = angle from 0 to +-180 degrees counter-clockwise 
% Output:   geographic angle = angle from 0 to 360 degrees clockwise  
% 
% Example:  mth2geo_([0:30:360]) ->
%           90 60 30  0 330 300 270 240 210 180 150 120 90
% 
% See Also: GEO2MATH_ 

mdeg       = rem(mdeg,360); 
gdeg       = 90 - mdeg; 
ineg       = find(gdeg < 0); 
gdeg(ineg) = gdeg(ineg) + 360; 
      
%=====================================================================================      
function mdeg = geo2mth_(geod) 
% GEO2MTH_ - Converts an angle (degrees) in geographic notation to math notation 
%  
% Use As:   mthang = geo2mth_(geoang) 
% 
% Input:    geoang  = geographic angle (0 to 360 degrees) 
% Output:   mthang  = angle in math notation  (0 to +/-180 degrees) 
% 
% Example:  geo2mth_([0:30:360]) ->
%           90 60 30  0 -30 -60 -90 -120 -150 180 150 120 90
% 
% See Also: MATH2GEO 

mdeg       = 90 - rem(geod,360); 
ineg       = find(mdeg <= -180); 
mdeg(ineg) = mdeg(ineg) + 360; 
      
%=====================================================================================      
function R=deg2rad(D)
%DEG2RAD Converts angles from degrees to radians
%
%  rad = DEG2RAD(deg) converts angles from degrees to radians.

R = D*pi/180;




