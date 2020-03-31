function aspect(axesHandle)
% changes the current projection to an approximately x,y grid

if ~nargin
   window = gca;
else
   window = axesHandle;
end

window = axis;
horz   = [mean(window(3:4)) mean(window(3:4)); window(1) window(2)];
vert   = [window(3) window(4); mean(window(1:2)) mean(window(1:2))];
DX     = dist(horz(1,:),horz(2,:));
DY     = dist(vert(1,:),vert(2,:));
dx     = DX/diff(window(1:2));
dy     = DY/diff(window(3:4));


%set(gca,'aspect',[NaN dy/dx]);
set(gca,'DataAspectRatio',[1 dx/dy 1]);
