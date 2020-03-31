function [d df p da] = kolsmirtest2(f, g, alpha)
% KOLSMIRTEST2 - 2-sample Kolmogorov-Smirnov test for goodness of fit 
%
% Great for comparing 2 frequency distributions.
%
% Usage:
%   [d df p da] = kolsmirtest2(f, g)
%   [d df p da] = kolsmirtest2(f, g, alpha)
%
% Inputs:
%   f = distribution 1
%   g = distribution 2
%   alpha = alpha level, default is 0.01
%   NOTE: f and g should be 1D vectors of the same length
%
% Outputs:
%   d = The d statistic where, d = max(abs(F - G)), F = cumalitive function
%       of f, G = cumulative function of g.
%   df = degrees of freedom
%   p  = p-value. i.e. the p-value is the probability of obtaining a test statistic at least as 
%        extreme as the one that was actually observed, assuming that the null hypothesis is true.
%        The closer the value to 1 the more likely the 2 distributions match
%   da = critical value

% Brian Schlining
% 2012-04-27

[fr fc] = size(f);
[gr gc] = size(g);
if fr ~= gr & fc ~= gc
    error(' inputs were not the same size');
end

if nargin < 3
   alpha = 0.01; 
end

% Calculate D (i.e. abs(max( f - g)))
fDist = cumsum(f) ./ sum(f);
gDist = cumsum(g) ./ sum(g);

dDist = abs(fDist - gDist);
d = max(dDist);


%% Calc p-vale
n1 = length(f);
n2 = length(g);
p = calcp(d, n1, n2);

df = n1 + n2; % Non-parametric test use n for df instead of (n -1)

% calculate critical value
ka = sqrt((-log(alpha / 2)) / 2);
da = ka * sqrt((n1 + n2) / (n1 * n2));
end

%%
function aa = chisq(x, n)
    % Stole from http://home.ubalt.edu/ntsbarsh/Business-stat/otherapplets/pvalues.htm
    %function ChiSq(x,n) {
    %    if(n==1 & x>1000) {return 0}
    %    if(x>1000 | n>1000) {
    %        var q=ChiSq((x-n)*(x-n)/(2*n),1)/2
    %        if(x>n) {return q} {return 1-q}
    %        }
    %    var p=Math.exp(-0.5*x); if((n%2)==1) { p=p*Math.sqrt(2*x/Pi) }
    %    var k=n; while(k>=2) { p=p*x/k; k=k-2 }
    %    var t=p; var a=n; while(t>0.0000000001*p) { a=a+2; t=t*x/a; p=p+t }
    %    return 1-p
    %    }
    if n == 1 && x > 1000
        aa = 0;
    elseif x > 1000 || n > 1000
        q = chisq((x - n) * (x - n) / (2 * n), 1) / 2;
        if (x > n)
            aa = q;
        else
            aa = 1 - q; 
        end
    else
        p = exp(-0.5 * x);
        if rem(n, 2) == 1
            p = p * sqrt(2 * x / pi);
        end
        k = n;
        while k >= 2
            p = p * x / k;
            k = k - 2;
        end
        t = p;
        a = n;
        while t > (0.0000000001 * p)
            a = a + 2;
            t = t * x / a;
            p = p + t;
        end
        aa = 1 - p;
    end
end

%%
function px = calcp(d, n1, n2)
    % function CalcD(d, n1, n2) {
    %    var chs = (4*d*d*n1*n2)/(n1 +n2);
    %    var px1 = Fmt(ChiSq(chs, 2));
    %    if (px1.indexOf("e") != -1) {
    %        form.px.value = "Almost Zero"; }
    %    else {  
    %        form.pd.value = px1;
    %        }
    %    }
    chs = (4 * d * d * n1 * n2) / (n1 + n2);
    px = chisq(chs, 2);
end