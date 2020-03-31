function [Population, Time] = populat3(No, r, N, K)
% POPULAT3  - Logistic exponential growth curve model
%
% This is a very simply growth model. The Time to go from No to N is given
% in T(100)
% 
% Use as: [Population,Time] = populat3(No,r,N,K)
%
% Inputs: No = initial Population
%         r  = Growth rate
%         N  = Ending Population
%         K  = Maximal Value of N 
%         WARNING: beware if N is equal to or greater than K!!
%
% Output: Population = Population at time steps given by the vector Time
%         Time       = Time vector for plotting Population vs Time. It has the same time 
%                      unit as r.
%
%
% Example: populat3(1,.02,30,30);
% Brian Schlining
% 27 Jan 97

a    = log(K/No - 1);			% calculate constant of integration defining origin of curve
Time = (a - log(K/N - 1))/r;		% Calculate the time to reach N
Time = linspace(0,Time,100);		% Convert Time to a vector with a hundred points for graphing
a    = a.*finite(Time);			% Convert a to a vector the same length as Time


Population = K./(1 + exp(a - r.*Time));	% Calculate the population

% Plot the graph
plot(Time,Population)

% Toggle Hold state of Figure
holdState = get(gca, 'NextPlot');
if strcmp(holdState, 'replace')
   set(gca,'NextPlot','add')
end

% Plot the Time to reach N
maxTime = num2str(Time(100));
plot(Time(100),Population(100),'ro')
text(Time(100), Population(100), maxTime,'HorizontalAlignment','right');

% Return to original hold state
set(gca,'NextPlot',holdState)

