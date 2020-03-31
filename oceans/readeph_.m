 function [Edat,Epoch, Xdat] = readeph_(fname,option)
%  READEPH_  - Read NASA/NORAD 2-line satellite ephemeris
%
% Use As:  [Edat,Epoch,Xdat]  = readeph_(fname,option)
% Input:   fname      = file name
%          option:  1 = print ephemeris elements
%                   0 = do not
% Output:  Eldat =  6 orbital elements:
%                   (1) Semi-major axis (km)
%                   (2) Eccentricity
%                   (3) Inclination (deg)
%                   (4) Longitude of ascending node (deg)
%                   (5) Argument of perigee (deg)
%                   (6) Mean anomaly (deg)
%          Epoch = GMT time when the ephemeris was valid:
%                   (1) Day of Month
%                   (2) Month
%                   (3) Year
%                   (4) Hour
%                   (5) Minute
%                   (6) Second
%          Xdat  = 23 element array containing all numerical codes
%                   in the NASA and NORAD format
%
% Example: [Edat,Epoch,Xdat] = readeph_('seawifs.dat',1);
%
%   Epoch Year                      97 
%   Epoch JulDay          268.14577487 
%   Inclination                98.2168 
%   Long Ascending Node         5.2771 
%   Eccentricity            0.00019580 
%   Argument of Perigee       140.9210 
%   Mean Anomaly               19.2129 
%   Mean Motion            14.55481227 
%   Period hours            1.64893917 
%   Satellite Height            707.80 
%   Revolution #                   816 
 
if nargin > 1
 option = 1;
end
fid = fopen(fname,'r');
N = 0;
while 1
  line = fgetl(fid);
  if ~isstr(line)
    break
  end
  N = N + 1;
  dat(N,:) = line;
end
fclose(fid);

Xdat(1)  = str2num(dat(1,1:1));     % line number
Xdat(2)  = str2num(dat(1,3:7));     % satellite number
Xdat(3)  = str2num(dat(1,10:11));   % international designator year
Xdat(4)  = str2num(dat(1,12:14));   % international designator launch number
Xdat(5)  = str2num(dat(1,19:20));   % epoch year    
Xdat(6)  = str2num(dat(1,21:32));   % epoch julian day
Xdat(7)  = str2num(dat(1,34:43));   % ballistic coefficient 1st deriv mean motion
Xdat(9)  = str2num(dat(1,45:52));   % 2nd deriv mean motion
Xdat(10) = str2num(dat(1,54:61));   % BSTAR drag or radiation pressure
Xdat(11) = str2num(dat(1,63:63));   % Ephemeris type
Xdat(12) = str2num(dat(1,65:68));   % Element number
Xdat(13) = str2num(dat(1,69:69));   % check sum line 1
Xdat(14) = str2num(dat(2,1:1));     % line number
Xdat(15) = str2num(dat(2,3:7));     % satellite number
Xdat(16) = str2num(dat(2,9:16));    % INCLINATION (deg)
Xdat(17) = str2num(dat(2,18:25));   % RIGHT ASCENSION OF ASCENDING NODE (deg)
Xdat(18) = 1e-7*str2num(dat(2,27:33));  % ECCENTRICITY
Xdat(19) = str2num(dat(2,35:42));   % ARGUMENT OF PERIGEE (deg)
Xdat(20) = str2num(dat(2,45:51));   % MEAN ANOMALY (deg)
Xdat(21) = str2num(dat(2,53:63));   % MEAN MOTION (rev/day)
Xdat(22) = str2num(dat(2,64:68));   % REVOLUTION at epoch
Xdat(23) = str2num(dat(2,69:69));   % check sum line 2

T       = 86400/Xdat(21);          % period in seconds      I WONDER IF WE SHOULD USE SIDERIAL DAY              % period in seconds
Edat(1) = 21.6135022*exp((2/3)*log(T));  % Semimajor Axis I'll bet you cannot figure out where 
Edat(2) = Xdat(18);                % Eccentricity         this magic number comes from
Edat(3) = Xdat(16);                % Inclination 
Edat(4) = Xdat(17);                % Long of Ascend Node
Edat(5) = Xdat(19);                % Argument of Perigee
Edat(6) = Xdat(20);                % Mean Anomaly

Jd      = floor(Xdat(6));
fday    = Xdat(6) - Jd;
tsec    = fday*86400;
hr      = floor(tsec/3600);
mn      = floor((tsec - hr*3600)/60);
sc      = tsec - 3600*hr - 60*mn;
YEAR    = (Xdat(5)>60)*(1900+Xdat(5) + (Xdat(5)<=60)*(1900+Xdat(5)));

[date,y,mo,d] = caldate_(Jd,YEAR);
Epoch(1:6) = [d mo YEAR hr mn sc];

if option == 1
  fprintf('Epoch Year          %14.0f \n',Xdat(5))
  fprintf('Epoch JulDay        %14.8f \n',Xdat(6))
  fprintf('Inclination         %14.4f \n',Xdat(16))
  fprintf('Long Ascending Node %14.4f \n',Xdat(17))
  fprintf('Eccentricity        %14.8f \n',Xdat(18))
  fprintf('Argument of Perigee %14.4f \n',Xdat(19))
  fprintf('Mean Anomaly        %14.4f \n',Xdat(20))
  fprintf('Mean Motion         %14.8f \n',Xdat(21))
  fprintf('Period hours        %14.8f \n',T/3600)
  fprintf('Satellite Height    %14.2f \n',Edat(1) - 6378.13)
  fprintf('Revolution #        %14.0f \n',Xdat(22))
end