function sigtcon2(Lim,Label)
% SIGTCON2  - Creates a graph with lines of constant sigma-t values and
%             lines of constant spiciness. 
%			 
% Use as:    sigtcon2
%        or  sigtcon2([Smin Smax Tmin Tmax])
%        or  sigtcon2([Smin Smax Tmin Tmax],Label)
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
%         Example:  sigtcon
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

% Set range values of Temperature and Sigma-t
FontName = 'Courier New';
FontWeight = 'Bold';
Tinc = .1;
Sinc = .1;
SigC = [23:.2:29];	% define contour line location
SpC  = [-2:.2:2];
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
% Create a matrix of spiciness
Sp           = spice(Smat,Tmat);

% Toggle Hold state of Figure
holdState = get(gca, 'NextPlot');
if strcmp(holdState, 'replace')
   set(gca,'NextPlot','add')
end

% Create Graph of Sigma-t
[CS, H] = contour(Smat,Tmat,SigT,SigC);	% need CS and H for CLABEL
set(gca,'Xlim',[Smin Smax],'Ylim',[Tmin Tmax],'Box','on','FontName',FontName)
xlabel('Salinity (psu)','FontName',FontName)
ylabel('Temperature (C)','FontName',FontName)
ch = clabel(CS,H,Label);		% Only label integer lines
set(ch,'FontName',FontName);

hold on
% Add spiciness lines
[CSp, Hsp] = contour(Smat,Tmat,Sp,SpC);	% need CS and H for CLABEL
ch = clabel(CSp,Hsp,[-1:1:1]);
set(ch,'FontName',FontName,'FontWeight',FontWeight)


% contour creates patch objects, not lines. To change colors set the colormap
map = [.32 .32 .32];
colormap(map)

% Return to original hold state
set(gca,'NextPlot',holdState)