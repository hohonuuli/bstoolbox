function s = jdbcquery(conn, sqlstr)
% Connect to database, execute SQL string, and pass back structure array.
%
% Usage:
%   s = jdbcquery(conn, sqlstr)
% 
% Input   
%   conn: A java.sql.Connection object. See Also database
%   sqlstr: SQL string, i.e. 'SELECT * FROM Observation WHERE ConceptName LIKE ''Pandalus%'''
%
% Output  
%   s: structure array, each field matches the column names in the query.
%
% Note: 
%   The Java class path to the sqljdbc driver must be specified before call.
%   For best results put it in your ~/.matlab/R2014b/javaclasspath.txt file.  
%   This path will vary depending on your Matlab version.
%   
% See also database

% Brian Schlining
% 2014-10-08 - Modified Reiko's version used for EXPD queries

%% Java Imports
import java.sql.ResultSet;

cal = java.util.Calendar.getInstance();
cal.setTimeZone(java.util.TimeZone.getTimeZone('UTC'));

%% Fetch Loop
try    
    % query database
    q = conn.prepareStatement(sqlstr, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
    rs = q.executeQuery();

    metaData = rs.getMetaData();
    columnCount = metaData.getColumnCount();
    n = resultSetSize(rs);
    s = initStruct(metaData, n);
    
    row = 0; 
    % assign variables from resultset
    while rs.next()
        row = row + 1;
        for i = 1:columnCount
            coltype = char(metaData.getColumnTypeName(i));      % assess the column type
            colName = char(metaData.getColumnName(i));
            switch coltype
                case {'bigint', 'int', 'int4', 'decimal', 'double', 'float',  ...
                        'float8', 'float16', 'numeric', 'real', 'serial'}
                    s.(colName)(row) = toDouble(rs.getObject(i));
                case {'date'}
                    s.(colName)(row) = toDate(rs.getDate(i, cal));
                case {'datetime'}
                    s.(colName)(row) = toDate(rs.getTimestamp(i, cal));
                case {'geometry'}
                    s.(colName){row} = rs.getObject(i);
                otherwise % value is a string, so just pass it into the output array
                    s.(colName){row} = toString(rs.getString(i));
            end
        end
    end 

    % close all database connections
    try 
        q.close();     
    catch
        % DO NOTHING ON EXCEPTION
    end
    try 
        rs.close();     
    catch
        % DO NOTHING ON EXCEPTION
    end

catch me
    ex = MException('JDBC:jdbcquery', ['An error occurred while executing the SQL: \n' sqlstr ]);
    ex = ex.addCause(me);
    ex.throw;
end
end


%%
function s = resultSetSize(resultSet)
    ok = resultSet.last();
    if ~ok
        s = 0;
    else
        s = resultSet.getRow();
        resultSet.beforeFirst();
    end
end

%%
function s = initStruct(metaData, rows)
    for i = 1:metaData.getColumnCount()
       colType = char(metaData.getColumnTypeName(i));
       colName = char(metaData.getColumnName(i));
       switch char(colType)
           case {'bigint', 'int', 'int4', 'decimal', 'double', 'float',  ...
                    'float8', 'float16', 'numeric', 'real', 'serial' 'date', 'datetime'}
               s.(colName) = ones(rows, 1);
           otherwise
               s.(colName) = cell(rows, 1);
       end
    end
end

%%
function v = toDouble(n)
    if isempty(n)
        v = NaN;
    else
        v = double(n);
    end
end

%%
function v = toDate(n)
    if isempty(n)
        v = NaN;
    else
        %datenum('01 Jan 1970 00:00:00') = 719529
        v = n.getTime() / 1000 / 60 / 60 / 24 + 719529;
    end
end

%%
function v = toString(n)
    if isempty(n)
        v = '';
    else
        v = char(n);
    end
end





