function [TimeG, ZG, SpA] = spiceAnomaly1(S, T, Z, Time)
% spiceAnomaly1 - calculate spiciness anomlies in stadard deviations
%                againts sigma-t (NOT pressure)
%
% Use As: [X Y Z] = spiceAnomaly1(S, T, Z, Time)
%
% Inputs: S = Salinity (psu) (Vector-only)
%         T = Temperature (C) (Vector the same size as S)
%         Z = Pressure (dbar) (Vector the same size as S)
%         Time = Time (see DATENUM for format) (Vector the same size as S)
%
% Output: X = Grid of Pressures
%         Y = Grid of Times
%         Z = Grid of spiciness anomalies (standard deviations across 
%             sigma-t surfaces)

% Brian Schlining
% 22 May 2000

% Orient everything correctly
[r c] = size(S);
if r > 1 & c > 1
   error('  Inputs must be vectors not Matrices');
elseif r == 1 & c > 1
   S = S';
end

[r c] = size(T);
if r > 1 & c > 1
   error('  Inputs must be vectors not Matrices');
elseif r == 1 & c > 1
   T = T';
end

[r c] = size(Z);
if r > 1 & c > 1
   error('  Inputs must be vectors not Matrices');
elseif r == 1 & c > 1
   Z = Z';
end

[r c] = size(Time);
if r > 1 & c > 1
   error('  Inputs must be vectors not Matrices');
elseif r == 1 & c > 1
   Time = Time';
end


St = sigmat_(S, T);                                   % Sigmat-T
Th = theta_(S, T, Z);                                 % Potential Temperature
Sp = spice(S, Th, Z);                                 % Spiciness

TimeI = [min(Time):14:max(Time)];                      % Time nodes of grid
StI   = [min(St):0.05:max(St)]';                      % Sigma-T nodes of grid

[TimeG StG] = meshgrid(TimeI, StI);

SpG   = griddata(Time, St, Sp, TimeG, StG, 'linear'); % Gridded spiciness
ZG    = griddata(Time, St, Z, TimeG, StG, 'linear');  % Gridded pressures
[r c] = size(SpG);

SpM   = nanmean(SpG')';                               % Mean spiciness profile
SpS   = nanstd(SpG')';                                % Standard deviation of spiciness profile
SpA   = (SpG - repmat(SpM, 1, c))./ repmat(SpS, 1, c); % Anamoly in standard deviations

TimeG = repmat(TimeI, r, 1);

