function [Population,Time] = populat2(No,r,N)
% POPULAT2  - Simply growth curve model
%
% This is a very simply growth model. The Time to go from No to N is given
% in T(100)
% 
% Use as: [Population,Time] = populat2(No,r,N)
%
% Inputs: No = initial Population
%         r  = Growth rate
%         N  = Ending Population
%
% Output: Population = Population at time steps given by the vector Time
%         Time       = Time vector for plotting Population vs Time. It has the same time 
%                      unit as r.
%
%
% Example: populat2(1,.02,3);

% Brian Schlining
% 23 Jan 97 -  A much improved version of Populate

Time       = log(N/No)/r;		% Calculate the time to reach N
Time       = linspace(0,Time,100);	% Generate 100 pt vector from 0 to time to reach N
Population = No.*exp(r.*Time);	% Calculate Population at each time

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
