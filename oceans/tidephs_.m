function [CorrAmpl,LocalPhase,AmplIndex,P] = tidephs_(YEAR,ZONE) 
% TIDEPHS_ - Calculates local phase lags for the NOAA 37 constituents 
%  
% Use As:    [CorrAmpl,LocalPhase,AmplIndex] = tidephs_(YEAR,ZONE) 
% Input Variables:   YEAR   = Year for which phases are calculated 
%                    ZONE   = Time Zone 
% Input through TIDEGLBL: 
%                    msl    = Mean Sea Level 
%                    ampl   = Constituent amplitudes 
%                    kappa  = Constituent phase lags 
%                    speeds = Constituent speed numbers 
% Output Variables:  CorrAmpl   = Corrected Amplitudes 
%                    LocalPhase = Local Phase 
%                    AmplIndex  = Indexes into constituents sorted by magnitude 
%                    P()        = Nodal factors, which are not used by MLTIDE 
% 
% NOTE: These Variables are also output through TIDEGLBL 
% 
% Use As:   [CorrAmpl,LocalPhase,AmplIndex] = tidephs_(YEAR,ZONE) 
% See Also: MLTIDE, TIDECST_
% Ref:      P. Schureman.
 
% 19 Oct 1996; W. Broenkow edited VAX FORTRAN program MLMLTIDE.FOR 
% 27 Oct 1996; W. Broenkow checks with HPL PLOTtide 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
 
global tidenames speeds msl ampl kappa  
global STN_NAME STN_NUMBER STN_LENGTH STN_YEAR  
global NUM_CONST LATITUDE LONGITUDE AMP_MULT 
 
% DO NOT use YEAR and ZONE globally if you want to pass them 
% through a subroutine call. 
 
a = str2mat('J1','K1','K2','L2','M1','M2','M3','M4'); 
b = str2mat('M6','M8','N2','2N2','O1','OO1','P1','Q1'); 
c = str2mat('2Q1','R2','S1','S2','S4','S6','T2','lmbda2'); 
d = str2mat('mu2','nu2','rho1','MK3','2MK3','MN4','MS4','2SM6'); 
e = str2mat('Mf','MSf','Mm','Sa','Ssa'); 
tidenames = str2mat(a,b,c,d,e); 
 
% The following are the mean rates: deg/mean solar hour Schureman p 163 
%  
t = 15.00000000;   % Mean Solar Day 
s =  0.54901653;   % tropical month 
h =  0.04106864;   % tropical year 
p =  0.00461483;   % revolution of lunar perigee 
 
% 7 Dec 1996 noted possible errors in L2, M1 
%      formula             Formula      Table 2 Schureman   MLTIDE.FOR 
% L2 = 2t - 1s + 2h - 1p = 29.5285059   29.5284789          29.5284789 
% M1 = 1t - 1s + 1h      = 14.4920521   14.4920521          14.4966939 
% kept both original values for L2 and M1 
 
speeds =  [15.5854433,  15.0410686, 30.0821373, 29.5284789, ...
   14.4966939,  28.9841042, 43.4761563, 57.9682084,         ...
   86.9523127, 115.9364169, 28.4397295, 27.8953548,         ...
   13.9430356,  16.1391017, 14.9589314, 13.3986609,         ...
   12.8542862,  30.0410667, 15.0,       30.0,               ...
   60.0,        90.0,       29.9589333, 29.4556253,         ...
   27.9682084,  28.5125831, 13.4715145, 44.0251729,         ...
   42.9271398,  57.4238337, 58.9841042, 88.9841042,         ...
    1.0980331,   1.0158958,  0.5443747,  0.0410686,         ...
    0.0821373]'; 
 
LocalPhase = NaN*ones(37,1); 
CorrAmpl   = zeros(37,1); 
if length(kappa) == 0   % if tidal constituents have not been loaded 
  tidecst_;             % do that using tidecst_.m which also provides 
end                     % the default Monterey, California station data. 
 
pi180 = pi/180;         % to make degree to radian conversions 
P = zeros(31,1); 
% Julian Day of mid-YEAR (02 July)  
  P(13) = 183 + ((YEAR/4 - floor(YEAR/4)) == 0);    % leap year
% Leap days since 1900 (AM p51) 
  P(14) = (floor((YEAR-1901) / 4));         
% h = mean long sun on 0000 GMT Jan 1 (HA p163) p6 
  P(6)  = 280.19 + 359.76128 * (YEAR-1900) + 0.9856473 * P(14);
% p1 = mean long solar perigee on 0000 GMT Jan 1 (HA p163) p20 
  P(20) = 281.221 + 0.01718 * (YEAR - 1900) + 0.0000471 * P(14);  
% s = mean long moon on 0000 GMT Jan 1 (HA p163) p11 
  P(11) = 277.026 + 129.38482 * (YEAR - 1900) + 13.1763968 * P(14);  
% p = mean long lunar perigee on 0000 GMT Jan 1 (HA p163) p12 
  P(12) = 334.384 + 40.66247 * (YEAR - 1900) + 0.111404 * P(14); 
% mean long lunar perigee at mid-YEAR p21 
  P(21) = P(12) + 0.111404 * P(13);          
 
% N = mean long lunar ascending node on 0000 GMT Jan 1 (HA p163) p8 
  P(8)  = 259.156 - 19.32819 * (YEAR - 1900) - 0.0529539 * P(14);     
% mean long lunar ascending node at mid-YEAR p18 
  P(18) = P(8) - 0.0529539 * P(13);                 
% right ascension of lunar intersection at mid-YEAR (HA p156) p25 
  P(25) = 180*atan(1.01883 * tan(pi180*P(18)/2))/pi; 
 
  P(26) = atan(0.64412 * tan(pi180*P(18)/2))/pi180; 
 
  P(27) = rem(P(25)-P(26)+360,360); 
%  P(27) = (360) + (P(25) - P(26)) 
%  P(25) - P(26)) - floor( (P(25) - P(26))/360 )*360 
 
% longitude moon's orbit of lunar intersection @ mid-YEAR (HA p156) 
  P(31) = P(18) - P(25) - P(26); 
  if (P(31) > 180) 
    P(31) = P(31)- 360; 
  end 
 
% obliquity of lunar orbit at mid-YEAR (HA p156) p7 
  P(7)  = acos(0.9137 - 0.03569 * cos(pi180*P(18)))/pi180;       
% longitude lunar perigee L[2] & M[1] at mid-YEAR (HA p41) p22 
  P(22) = rem(P(21)-P(31),360); 
% term in argument of J[1] (called K1 in HP-85 ver.)(HA p45) p28 
   P(28) = atan(sin(pi180*2*P(7))*sin(pi180*P(27)) / ... 
           (sin(pi180*2*P(7))*cos(pi180*P(27)) + 0.3347))/pi180; 
% term in argument of J[2] (called K2 in HP-85 ver.)(HA p46) p29 
   P(29) = 180*atan((sin(pi180*P(7))*sin(pi180*P(7)))*sin(pi180*2*P(27))/ ... 
           ( (sin(pi180*P(7))^2) * cos(pi180*2*P(27)) + 0.0727 ))/pi; 
% terms in argument of L[2] (HA p44) R=p10; R[1]=p24 
   P(10) = 180*atan(sin(pi180*2*P(22))/(1/(6*  ... 
           (tan(pi180*P(7)/2))^2) - cos(pi180*2*P(22))))/pi; 
   P(24) = 1/sqrt(1 - 12*(tan(pi180*P(7)/2))^2 ...  
           *cos(pi180*2*P(22)) + (36)*(tan(pi180*P(7)/2))^4); 
% terms in argument of M[1] (HA p41-2) Q=p9; Q[1]=p23 
P(9) =  atan(0.483 * tan(pi180*P(22)))/pi180; 
if P(22) > 90  
  P(9) = P(9) + 180; 
end 
if P(22) > 270 
  P(9) = P(9) + 180; 
end 
 
%  if (P(22) .GT. 90 .AND. P(22) .LE. 270) 
%    P(9) = P(9) + 180            
%  end                               
         
P(23) = 1/sqrt(2.31 + 1.435*cos(pi180*2*P(22))); 
P(5)  = 180; 
 
% 27 Oct 96; Checked all P() variables against HP-9815 PLOTtide
%            perfect agreement with p variables to 0.nnnn 
% for i=1:31; fprintf('%3i %14.4f\n',i,P(i));end; 
 
for C = 1:37                   
  if (C == 1)          % 1: J1 or A24 
     P(1)  = 1; 
     P(2)  = P(5) + P(11) + P(6) - P(12) - 90; 
     P(3)  = -P(27); 
     P(4)  = sin(pi180*2*P(7))/0.7214; 
     P(15) = sin(pi180*2*P(7))/0.7214; 
  elseif (C == 2)      % 2: K1 or A22 + B22 
     P(1)  = 1; 
     P(2)  = P(5) + P(6) - 90; 
     P(3)  = -P(28); 
     P(4)  = sqrt(0.8965*sin(pi180* 2*P(7) )^2 + ... 
             0.6001*sin(pi180*2*P(7))*cos(pi180*P(27)) + 0.1006); 
     P(16) = P(4); 
  elseif (C == 3)       % 3: K2 or A47 + B47 
     P(1)  = 2; 
     P(2)  = 2*P(5) + 2*P(6); 
     P(3)  = -P(29); 
     P(4)  = sqrt(19.0444*sin(pi180*P(7))^4 + 2.7702*sin(pi180*P(7))^2 ... 
            *cos(pi180*2*P(27)) + 0.0981); 
  elseif (C == 4)        % 4: L2 or A41 + A48 
     P(1)  = 2; 
     P(2)  = 2*P(5) - P(11) + 2*P(6) - P(12) + 180; 
     P(3)  = 2*P(31) - 2*P(27) - P(10); 
     P(17) = cos(pi180*P(7)/2)^4/0.9154; 
     P(4)  = P(17)/P(24); 
  elseif (C == 5)        % 5: M1 or A16 + A23 
     P(1)  = 1; 
     P(2)  = P(5) - P(11) + P(6) - 90; 
     P(3)  = P(31) - P(27) + P(9); 
     P(19) = sin(pi180*P(7))*cos(pi180*P(7)/2)^2/0.38; 
     P(4)  = P(19)/P(23); 
  elseif (C == 6)        % 6: M2 or A39 
     P(1)  = 2; 
     P(2)  = 2*P(5) - 2*P(11) + 2*P(6); 
     P(3)  = 2*P(31) - 2*P(27); 
     P(4)  = P(17); 
  elseif (C == 7)        % 7: M3 or A82 
     P(1)  = 3; 
     P(2)  = 3*P(5) - 3*P(11) + 3*P(6); 
     P(3)  = 3*P(31) - 3*P(27); 
     P(4)  = cos(pi180*P(7)/2)^6/0.8758; 
  elseif (C == 8)        % 8: M4 
     P(1)  = 4; 
     P(2)  = 4*P(5) - 4*P(11) + 4*P(6); 
     P(3)  = 4*P(31) - 4*P(27); 
     P(4)  = P(17)^2; 
  elseif (C == 9)        % 9: M6 
     P(1)  = 6; 
     P(2)  = 6*P(5) - 6*P(11) + 6*P(6); 
     P(3)  = 6*P(31) - 6*P(27); 
     P(4)  = P(17)^3; 
  elseif (C == 10)       % 10: M8 
     P(1)  = (8); 
     P(2)  = (8)*P(5) - (8)*P(11) + (8)*P(6); 
     P(3)  = (8)*P(31) - (8)*P(27); 
     P(4)  = P(17)^4; 
  elseif (C == 11)       % 11: N2 or A40 
     P(1)  = 2; 
     P(2)  = 2*P(5) - 3*P(11) + 2*P(6) + P(12); 
     P(3)  = 2*P(31) - 2*P(27); 
     P(4)  = P(17); 
  elseif (C == 12)       % 12: 2N2 or A42 
    P(1)  = 2; 
    P(2)  = 2*P(5) - 4*P(11) + 2*P(6) + 2*P(12); 
    P(3)  = 2*P(31) - 2*P(27); 
    P(4)  = P(17); 
  elseif (C == 13)       % 13: O1 or A14 
    P(1)  = 1; 
    P(2)  = P(5) - 2*P(11) + P(6) + 90; 
    P(3)  = 2*P(31) - P(27); 
    P(4)  = P(19);                
  elseif (C == 14)       % 14: OO1 or A31  
    P(1)  = 1; 
    P(2)  = P(5) + 2*P(11) + P(6) - 90; 
    P(3)  = -2*P(31) - P(27); 
    P(4)  = sin(pi180*P(7))*sin(pi180* P(7)/2 )^2/0.0164; 
  elseif (C == 15)       % 15: P1 or B14 
    P(1)  = 1; 
    P(2)  = P(5) - P(6) + 90; 
    P(3)  = 0; 
    P(4)  = 1; 
  elseif (C == 16)       % 16: Q1 or A15 
    P(1)  = 1; 
    P(2)  = P(5) - 3*P(11) + P(6) + P(12) + 90; 
    P(3)  = 2*P(31) - P(27); 
    P(4)  = P(19); 
  elseif (C == 17)       % 17: 2Q1 or A17 
    P(1)  = 1; 
    P(2)  = P(5) - 4*P(11) + P(6) + 2*P(12) + 90; 
    P(3)  = 2*P(31) - P(27); 
    P(4)  = P(19); 
  elseif (C == 18)       % 18: R2 or B41 
    P(1)  = 2; 
    P(2)  = 2*P(5) + P(6) - P(20) + 180; 
    P(3)  = 0; 
    P(4)  = 1; 
  elseif (C == 19)       % 19: S1 or B71 
    P(1)  = 1; 
    P(2)  = P(5); 
    P(3)  = 0; 
    P(4)  = 1;                               
  elseif (C == 20)       % 20: S2 or B39 
    P(1)  = 2; 
    P(2)  = 2*P(5); 
    P(3)  = 0; 
    P(4)  = 1; 
  elseif (C == 21)       % 21: S4 
    P(1)  = 4; 
    P(2)  = 4*P(5); 
    P(3)  = 0; 
    P(4)  = 1; 
  elseif (C == 22)       % 22: S6 
    P(1)  = 6; 
    P(2)  = 6*P(5); 
    P(3)  = 0; 
    P(4)  = 1; 
  elseif (C == 23)       % 23: T2 or B40 
    P(1)  = 2; 
    P(2)  = 2*P(5) - P(6) + P(20); 
    P(3)  = 0; 
    P(4)  = 1; 
  elseif (C == 24)       % 24: lambda2 or A44 
    P(1)  = 2; 
    P(2)  = 2*P(5) -  P(11) + P(12) + 180; 
    P(3)  = 2*P(31) - 2*P(27); 
    P(4)  = P(17); 
  elseif (C == 25)       % 25: mu2 or A45 
    P(1)  = 2; 
    P(2)  = 2*P(5) - 4*P(11) + 4*P(6); 
    P(3)  = 2*P(31) - 2*P(27); 
    P(4)  = P(17); 
  elseif (C == 26)       % 26: nu2 or A43 
    P(1)  = 2; 
    P(2)  = 2*P(5) - 3*P(11) + 4*P(6) - P(12); 
    P(3)  = 2*P(31) - 2*P(27); 
    P(4)  = P(17); 
  elseif (C == 27)       % 27: rho1 or A18 
    P(1)  = 1; 
    P(2)  = P(5) - 3*P(11) + 3*P(6) - P(12) + 90; 
    P(3)  = 2*P(31) - P(27); 
    P(4)  = P(19); 
  elseif (C == 28)       % 28: MK3 
    P(1)  = 3; 
    P(2)  = 3*P(5) - 2*P(11) + 3*P(6) - 90; 
    P(3)  = 2*P(31) - 2*P(27) - P(28); 
    P(4)  = P(17)*P(16); 
  elseif (C == 29)       % 29: 2MK3 
    P(1)  = 3; 
    P(2)  = 3*P(5) - 4*P(11) + 3*P(6) + 90; 
    P(3)  = 4*P(31) - 4*P(27) + P(28); 
    P(4)  = P(17)^2*P(16); 
  elseif (C == 30)       % 30: MN4 
    P(1)  = 4; 
    P(2)  = 4*P(5) - 5*P(11) + 4*P(6) + P(12); 
    P(3)  = 4*P(31) - 4*P(27); 
    P(4)  = P(17)^2; 
  elseif (C == 31)       % 31: MS4 
    P(1)  = 4; 
    P(2)  = 4*P(5) - 2*P(11) + 2*P(6); 
    P(3)  = 2*P(31) - 2*P(27); 
    P(4)  = P(17)^2; 
  elseif (C == 32)       % 32: 2SM6 
    P(1)  = 6; 
    P(2)  = 6*P(5) - 2*P(11) + 2*P(6); 
    P(3)  = 2*P(31) - 2*P(27); 
    P(4)  = P(17); 
  elseif (C == 33)      % 33: Mf or A6 
    P(1)  = 0; 
    P(2)  = 2*P(11); 
    P(3)  = -2*P(31); 
    P(4)  = sin(pi180*P(7))^2/0.1578; 
  elseif (C == 34)      % 34: MSf or A5 
    P(1)  = 0; 
    P(2)  = 2*P(11) - 2*P(6); 
    P(3)  = 0; 
    P(4)  = (2/3 - sin(pi180*P(7))^2)/0.5021; 
  elseif (C == 35)      % 35: Mm or A2 
    P(1)  = 0; 
    P(2)  = P(11) - P(12); 
    P(3)  = 0; 
    P(4)  = (2/3 - sin(pi180*P(7))^2)/0.5021; 
  elseif (C == 36)      % 36: Sa or B64 
    P(1)  = 0; 
    P(2)  = P(6); 
    P(3)  = 0; 
    P(4)  = 1; 
  elseif (C == 37)      % 37: Ssa or B6 
    P(1)  = 0; 
    P(2)  = 2*P(6); 
    P(3)  = 0; 
    P(4)  = 1; 
end  % if C == N  
 
% fprintf('%2i%9.4f %9.4f %9.4f %9.4f \n',C,P(1:4,1))     
 
  if ~isnan(kappa(C,1)) 
    LocalPhase(C,1)  = rem(P(2,1)+P(3,1),360) - ... 
                       P(1,1)*LONGITUDE + ZONE*speeds(C) - kappa(C); 
    LocalPhase(C,1)  = rem(LocalPhase(C),360); 
  end   
  if (LocalPhase(C,1) < 0)  
    LocalPhase(C,1) = LocalPhase(C,1) + 360; 
  end    
  if ampl(C) ~= NaN 
    CorrAmpl(C,1)  = P(4)*ampl(C);  % Corrected for nodal factor 
  else 
    CorrAmpl(C,1) = 0.0; 
  end 
end    % for C = 1,37 
 
% 27 October 1996; Checked CorrAmpl and LocalPhase against  
%                  9816 PLOTtide: amplitudes agree perfectly; 
%                  phases differ by about 0.05 degrees 
 
[SortAmpl,Index] = sort(CorrAmpl);             % sort constituents 
AmplIndex        = flipud(Index(1:NUM_CONST)); % indexes to constituents sorted by amplitude 
 
