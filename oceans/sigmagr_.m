function [Sout,Tout,SIGout,aH,lH] = sigmagr_(Tg,Sg,Sig,Tin,Sin,Sym)
% SIGMAGR_  - Construct a T-S Graph with sigma-t isopleths
%
% Use As: aH = sigmagr_(Tg,Sg,Sig,Tin,Sin,Sym)
%
% Input:   Tg(:)  = Temperature range of graph (min,incr,max)
%                      default values 0:2:26
%          Sg(:)  = Salinity range of graph (min,incr,max)
%                    default values 30:1:37 
%          Sig(:) = Sigmat-t isoplets to plot (min:incr:max)
%                    default values 18:1:34
%          Tin    = Input temperature values to plot (optional)
%          Sin    = Input salinity values to plot    (optional)
%          Sym    = Symbol to be used for plotting   (optional)
%      
% Output:  Data Triples to define T-S curves for desired sigma-t values:
%          Sout   = Salinities   (psu)
%          Tout   = Temperatures (C)
%          SIGout = Sigma-t values
%          aH     = handle to the T-S graph axes
%          lH     = handles to the sigma-t lines
%
% Example: load mlml_mb;
%          sigmagr_(5:1:20,32:1:36,18:1:30,MBTemp,MBSalin,'r+')
%
% Note:     To overplot on this graph manually turn HOLD ON
%           Handles to the axes and Sigma-t lines are provided so that
%           these properties may be changed outside of the function.
% See Also: SIGMAT_, DENSITY_
% Ref:      UNESCO Tech Paper Mar Sci 44 (1983) 

%  5 Nov 1995; W. Broenkow
% 20 Sep 1997; W. Broenkow functionalized and adapted from knudnewt.m

if nargin < 3
  Sig = 18:1:34;
end
if nargin < 2
  Sg  = 30:1:37;
end
if nargin < 1
  Tg = 0:2:26;
end

% Search for the following sigma-t isopleths
minSig = min(Sig);
maxSig = max(Sig);
  dSig = diff(Sig(1:2));
  minT =  min(Tg);
  maxT =  max(Tg);
  delT =  diff(Tg(1:2));
   eps = .00001;       % epsilon is the error limit in Sigma-T
 maxit =  5;           % maximum number of guesses

T1  = [];
S1  = [];
Sig = [];
fprintf('Finding Isopleths ')
for SIGMA = minSig:dSig:maxSig
  for T = minT:delT:maxT
    sal1 = SIGMA;               % This make a pretty good first guess
    sal2 = 1.2*SIGMA;           % This makes the second guess even better
    sig1 = knudsen(sal1,T);
    sig2 = knudsen(sal2,T);
    sig3 = 0;                   % a dummy value to get started
      it = 0;
    while (abs(sig3 - SIGMA) > eps) & (it <= maxit)
      sal3 = sal2 + (SIGMA - sig2)*(sal2 - sal1)/(sig2 - sig1);
      sig3 = knudsen(sal3,T);
      sal1 = sal2;
      sig1 = sig2;
      sal2 = sal3;
      sig2 = sig3;
        it = it + 1;
    end
    T1  = [T1 T];               % This was input
    S1  = [S1 sal3];            % This was calculated
    Sig = [Sig SIGMA];  % This was input
%    fprintf('%3i Sig%5.1f T%5.1f Sal%9.4f \n',it,SIGMA,T,sal3);  % show iterations used
  end     % end of Temperature loop
  fprintf('.')
end     % end of SIGMA loop
fprintf('\n')

  Nsig  = (maxSig - minSig)/dSig + 1;
  Ntemp = (maxT - minT)/delT + 1;
  Tout  = reshape(T1,Ntemp,Nsig);
  Sout  = reshape(S1,Ntemp,Nsig);
SIGout  = reshape(Sig,Ntemp,Nsig);

% Plot the Sigmat-t isopleths
lH = plot(Sout,Tout);
axis([min(Sg) max(Sg) min(Tg) max(Tg)])
aH = gca;
set(gca,'YTickMode','manual','Ytick',Tg);
set(gca,'XTickMode','manual','Xtick',Sg); 
xlabel('Salinity')
ylabel('Temperature')

% Label the sigma-t isopleths
for N = 1:Nsig
  % label isopleths across top of graph
  if Sout(Ntemp-1,N) > min(Sg) & Sout(Ntemp-1,N) < max(Sg)
    text(Sout(Ntemp-1,N),Tout(Ntemp-1,N),int2str(SIGout(Ntemp-1,N)), ...
         'VerticalAlignment','middle','HorizontalAlignment','center');
  end
  % label isopleths across bottom of graph
  if Sout(2,N) > min(Sg) & Sout(2,N) < max(Sg)
    text(Sout(2,N),Tout(2,N),int2str(SIGout(2,N)), ...
         'VerticalAlignment','middle','HorizontalAlignment','center');
  end
end

% If data have been included in function call, plot T-S pairs
if exist('Tin') & exist('Sin')
  if exist('Sym') 
    pltSym = Sym;
  else
    pltSym = 'ko';
  end
  hold on
  plot(Sin,Tin,pltSym)
  hold off
end
