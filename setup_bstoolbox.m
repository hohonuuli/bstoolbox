function setup_bstoolbox

home = fileparts(which(mfilename));
tbs = {'biology', 'common', 'graph', 'images', 'io', 'map', 'math', 'oceans', ...
    'physics', 'sql', 'statplots', 'strings', 'time'};
for t = tbs
    addpath(fullfile(home, t{:}));
end
addjars(fullfile(home, 'java'))

% Check if we have a license for the stats toolbox
if (license('test', 'statistics_toolbox')) 
    addpath(fullfile(home, 'stats'));
else
    addpath(fullfile(home, 'stats_noclobber'));
end
disp('Added Brian Schlining''s toolbox to Matlab path');

