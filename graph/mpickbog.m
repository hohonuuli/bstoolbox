function [goodpts,badpts] = mpick(xy)
% MPICKBOG  - Interactively remove points from a vector, returns good and bad points
% function pickpts = mpick(inpoints)
% inpoints is expected to be a 2-column matrix
%  column 1: x coordinates
%  column 2: y
% use right mouse button to store points left to choose.
% Press return to exit

% Gerry hatcher
% 26 Apr 1999 - Modified by Brian Schlining
h      = 0;
button = 0;
OK     = 1;
NextPlotFig = get(gcf,'NextPlot');
NextPlotAxe = get(gca,'NextPlot');
set(gcf,'NextPlot','add');
set(gca,'NextPlot','add');
n = 0;
flag = 0;

while OK 
   [x,y,button] = ginput(1);
   if isempty(button)
      button = -1;
   end
   
   
   switch button
   case 1
      %***********mike 7/12/99-added '*100' correction factor
      % X(time) is on much smaller scale than Y, selection 
      % doesn't function correctly without this.
      d = sqrt(((xy(:,1)-x).^2)*100 + (xy(:,2)-y).^2);
      k = find(d == min(d));
      if h ~= 0
         delete(h);
      end
      h      = plot(xy(k,1),xy(k,2),'go');
      tmppts = xy(k,:); %store the points in case the're it
      tmpind = k;
      flag = 1;
   case 3
		if flag
         n = n + 1;
         pickpts(n,:) = tmppts;
         pickind(n)   = tmpind;
         set(h,'Marker','x','Color',[1 0 0],'MarkerSize',8);
         h = 0;
   	end      
   otherwise
      OK = 0;
   end
end

%this whole section modified by mikeb 6/99
pickind = unique(pickind);
badpts = xy(pickind,:);
goodpts = xy;
goodpts(pickind,:) = [];
%******************************************
set(gcf,'NextPlot',NextPlotFig);
set(gca,'NextPlot',NextPlotAxe);