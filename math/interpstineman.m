function yh = interpstineman(x,y,xh)
% INTERPSTINEMAN - Stineman interpolation algorithm
%
% Use As: yi = interpstineman(x,y,xi)
% Inputs: x  = independant variable
%         y  = dependant variable
%         xi = independant variable values to interpolate to (vector)

% Brian Schlining
% 01 Mar 1999

GOOD = find(~isnan(y));
if length(GOOD) < 2
    yh = ones(size(xh)) * NaN;
else
    
    x = x(GOOD);
    y = y(GOOD);
    
    
    n    = length(x);
    
    % compute slope yp(i)
    yp   = zeros(n,1);
    s    = zeros(n,1);
    s(1) = (y(2) - y(1)) / (x(2) - x(1));
    
    % compute slopes
    for i = 2:n-1
        % compute slope of i-th line segment
        s(i) = (y(i+1) - y(i)) / (x(i+1) - x(i));
        
        % compute slope at point y(i)
        d1    = (x(i+1) - x(i)  )^2 + (y(i+1) - y(i)  )^2;
        d2    = (x(i)   - x(i-1))^2 + (y(i)   - y(i-1))^2;
        yp(i) = (d1 * (y(i)  - y(i-1)) + d2 * (y(i+1)- y(i))) / ( d1 * (x(i)  - x(i-1)) + d2 * (x(i+1)- x(i)) );
    end
    
    % compute endpoint slopes
    if (((s(1) > 0) && (s(1) > yp(2))) || ((s(1) < 0) && (s(1) < yp(2))))
        yp(1) = 2*s(1) - yp(2);
    else
        yp(1) = s(1) + (abs(s(1)) * (s(1) - yp(2))) / (abs(s(1)) + abs(s(1) - yp(2)));
    end
    
    if ( ((s(n-1) > 0) && (s(n-1) > yp(n-1))) || ((s(n-1) < 0) && (s(n-1) < yp(n-1))) )
        yp(n) = 2*s(n-1) - yp(n-1);
    else
        yp(n) = s(n-1) + (abs(s(n-1)) * (s(n-1) - yp(n-1))) / (abs(s(n-1)) + abs(s(n-1) - yp(n-1)));
    end
    
    % compute interpolation
    %xh = linspace(x(1),x(n),N);
    N  = length(xh);
    yh = zeros(N,1);
    
    
    for k = 1:N
        z = xh(k);
        
        % find i-th line segment in which z lies
        p = find(x <= z);
        if isempty(p)
            yh(k) = NaN;
        else
            i = p(length(p));
            if i == n
                i = n - 1;
            end
            
            yb = y(i) + s(i) * (z - x(i));
            
            dy1 = y(i)   + yp(i)   * (z - x(i)  ) - yb;
            dy2 = y(i + 1) + yp(i + 1) * (z - x(i + 1)) - yb;
            
            if (dy1*dy2 >= 0)
                yh(k) = yb + (dy1 * dy2) / (dy1 + dy2);
            else
                yh(k) = yb + (dy1 * dy2) / (dy1 - dy2) * 	...
                    (2 * z - x(i) - x(i + 1)) / (x(i + 1) - x(i));
            end
        end
    end
end