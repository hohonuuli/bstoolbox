function qqgraph(y, y0, pvec)
% QQGRAPH - quantile-quantile plot

% Brian Schlining
% 2012-06-07

 % plot one sample against another
 if size(x,1)==1
    x = x';
end
if size(y,1)==1
    y = y';
end
n = -1;

if nargin < 3
        % find interpolation points using smaller sample, if none given
        nx = sum(~isnan(x));
        if (length(nx) > 1)
            nx = max(nx);
        end
        ny = sum(~isnan(y));
        if (length(ny) > 1)
            ny = max(ny);
        end
        n = min(nx, ny);
        pvec = 100*((1:n) - 0.5) ./ n;
    end
    if size(x,1)==n
        xx = zeros(size(x));
        origindx = zeros(size(x));
        nancols = find(any(isnan(x),1));
        fullcols = find(all(~isnan(x),1));
        [xx(:,fullcols),origindx(:,fullcols)] = sort(x(:,fullcols));
        xx(:,nancols) = quantile(x(:,nancols),pvec);
        if size(x,2)==1 && size(y,2)~=1
            origindx = repmat(origindx,1,size(y,2));
        end

    else
        xx = prctile(x,pvec);
        origindx = [];
    end
    if size(y,1)==n
        yy = zeros(size(y));
        origindy = zeros(size(y));
        nancols = find(any(isnan(y),1));
        fullcols = find(all(~isnan(y),1));
        [yy(:,fullcols),origindy(:,fullcols)] = sort(y(:,fullcols));
        yy(:,nancols) = quantile(y(:,nancols),pvec);
        if size(y,2)==1 && size(x,2)~=1
            origindy = repmat(origindy,1,size(x,2));
        end
    else
        yy = prctile(y,pvec);
        origindy = [];
    end


q1x = quantile(x,25);
q3x = quantile(x,75);
q1y = quantile(y,25);
q3y = quantile(y,75);
qx = [q1x; q3x];
qy = [q1y; q3y];


dx = q3x - q1x;
dy = q3y - q1y;
slope = dy./dx;
centerx = (q1x + q3x)/2;
centery = (q1y + q3y)/2;
maxx = max(x);
minx = min(x);
maxy = centery + slope.*(maxx - centerx);
miny = centery - slope.*(centerx - minx);

mx = [minx; maxx];
my = [miny; maxy];


newplot();
hrefends = line(mx,my,'LineStyle','-.','Marker','none');
hrefmid = line(qx,qy,'LineStyle','-','Marker','none');
hdat = line(xx,yy,'LineStyle','none','Marker','+');
if length(hdat)==1
    set(hdat,'MarkerEdgeColor','b');
    set([hrefends,hrefmid],'Color','r');
end
if nargout>0
    h = [hdat;hrefmid;hrefends];
end

% xlabel(xlab);
% ylabel(ylab);
% title (tlab);