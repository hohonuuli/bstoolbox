% HLPDATE_ - Show the essence of all of the time and date conversions. 
% 
% DMS2DEG_ - Convert degrees, minutes, seconds (DD.MMSSss) to decimal equivalent DD.ddd 
%            Note that hour, minutes and seconds is converted to decimal hours 
%            with this function.           
%            decimal_angle = dms2deg_(dms_angle,option,minutes,sec)  
%         
% DEG2DMS_ - Convert decimal degrees to packed forms of DD.MMSS.s or DD.MMmmm  
%            or to separate values of degrees, minutes, seconds. Note that 
%            decimal hours is converted to [H,M,S] using this function. 
%            [D,M,S] = deg2dms_(decimal_angle,option) 
%  
% CALDATE_ - Convert julian date to calendar date in DD.MMYY or Y,M,D formats. 
%            Note that the Julian date starts at noon_, hence the fraction 0.5 in the example.  
%            [YY.MMDD, Y, Mo, D, H, Mn, S] = caldate_(julian_date) 
%  
% JULDATE_ - Converts calendar date (Year, Month, Day) to Julian date.  
%            julian_date = juldate_(year,month,day) 
% 
% JULDAY_  - Determine the julian day of the year (1..365) and day of week  
%            or julian date and day of week  
%            [jday,dow] = julday_(y,m,d,option) 
% 
% JULSEC_  - Return julian seconds from a packed time-date format YYMMDD.HHMMSS 
%            julian_seconds = julsec_(timedate,option) 
% 
% FILDATE_ - Calculate packed file date from julian day of year. 
%            fdate  = fildate_(doy,y) 
% 
% TIMEUPK_ - Unpack time from the YYMMDD.HHMMSS packed form into Y,M,D,H,M,S,DOY,HR 
%            [Year,Month,Day,Hour,Minute,Second,DOY,HR] = timeupk_(TD) 
% 
% NOW_     - Return the system time or user-entered time as YYMMDD.HHmmSS to different formats  
%            formatted_time  = now(option,[year,month,day,hour,minute,second]) 
% 
%            YYMMDD.HHMMSS    0 
%            YY.MMDD          1  
%            DD.MMYY          2 
%            HH.MMSS          3 
%            HH.hhh           4 
%            julian seconds   5 
%            'HH:MM:SS'       6   NOTE this is a string 
%  
% DATE    -  Return the system date as a string 
%            'dd-mmm-yy' = date   
% 
% EXAMPLES 
% Because time and date are stored in many ways, conversion routines are required. 
% 
% juldate_ is basic routine used in these programs.  
% juldate_( 1968, 5, 23.5) -> 2440000    NOTE even julian day number is at noon 
% juldate_(-4712, 1,  0.5) -> 0          Beginning of julian date 
% 
% The Gregorian Calendar changed to the Julian Calendar on 14 Oct 1582 
% juldate(1582,10,14.5)-juldate_(1582,10,15.5) -> 9  Nine Days have been lost to history   
% 
% caldate_ is the inverse and returns day, month year in a packed format 
%         as well as individual variables for year,month,day,hour,minute,second 
% caldate_(2440000)     -> 23.0568,            1968,    5, 23,  12,     0,     0 
%  
% julday_ uses the juldate function in two forms 
% julday_(1968, 5,23  ,0) -> 144         the day of the year or 'julian day' 
% julday_(1968, 5,23.5,0) -> 144.5  
% julday_(1968, 5,23  ,1) -> 2439999.5   the 'julian date' 
% julday_(1968, 5,23.5,1) -> 2440000 
% 
% julsec_ uses juldate to return time in seconds because some time formats 
%        choose to record seconds rather than days. In the MLDBASE  
%        data reduction programs the TIMEDATE value may be stored as a 
%        packed value YYMMDD.hhmmss i.e. year,month,day,hour,minute,second  
% julsec_(680523.120000,0) -> 2.108160000000010e+011 julian seconds 
% julsec_(680523.120000,1) -> 2.440000000000012e+006 julian days
 
% 
% NOW_ returns the system time and performs other time/date formatting 
% now_     -> 960607.14523543  YYMMDD.HHMMSS     the current system timedate 
% now_(1)  -> 96.0620          YY.MMDD           ditto in different formats 
% now_(2)  -> 20.0696          DD.MMYY           ditto 
% now_(3)  -> 14.534233        HH.MMSS           ditto 
% now_(4)  -> 14.89038833333   decimal hour of today 
% now_(5)  -> 53605.39800000   seconds since midnight                  
% now_(6)  -> '15:38:54'       return the clock time as a string
 
% now_(0,[1996,06,10])          -> 960610.000000      reformat entered date 
% now_(0,[1996,06,10,11,22,33]) -> 960610.112233      reformat entered date and time 
% now_(1,[1996,06,10,11,22,33]) -> 96.0610            YY.MMDD some like year month day 
% now_(2,[1996,06,10,11,22,33]) -> 10.0696            DD.MMYY others like day month year  
% now_(3,[1996,06,10,11,22,33]) -> 11.2233            HH.MMSS  
% now_(4,[1996,06,10,11,22,33]) -> 11.91666666666667  decimal hours of the day 
% now_(5)                       -> 2.117009221124511e+011 seconds from julian date 0 
% now_(6)                       -> '15:38:54'         return the entered time as a string 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
 
help hlpdate_
 
