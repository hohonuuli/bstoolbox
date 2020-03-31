function chndl = colorbar3(action)
% COLORBAR3 - Interactve colorbar for adjusting colormaps
% 
% This is useful for adjusting colorscales for AVHRR and 
% SeaWiFS images. It always uses a jet colormap

% Brian Schlining
% 17 Aug 1998


global hndl;
btnClrUp  = [1 .6 .6];
btnClrDwn = [ .6  1  .6];

% default is a vertical colorbar
if nargin == 0
   hndl(1) = colorbar2('vert');
   action  = 'initialize';
end

% Setup for horizontal
if strcmp(action,'horiz')
   hndl(1) = colorbar2('horiz');
   action  = 'initialize';
   colorbar3(action);
   
% Setup for vertical
elseif strcmp(action,'vert')
   hndl(1) = colorbar2('vert');
   action  = 'initialize';
   colorbar3(action);
   
% Initalize
elseif strcmp(action,'initialize')
   set(gcf,'CurrentAxes',hndl(1))
   hold('on')
   [sizeMap buf] = size(colormap);
   if isvert(hndl(1))
      Marker = 'k>';
      %X = 1;
      X = 0;
      Y = [1 sizeMap + 1];
   else
      Marker = 'kv';
      X = [1 sizeMap + 1];
      % Y = 1;
      Y = 0;
   end
   hndl(2) = plot(min(X),min(Y),Marker,'MarkerFaceColor',btnClrUp,'ButtonDownFcn',...
      'colorbar3(''AdjustLow'')');
   hndl(3) = plot(max(X),max(Y),Marker,'MarkerFaceColor',btnClrUp,'ButtonDownFcn',...
      'colorbar3(''AdjustHigh'')');
   
% If low maker is selected
elseif strcmp(action,'AdjustLow')
   set(gcf,'WindowButtonUpFcn', 'colorbar3(''buttonupLow'')', ...
      'WindowButtonMotionFcn', 'colorbar3(''setLow'')');
   set(hndl(2),'MarkerFaceColor',btnClrDwn);       %  Turn marker green while selected
   colorbar3('setLow');                          %  Update new marker position
   
% If high marker is selected
elseif strcmp(action,'AdjustHigh')
   set(gcf,'WindowButtonUpFcn', 'colorbar3(''buttonupHigh'')', ...
      'WindowButtonMotionFcn', 'colorbar3(''setHigh'')');
   set(hndl(3),'MarkerFaceColor',btnClrDwn);       %  Turn marker green while selected
   colorbar3('setHigh')                          %  Update new marker position
   
% Set low marker position while selected
elseif strcmp(action,'setLow')   
   pt   = get(gca,'CurrentPoint'); 
   maxX = get(hndl(3),'XData');
   maxY = get(hndl(3),'YData');
   X = pt(1,1);      
   Y = pt(1,2);
   if isvert(hndl(1))                            % Keep marker from free floating
      % X = 1;
      X = 0;
   else
      % Y = 1;
      Y = 0;
   end
   if (isvert(hndl(1)) & Y > maxY)               % Keep marker between bottom of colormap
      Y = maxY - 1;                              % and high marker
   elseif (isvert(hndl(1)) & Y < 1)
      Y = 1;
   elseif (~isvert(hndl(1)) & X > maxX)
      X = maxX - 1;
   elseif (~isvert(hndl(1)) & X < 1);
      X = 1;
   end
   set(hndl(2),'XData',floor(X),'YData',floor(Y),'ButtonDownFcn','colorbar3(''AdjustLow'')');

% Set high marker position while selected
elseif strcmp(action,'setHigh')   
   pt   = get(gca,'CurrentPoint'); 
   minX = get(hndl(2),'XData');
   minY = get(hndl(2),'YData');
   [sizeMap buf] = size(colormap);
   X = pt(1,1);      
   Y = pt(1,2);
   if isvert(hndl(1))                            % Keep marker from free floating
      % X = 1;
      X = 0;
   else
      %Y = 1;
      Y = 0;
   end
   if (isvert(hndl(1)) & Y < minY)               % Keep marker between top of colormap
      Y = minY + 1;                              % and low marker
   elseif (isvert(hndl(1)) & Y > sizeMap)
      Y = sizeMap + 1;
   elseif (~isvert(hndl(1)) & X < minX)
      X = minX + 1;
   elseif (~isvert(hndl(1)) & X > sizeMap)
      X = sizeMap + 1;
   end
   set(hndl(3),'XData',ceil(X),'YData',ceil(Y),'ButtonDownFcn','colorbar3(''AdjustHigh'')');
   
% Turn marker red when released
elseif strcmp(action,'buttonupLow') %  Marker released
   set(gcf,'WindowButtonUpFcn', '','WindowButtonMotionFcn', '');
   set(hndl(2),'MarkerFaceColor',btnClrUp);
   colorbar3('setColor')
   
% Turn marker red whn released
elseif strcmp(action,'buttonupHigh') %  Marker released
   set(gcf,'WindowButtonUpFcn', '','WindowButtonMotionFcn', '');
   set(hndl(3),'MarkerFaceColor',btnClrUp);
   colorbar3('setColor')
   
% Set new colormap range; currently only works with jet 
elseif strcmp(action,'setColor')
   if isvert(hndl(1))
      maxValue = ceil(get(hndl(3),'YData'));
      minValue = floor(get(hndl(2),'YData'));
   else
      maxValue = ceil(get(hndl(3),'XData'));
      minValue = floor(get(hndl(2),'XData'));
   end
   a = zeros(minValue - 1,3);                    % Low end is black
   b = jet(maxValue - minValue);             % selected range is jet
   [sizeMap buf] = size(colormap);
   c = ones(sizeMap - maxValue + 1,3);                   % high end is white
   NewMap = [a;b;c];
   colormap(NewMap)
   
end

% return a handle for programs that need it
if nargout
   chndl = hndl(1);
end


%=============================================================
function i = isvert(hndl)
% ISVERT - Tests to see if colorbar is vertical or horizontal

h = get(hndl,'XTick');
i = isempty(h);


   
   
  