function yyy = dms2deg_(in_angle,option,minutes,seconds) 
% DMS2DEG_ - Convert degrees, minutes, seconds (DD.MMSSss) to  
%            decimal equivalent DD.ddd 
% 
% Use As:   out_angle = dms2deg_(in_angle,option,minutes,seconds) 
% 
% Input:    in_angle  = angle in the form DD.MMSS or HH.MMSS 
%           option    = 0 for inputs of  DD.MMm 
%           option    = 1 for inputs of  DD.MMSSs 
%           option    = 2 for inputs of  DD, MM.m 
%           option    = 3 for inputs of  DD, MM,  SS.s 
%           minutes   for option 2 is decimal minutes 
%                         option 3 is whole minutes 
%           seconds   for option 3 is decimal seconds  
% Output:   out_angle = Angle or Time as decimal fraction 
%   
% Example:  dms2deg_( 36.59599,0)           ->  36.99331  DD.ddddd 
%           dms2deg_(-36.59599,1)           -> -36.99997  DD.ddddd 
%           dms2deg_(-36,      2, 59.599)   -> -36.99 
%           dms2deg_(-36,      3, 59, 59.9) -> -36.999972  
% 
% Note:     When using option = 2 or option = 3; the absolute value of the 
%           minutes and seconds are used. 
%           A warning message is issued if minutes or seconds > 60. 
% 
% See Also: DEG2DMS_
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% adapted from DTO_DEG.FOR 
% Notice the addition of a small angle to foil truncation errors 
% 22 Jan 96; W. Broenkow 
% 25 Mar 96; W. Broenkow vectorized 
%  7 Apr 96; W. Broenkow added DD MM SS.s modes 
% 23 May 96; W. Broenkow debugged negative inputs 
% 17 Jun 96; W. Broenkow changed form to option, min to minutes
 
if nargin == 1 
  option = 0;                   % default DD.MMmm 
end 
 
if (option == 0)                % from DD.MMmmm to DD.dddd 
  P1 = in_angle + sign(in_angle)*2e-14; 
  P2 = fix(P1);               % degrees (hours) 
  P3 = P1 - P2;               % .minutes 
  P4 = 100.*P3;               % minutes             
  if any(P4 > 60.0) 
    disp('DMS2DEG_ BAD PARAMETER Minutes > 60') 
  end 
  yyy = P2 + P4/60.0;        
  return 
elseif (option == 1)            % from DD.MMSSs to DD.dddd 
  P1 = in_angle + sign(in_angle)*2e-14; 
  P2 = fix(P1);               % degrees (hours) replace aint w/ fix 
  P3 = (P1 - P2);             % .minutesseconds 
  P4 = 100*P3;                % minutes.seconds 
  P5 = fix(P4);               % minutes 
  P6 = P4 - P5;               % .seconds 
  P7 = 100*P6;                % seconds  
elseif (option == 2) 
  if nargin < 3 
    disp('DMS2DEG_ requires input argument for minutes') 
    disp('i.e. dms2deg_(D,2,M)') 
    return 
  end 
  P2 = in_angle; 
  P5 = abs(minutes)*sign(P2); 
  P7 = 0; 
elseif (option == 3) 
  if nargin < 4 
    disp('DMS2DEG_ requires input arguments for minutes and seconds') 
    disp('i.e.  dms2deg_(D,3,M,S)') 
    return 
  end 
  P2 = in_angle; 
  P5 = abs(minutes)*sign(P2); 
  P7 = abs(seconds)*sign(P2); 
end 
if any((abs(P5) >= 60.0) | (abs(P7) > 60.0)) 
  disp('DMS2DEG_  BAD PARAMETER minutes > 59 or seconds > 60') 
end 
 
  yyy = P2 + P5./60.0 + P7./3600.0; 
