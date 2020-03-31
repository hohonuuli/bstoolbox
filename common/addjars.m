function addjars(jarDir)
% ADDJARS - add a directory of java jar files to matlab's classpath. 
%
% Usage:
%   addjars(jarDir)
%
% Inputs:
%   jarDir = a Directory name or path

javaaddpath(jarDir);

d = dir(jarDir);
for i = 1:length(d)
    name = java.lang.String(d(i).name);
    if name.endsWith('.jar') & ~name.startsWith('.')
        javaaddpath(fullfile(jarDir, d(i).name));
    end
end