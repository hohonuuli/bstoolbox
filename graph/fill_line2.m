function vec = fill_line2(X,Y)
% FILL_LINE2 - Creates a pretty filled line for anomaly plots
% Use As: fill_line2(X,Y)

% Todd Anderson
% 03 Mar 1999; Brian Schlining; modified input arguments
[rx cx] = size(X);
[ry cy] = size(Y);

if rx > cx
   X = X';
end
if ry > cy
   Y = Y';
end

vec = [X;Y];

plot(vec(1,:),vec(2,:))
hold on;
% fill in area under the positive values of a curve with a color
i = 1;
k = 1;
while i <= length(vec),
 if vec(2,i) >= 0, % look for positive values only to fill in under
% add point to drop down fill color to x-axis at start
  if vec(2,i) > 0 & i == 1,
   k       = 1;
   poly(k) = 0;
   x2(k)   = vec(1,i);
   k       = 2;
   poly(k) = vec(2,1);
   x2(k)   = vec(1,i);
   i       = i + 1;
  elseif vec(i) == 0, 
   k       = 1;
   poly(k) = 0;
   x2(k)   = vec(1,i);
   i       = i + 1;
  elseif vec(2,i) > 0 & i >= 2,
   k       = 1;
   m       = (vec(2,i) - vec(2,i-1))/(vec(1,i) - vec(1,i-1));
   b       = vec(2,i-1) - m*vec(1,i-1);
   poly(k) = 0;
   x2(k)   = -b/m;
  end

  while vec(2,i) >= 0 & i <= length(vec),
   k       = k + 1; 
   poly(k) = vec(2,i);
   x2(k)   = vec(1,i);
   if i == length(vec),
    break;
   else
    i      = i + 1;
   end
  end

  if i == length(vec) & vec(2,i) > 0,
   k       = k + 1;
   poly(k) = 0;
   x2(k)   = vec(1,i);   
  else
   m       = (vec(2,i) - vec(2,i-1))/(vec(1,i) - vec(1,i-1));
   b       = vec(2,i-1) - m*vec(1,i-1);
   poly(k + 1) = 0;
   x2(k + 1)   = -b/m;
  end

%  poly(k + 1) = 0;
  fill(x2,poly,'r');
  poly = zeros(size(poly));
  x2   = zeros(size(x2));
%  pause;
 end
 i = i + 1;
end

% now fill in the negative values of the curve
i = 1;
while i <= length(vec),
 if vec(2,i) <= 0,
  if vec(2,i) < 0 & i == 1,
   k = 1;
   poly(k) = 0;
   x2(k) = vec(1,1);
   k = 2;
   poly(k) = vec(2,1);
   x2(k) = vec(1,1);
   i = i + 1;
  elseif vec(2,i) == 0, 
   k = 1;
   poly(k) = 0;
   x2(k) = vec(1,i);
   i = i + 1;
  elseif vec(2,i) < 0 & i >= 2,
   k = 1;
   m = (vec(2,i) - vec(2,i-1))/(vec(1,i) - vec(1,i-1));
   b = vec(2,i-1) - m*vec(1,i-1);
   poly(k) = 0;
   x2(k) = -b/m;
  end

  while vec(2,i) <= 0 & i <= length(vec),
   k = k + 1; 
   poly(k) = vec(2,i);
   x2(k) = vec(1,i);
   if i == length(vec),
    break;
   else
    i = i + 1;
   end
  end

  if i == length(vec) & vec(2,i) < 0,
   k = k + 1;
   poly(k) = 0;
   x2(k) = vec(1,i);   
  else
   m = (vec(2,i) - vec(2,i-1))/(vec(1,i) - vec(1,i-1));
   b = vec(2,i-1) - m*vec(1,i-1);
   poly(k + 1) = 0;
   x2(k + 1) = -b/m;
  end

  if vec(2,i) > 0,
   m = (vec(2,i) - vec(2,i-1))/(vec(1,i) - vec(1,i-1));
   b = vec(2,i-1) - m*vec(1,i-1);
   poly(k + 1) = 0;
   x2(k + 1) = -b/m;
  end

%  poly(k + 1) = 0;
  fill(x2,poly,'b');
%  x2
%  poly
  poly = zeros(size(poly));
  x2 = zeros(size(x2));
%  x2
%  poly
%  pause;
 end
 i = i + 1;
end
plot(vec(1,:),vec(2,:))
set(gca,'XLim',[min(X) max(X)])
hold off;
