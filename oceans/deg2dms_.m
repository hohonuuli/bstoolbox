function [D,M,S] = deg2dms_(in_angle, option) 
% DEG2DMS_ - Convert decimal degrees to packed forms of DD.MMSS.s or DD.MMmmm  
%            or to separate values of degrees, minutes, seconds  
% 
% Use As:   [D,M,S] = deg2dms_(in_angle,option) 
% 
% Input:    in_angle = angle in decimal degrees or hours 
%           option specifies the number of output arguments    
%           option = 0 returns DD.MMmmm       1    "      " 
%           option = 1 returns DD.MMSSsss     1 output argument
 
%           option = 2 returns [DD MM.mmm]    2    "      " 
%           option = 3 returns [DD MM SS.sss] 3    "      " 
% 
% Output:   D  =  option = 0 or option = 1, degrees 
%           M  =  option = 2, fractional min; option = 3, whole min  
%           S  =  option = 3, fractional sec 
% 
% Example:  deg2dms_(-36.99999,0) -> [-36.357594 0       0   ] DD.MMmmmm 0 0 
%           deg2dms_(+36.99999,1) -> [ 36.354556 0       0   ] DD.MMSSss 0 0 
%           deg2dms_(+36.59599,2) -> [ 36        35.759  0.0 ] DD MM.mmm 0 
%           deg2dms_(-36.59599,3) -> [-36        35      45.6] DD MM SS.s 
% 
% Note:     M (minutes) and S (seconds) returned for option = 2 or option = 3 
%           are absolute values. The sign of the argument is contained in D. 
% 
% See Also: DMS2DEG_
  
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 22 Jan 96; W. Broenkow taken from DTO_DMS.FOR 
% 25 Mar 96; W. Broenkow vectorized 
%  6 Apr 96; W. Broenkow added Min and Sec output 
% 23 May 96; W. Broenkow debugged 
%  7 Jun 96; WWB fixed rounding problems that produced 36.60  DD.MMm or -36.596000 DD.MMSSs 
% 20 Jun 96; changed name WWB 
%  3 Aug 96; fixed annotation option 0 and option 1 were wrong 
% 10 Nov 2000; B. Schlining changed option to reflect nargout
 
   
if nargin == 1 
  option = nargout; 
end 
                           
P1 = in_angle; 
P2 = fix(P1) ;        % degrees (hours) 
P3 = P1 - P2 ;        % .degrees 
P4 = 60.*P3  ;        % MM.mmmmm 
P5 = fix(P4) ;        % minutes 
P6 = P4 - P5 ;        % .minutes 
P7 = 60.*P6  ;        % SS.sssss 
 
if (option == 0) 
  D = P2 + P4./100.0;                   % DD.MMmmm 
  if abs(P4./100) >= .5999999999        % good only to .000001 min 
      D = P2 + sign(P2)*.5999999999;            % avoid HH.6000000 
  end 
  M = 0; 
  S = 0; 
elseif (option == 1) 
  D = P2 + P5./100.0 + P7./10000.0;     % DD.MMSSsss 
  if abs(P7./100) >= .5999999999        % good only to .000001 sec 
      D = P2 +P5./100.0+ sign(P2)*.005999999999;  % avoid HH.MM60000 
  end 
  M = 0; 
  S = 0; 
elseif (option == 2) 
  D = P2; 
  M = abs(P4); 
  S = 0; 
elseif (option > 2) 
  D = P2; 
  M = abs(P5); 
  S = abs(P7); 
end 
