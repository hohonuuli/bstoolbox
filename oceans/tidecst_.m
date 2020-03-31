% tidecst_ - Assign values to global tidal constants: constituent names, speed numbers 
% 
% This procedure returns the 37 NOAA tidal constituent names, and 
% speed numbers (deg/hr) and constituent data for Monterey, California. 
% 
%  tidenames[1:37]  Symbolic names of the tide constituents 
%     speeds[1:37]  Speed numbers of the constituents (deg/hr) 
%  Monterey Bay Tidal Constituents: 
%        msl        Mean Sea Level 
%       ampl[1:37]  Amplitudes of the constituents 
%      kappa[1:37]  Greenwich phase of the constituents 
% 
% Use As:   tidecnst 
% Input:    none
% Output:   global variables:
%           tidenames speeds msl ampl kappa  
%           STN_NAME STN_NUMBER STN_LENGTH STN_YEAR  
%           NUM_CONST LATITUDE LONGITUDE AMP_MULT YEAR ZONE 
%
% See Also: MLTIDE, TIDEPHS_
%
% Note:     Programs that use data supplied by this procedure must
% declare the global variables.  
 
% 19 Oct 1996; W. Broenkow 
 
global tidenames speeds msl ampl kappa  
global STN_NAME STN_NUMBER STN_LENGTH STN_YEAR  
global NUM_CONST LATITUDE LONGITUDE AMP_MULT YEAR ZONE 
 
a = str2mat('J1','K1','K2','L2','M1','M2','M3','M4'); 
b = str2mat('M6','M8','N2','2N2','O1','OO1','P1','Q1'); 
c = str2mat('2Q1','R2','S1','S2','S4','S6','T2','lmbda2'); 
d = str2mat('mu2','nu2','rho1','MK3','2MK3','MN4','MS4','2SM6'); 
e = str2mat('Mf','MSf','Mm','Sa','Ssa'); 
tidenames = str2mat(a,b,c,d,e); 
 
speeds =  [15.5854433,  15.0410686, 30.0821373, 29.5284789, ...
   14.4966939,  28.9841042, 43.4761563, 57.9682084,         ...
   86.9523127, 115.9364169, 28.4397295, 27.8953548,         ... 
   13.9430356,  16.1391017, 14.9589314, 13.3986609,         ... 
   12.8542862,  30.0410667, 15.0,       30.0,               ...
   60.0,        90.0,       29.9589333, 29.4556253,         ...
   27.9682084,  28.5125831, 13.4715145, 44.0251729,         ...
   42.9271398,  57.4238337, 58.9841042, 88.9841042,         ...
    1.0980331,  1.0158958,   0.5443747,  0.0410686,         ...
    0.0821373]'; 
 
STN_NAME     = 'Monterey, California'; 
STN_NUMBER   =    0;      % indicate use of built-in data 
STN_LENGTH   =  365;      % length of tide observations (days) 
STN_YEAR     = 1974;      % beginning year of observations 
NUM_CONST    =   20;      % number of constituents 
LATITUDE     =  36.604;   %  36 36.2 North 
LONGITUDE    = 121.888;   % 121 53.3 West  
AMP_MULT     =   1.00 ;   % amplitudes in feet 
ZONE         =    8;      % Pacific Standard Time, may change by tidephse 
msl  = 2.870; 
ampl = [ 0.071, 1.216, 0.121, 0.046, 0.117, 1.628, NaN, ... 
        NaN, NaN, NaN, 0.366, 0.046, 0.763, 0.039, 0.381, 0.137 ... 
        0.020, NaN, 0.038, 0.425, NaN, NaN, 0.025, 0.011, 0.046 ... 
        0.069, 0.029, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN]'; 
 
kappa = [107.0, 97.8, 287.7, 322.8, 114.8, 297.4, NaN, NaN, NaN, NaN ... 
         272.0, 248.5, 81.4, 119.6, 92.7, 72.9, 65.0, NaN, 202.3, 295.5 ... 
         NaN, NaN, 295.5, 296.5, 234.4, 279.4, 74.3, NaN, NaN, NaN ... 
         NaN, NaN, NaN, NaN, NaN, NaN, NaN]'; 
 
