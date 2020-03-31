function [xo, yo] = showdate(X,Y)
% SHOWDATE    - Get the values of selected pts off of a graph
% 
% Use as: [xo, yo] = showdate(xi, yi);
%
% Inputs: xi = A vector of the x-coordinates
%         yi = A vector of the y-coordinates
% 
% Output: xo = x values selected
%         yo = y values selected
%  
% Details: The left mouse button selects a point, to store a pt 
%  use the right mouse button. Press enter to exit.

% Brian Schlining
% 01 Sep 1999 

[rx cx] = size(X);
[ry cy] = size(Y);
if (rx > 1 & cx > 1)
   error('  GETPTS: Input X can not be a matrix')
end
if (ry > 1 & cy > 1)
   error('  GETPTS: Input Y can not be a matrix') 
end
if (ry ~= rx) | (cy ~= cx)
   error('  GETPTS: Input X and Y must be teh same size')
end
if rx > 1
   xy = [X Y];
else
   xy = [X;Y]';
end


h      = 0;
tH     = 0;
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
      d = sqrt((xy(:,1)-x).^2 + (xy(:,2)-y).^2);
      k = find(d == min(d));
      if h ~= 0
         delete(h);
      end
      if tH ~= 0
         delete(tH)
      end
      
      h      = plot(xy(k,1),xy(k,2),'go');
      tH     = text(xy(k,1),xy(k,2),datestr(xy(k,1)));
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
         tH = 0;
      end
   otherwise
      OK = 0;
   end
end

xo = xy(pickind,1);
yo = xy(pickind,2);
%Good = find(~isnan(xy(:,1)));

%goodpts = xy(Good,:);


set(gcf,'NextPlot',NextPlotFig);
set(gca,'NextPlot',NextPlotAxe);