function showjars
% SHOWJARS - DUMPS out the REAL static classpath being used by Matlab

% Brian Schlining
% 2012-05-09

sysloader = java.lang.ClassLoader.getSystemClassLoader()
su = sysloader.getURLs
for i = 1:length(su)
    fprintf(1, '%s\n', char(su(i).toExternalForm));
end