function c = database(url, user, password, driverName)
% DATABASE - connect to a SQL database
%
% Usage:
%   c = database(url, user, password, driverName)
% 
% Inputs:
%   url = The database URL. e.g. jdbc:jtds:sqlserver://solstice.shore.mbari.org:1433/EXPD
%   user = The user name to connect to the database
%   password = THe password for user
%   driverName = the name of the JDBC driver to use for the connection. 
%       e.g. 'net.sourceforge.jtds.jdbc.Driver' (optional)
%
% Outputs
%   c = A java.sql.Connection object to your database. Remember to call
%   close, either as 'close(c)' or c.close() when you are done with the 
%   connection.
%
% NOTES: In order to connect to a database, you will need the appropriate
% JDBC driver on the classpath. Most drivers do not work on Matlab's dynamic
% classpath. Instead add them to ~/.matlab/R2014b/javaclasspath.txt

% Brian Schlining
% 2014-10-08

if nargin == 4
    d = eval(driverName);
end
c = java.sql.DriverManager.getConnection(url, user, password);