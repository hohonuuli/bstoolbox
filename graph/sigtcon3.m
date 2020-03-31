function sigtcon3(Lim,Label)
% SIGTCON3  - Creates a graph with lines of constant sigma-t values. 
%           Also creates patches representing North Pacific Water Masses
%			 
% Use as:    sigtcon3
%        or  sigtcon3([Smin Smax Tmin Tmax])
%        or  sigtcon3([Smin Smax Tmin Tmax],Label)
%
% Inputs: Smin and Smax specify the minimum and maximum salinity values 
%         which are the x-axis limits. Tmin and Tmax specify the 
%         temperature range which are the y-axis limits.
%         default = [33 34.6 3 15]
%         Label = sigma-t values which indicate which sigma-t lines to 
%                 be labeled. default = [25 26 27]
%
% Note: SIGTCON simply creates the axes with iso-sigma-t lines and 
%       sets the limits. The plot must be held and overplotted onto.
%         Example:  sigtcon3
%                   hold on
%                   plot(Salinity,Temperature,'r.')
%
% This creates
%
%         See also SIGMAT, DENSITY in the OCEANS toolbox

% Brian Schlining
% 24 NOV 95
% assign09 ms263
% 15 Mar 97 B.S.: modified and functionlaized from sigcon.m in my ms263 archive
% 13 Jun 97 B.S.; modified it to use meshgrid methods
% 23 JUl 97 B.S.; Added limits input and label inputs
% 28 Jul 97 B.S.; Added Units to the axis labels
% 05 May 98 B.S.; Added water mass patches

% Set range values of Temperature and Sigma-t
FontName = 'Courier New';
Tinc = .1;
Sinc = .1;
SigC = [23:.2:29];	% define contour line location
switch nargin
   case 0
      Smin  = 33;
      Smax  = 34.6;
      Tmin  = 3;
      Tmax  = 15;
      Label = [25 26 27];
   case 1 
      Smin  = Lim(1);
      Smax  = Lim(2);
      Tmin  = Lim(3);
      Tmax  = Lim(4);
      Label = [25 26 27];
   case 2
      Smin  = Lim(1);
      Smax  = Lim(2);
      Tmin  = Lim(3);
      Tmax  = Lim(4);
end


% Create matrices of Salinity and Temperature
[Smat, Tmat] = meshgrid(Smin:Sinc:Smax,Tmin:Tinc:Tmax);
% Create a matrix of Sigma-t's
SigT         = sigmat(Smat,Tmat);

% Toggle Hold state of Figure
holdState = get(gca, 'NextPlot');
if strcmp(holdState, 'replace')
   set(gca,'NextPlot','add')
end

% Create Graph
[CS, H] = contour(Smat,Tmat,SigT,SigC);	% need CS and H for CLABEL
set(gca,'Xlim',[Smin Smax],'Ylim',[Tmin Tmax],'Box','on','FontName',FontName)
xlabel('Salinity (psu)','FontName',FontName)
ylabel('Temperature (C)','FontName',FontName)
ch = clabel(CS,H,Label);		% Only label integer lines
set(ch,'FontName',FontName);

% contour creates patch objects, not lines. To change colors set the colormap
map = [.32 .32 .32];
colormap(map)

Color    = [.8 .8 .8]; % Color of the patch

% Pacific Subartic Water
%PSAy = [2 2 10 10 2]
%PSAx = [33.5 34.5 34.5 33.5 33.5];
%patch(PSAx,PSAy,Color)
plot([33.5 34.4],[10 2],'k--')
text(33.8, 4.6,'Subartic')

% Pacific Equatorial Water
%PEWy = [6 6 26 26 6];
%PEWx = [34.5 35.2 35.2 34.5 34.5];
%patch(PSAx,PSAy,Color)
plot([34.5 35.2],[16 6],'k--')
text(34.75,12,'Pac. Eq.')

% Eastern North Pacific Water
%ENPy = [10 10 16 16 10];
%ENPx = [34 34.6 34.6 34 34];
%patch(ENPx, ENPy,Color);
plot([34 34.6],[16 10],'k--')
text(34.2, 12,'E. N. Pac.')

% Pacific Deep Water
plot([34.6 34.7],[-1 -1],'k--')

          



% Return to original hold state
set(gca,'NextPlot',holdState)