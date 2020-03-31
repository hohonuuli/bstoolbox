function hh = errorbarh(x, y, l,u,symbol)
% ERRORBARH - Horizontal error bar plot.
%   ERRORBARH(X,Y,L,R) plots the graph of vector X vs. vector Y with
%   error bars specified by the vectors L and R.  L and R contain the
%   left and right error ranges for each point in X.  Each error bar
%   is L(i) + R(i) long and is drawn a distance of R(i) right and L(i)
%   left of the points in (X,Y).  The vectors X,Y,L and U must all be
%   the same length.  If X,Y,L and U are matrices then each column
%   produces a separate line.
%
%   ERRORBARH(X,Y,E) or ERRORBARH(X,E) plots X with error bars [X-E X+E].
%   ERRORBARH(...,'LineSpec') uses the color and linestyle specified by
%   the string 'LineSpec'.  See PLOT for possibilities.
%
%   H = ERRORBARH(...) returns a vector of line handles.
%
%   For example,
%      x = 1:10;
%      y = sin(x);
%      e = std(y)*ones(size(x));
%      errorbarh(x,y,e)
%   draws symmetric error bars of unit standard deviation.

%   L. Shure 5-17-88, 10-1-91 B.A. Jones 4-5-93
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 2005/04/13 20:38:33 $

% 17 Jun 1999; Brian Schlining, Converted errorbar to errorbarh 

if min(size(y))==1,
  npt = length(x);
  x = x(:);
  y = y(:);
    if nargin > 2,
        if ~isstr(l),  
            l = l(:);
        end
        if nargin > 3
            if ~isstr(u)
                u = u(:);
            end
        end
    end
else
  [npt,n] = size(x);
end

if nargin == 3
    if ~isstr(l)  
        u = l;
        symbol = '-';
    else
        symbol = l;
        l = y;
        u = y;
        y = x;
        [m,n] = size(y);
        x(:) = (1:npt)'*ones(1,n);;
    end
end

if nargin == 4
    if isstr(u),    
        symbol = u;
        u = l;
    else
        symbol = '-';
    end
end


if nargin == 2
    l = y;
    u = y;
    %y = x;
    [m,n] = size(x);
    y(:) = (1:npt)'*ones(1,n);;
    symbol = '-';
end

u = abs(u);
l = abs(l);
    
if isstr(x) | isstr(y) | isstr(u) | isstr(l)
    error('Arguments must be numeric.')
end

if ~isequal(size(x),size(y)) | ~isequal(size(x),size(l)) | ~isequal(size(x),size(u)),
  error('The sizes of X, Y, L and U must be the same.');
end

%%tee = (max(x(:))-min(x(:)))/100;  % make tee .02 x-distance for error bars
tee = (max(y(:))-min(y(:)))/100;  % make tee .02 x-distance for error bars

yl = y - tee;
yr = y + tee;
xtop = x + u;
xbot = x - l;
n = size(x,2);

% Plot graph and bars
hold_state = ishold;
cax = newplot;
next = lower(get(cax,'NextPlot'));

% build up nan-separated vector for bars
yb = zeros(npt*9,n);
yb(1:9:end,:) = y;
yb(2:9:end,:) = y;
yb(3:9:end,:) = NaN;
yb(4:9:end,:) = yl;
yb(5:9:end,:) = yr;
yb(6:9:end,:) = NaN;
yb(7:9:end,:) = yl;
yb(8:9:end,:) = yr;
yb(9:9:end,:) = NaN;

xb = zeros(npt*9,n);
xb(1:9:end,:) = xtop;
xb(2:9:end,:) = xbot;
xb(3:9:end,:) = NaN;
xb(4:9:end,:) = xtop;
xb(5:9:end,:) = xtop;
xb(6:9:end,:) = NaN;
xb(7:9:end,:) = xbot;
xb(8:9:end,:) = xbot;
xb(9:9:end,:) = NaN;

[ls,col,mark,msg] = colstyle(symbol); if ~isempty(msg), error(msg); end
symbol = [ls mark col]; % Use marker only on data part
esymbol = ['-' col]; % Make sure bars are solid

h = plot(xb,yb,esymbol); hold on
h = [h;plot(x,y,symbol)]; 

if ~hold_state, hold off; end

if nargout>0, hh = h; end
