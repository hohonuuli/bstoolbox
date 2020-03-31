% OCEAN General Purpose Function Library 
% Rev 17 February 1997
%
% Oceanographic Functions Original Names
%
%  TIMEPK    - Pack Y,M,D,H,M,S in the YYMMDD.HHMMSS format
%  TIMESINC  -  Return the time between T1 and T2 in specified Units
%  TIMEUNPK  - Unpack time from the YYMMDD.HHMMSS packed form into Y,M,D,H,M,S
%
% Charts and Geographical Distance
%
%  DEADRCKN  - Advance latitude & longitude by rhumbline distance and course
%  GCINTERP  - Intermediate great circle position between 2 points (lat1,lon1,lat2,lon2,distance)
%  GCIRCLE   - Great circle distance and heading (lat1,lon1,lat2,lon2)
%  GCTRACK   - Great circle trackline between 2 positions
%  INVMERID  - Inverse meridional parts, use in digitizing Mercator maps
%  MERIDIN1  - Spherical meridional distance = minutes of latitude per degree of longitude
%  MERIDIN2  - Spheroidal meridional distance
%  MRCTRMAP  - Plot Mercator map with trackline overlay
%  ORTHOLBL  - Creates grid labels for orthographic projection maps
%  ORTHOMAP  - Create orthographic map of the world on the default display
%  ORTHOPLT  - Plot orthographic projection of the world
%  RHUMBL    - Rhumbline distance between latitude-longitude pairs
%  WRLDMAP_  -

% Solar Ephemeris
%
%  ALMANAC   - Moderate precision sun ephemeris Van Flanderen and Pulkkinen (1979)
%  ALTAZM    - Celestial altitude and azimuth f(declin,GHA,lat,long)
%  ANALEMMA  - Plot sun altitude vs Eq. Time and noon sun altitude vs azimuth
%  DAYNIGHT  -
%  EARTHSUN  - Low precision Earth-Sun distance f(julian day of year)
%  EPHEMS    - High precision solar ephemeris Wilson (1980) 
%  NOON      - Time of Local Apparant Noon (LAN) from date and longitude
%  RISESET   -
%  SUNALT    - Daily sun altitude, azimuth, sunrise, sunset, local noon  
%  SUNANG2   - Low precision solar altitude, azimuth, declination, eq of time 
%  SUNRISE   - Time and azimuth of sunrise from date and position
%  SUNSET    - Time and azimuth of sunset from date and position
%
% Atmospheric Correction/Image Processing
%
%  AIRMASS   - Atmospheric thickness for all constituents; Gordon (ca 1977)
%  AIRMASS1  - Atmospheric thickness for all constituents; Kasten (1966)
%  AIRMASS2  - Atmospheric thickness for ozone; Platridge & Platt (1976)
%  OZONE     - Atmospheric ozone concentration in Dobsons
%  PAR       - Photosynthetically Active Radiation f(lambda,irradiance)
%  QUANTA    - Convert irradiance uW/cm^2 s nm to uEinstein/m^2 s nm
%  TAUOZONE  - Ozone optical thickness; Gregg & Carder (1990)
%  TAURAYLE  - Rayleigh optical thickness f(wavelength); Bird & Riordan (1986)
%  TAURAYL1  - Rayleigh optical thickness f(wavelength); Gordon et al. (1988)
%  TAURAYL2  - Rayleigh optical thickness f(wavelength); Reaves & Broenkow (1989)
%
% Utilities
%
%  DIGITIZE  - Digitize line graphs using mouse or digitizing tablet
%  DIRLIST   - Returns a list of filenames from the specified directory
%  FUN_COPY  - Copy all functions listed in contents.m to disk
%  FUN_REQR  - List OCEAN and MLDBASE functions required by target function
%  FUN_USED  - List OCEAN and MLDBASE functions that use the target function
%  LISTCHAR  - List all of the ASCII characters and codes
%  LOADASCI  - Read an ASCII data file, replace missing number codes
%  PLIST     - List programs or text files to LaserJet printer
%
%  See Also:  help MLDBASE; help CZCS 

% Copyright (c) 1996 by Moss Landing Marine Laboratories
%  COASTS    -

%  ATG       - Adiabatic temperature gradient (S,T,P) UNESCO 44
%  BO4K1     - First apparent dissociation constant of boric acid (S,T,P)
%  BULKMOD   - Seawater bulk modulus (S,T,P) UNESCO 44
%  CCC2TTT   - Convert beam attenuation (/m) to percent beam transmission
%  CELERITY  - Ideal wave phase speed f(Period, Depth)
%  CONDUCT   - Electrical conductivity of seawater (S,T,P) Salinity-78
%  CO2K1     - First apparent dissociation constant for CO2 (S,T,P)
%  CO2K2     - Second apparent dissociation constant for CO2 (S,T,P)
%  CO2SOL    - CO2 Solubility (S,T,P)
%  DELTA     - Specific volume anomaly IES-80%  DENSITY   - Seawater density (S,T,P) IES-80
%  DEPTH     - Ocean depth (P, latitude) UNESCO 44
%  DENSITY   - Seawater density (S,T,P) IES-80
%  EKMANMU   - Seawater compressibility from Ekman (1908)     
%  FREEZE    - Freezing point of seawater (S,P) UNESCO 44
%  FRESNEL   - Fresnel reflectance (theta,refractive index)
%  KEDENSTY  - Seawater density (S,T,P) Knudsen(1901) & Ekman(1908)
%  KSIGMAT   - Sigma-t of seawater (S,T) Knudsen (1901)
%  LABSAL    - Salinity from laboratory salinometer (R,T)
%  LDENSITY  - Linearized seawater density for simple modelling (S,T)
%  OXYSOL    - Oxygen solubility of seawater (S,T) Postma (1976)
%  PRESSRSP  - Compute the pressure transfer function for wave spectra made with pressure sensors
%  RSCFLUOR  - Convert MLML Chlorophyll fluorescence to approximate pigment concentration
%  SALIN     - Conversion of conductivity ratio to practical salinity UNESCO 44 (R,T,P)
%  SIGMAGR   - Plot sigma-t isopleths on T-S graph
%  SIGMAT    - Sigma-T for seawater (S,T) IES-80
%  SPCHEAT   - Specific heat for seawater (S,T,P) UNESCO 44
%  SPEEDNUM  - Tidal speed numbers as beat frequencies of fundamental astronomical periods   
%  SVEL      - Sound velocity in seawater (S,T,P) UNESCO 44
%  TIDECNST  - Default tidal height constituents for Monterey, California
%  TIDEPHSE  - Compute tidal phase lags for use in MLTIDE
%  THETA     - Potential temperature (S,T,P,Pr) UNESCO 44
%  TTT2CCC   - Convert percent beam transmission to beam attenuation (1/m)
%  VECTAVG   - Vector average magnitude and direction (degrees geographic) 
%  WILSON    - Sound velocity in seawater (S,T,P) Wilson (1960)
%
% Angle, Date and Number Conversion 
%
%  BIN2INT   - Convert vector of set bit positions to base-10 integer
%  CALDATE   - Convert Julian date to DD.MMYY and year, month, day of year
%  DATE_FMT  - Output date as string of day month and year in several styles
%  DEC2BIN   - Convert decimal fraction to binary string
%  DEC2BIN2  - Convert decimal integer to binary string
%  DEG2DMS   - Convert angle DD.ddd decimal format to DD.MMm or DD.MMSSs 
%  DEG2RAD   - Convert degrees to radians
%  DMS2DEG   - Convert angle DD.MMm or DD.MMSSs format to decimal degrees
%  FILEDATE  - Calculate packed file date from julian day of year
%  FINDIGIT  - Return position in the input string of all digits 0..9
%  FRC2PI    - Returns positive angle in radians from input angle in degrees
%  GEO2MATH  - Convert geographic direction to math angle (deg or rad)
%  GEOPOLAR  - Plot polar graph using geographic angle (0..360 clockwise)
%  HELPDATE  - Show the essence of all of the time and date conversions
%  ISBITSET  - Tests whether a binary value is included in a test value
%  JULDATE   - Convert calendar date (Year, Month, Day) to Julian date
%  JULDAY    - Determine Julian day of the year (1..365) and day of week (1..7)
%  JULSEC    - Return the Julian date in seconds from packed calendar date 
%  MATH2GEO  - Convert math angle to geographic direction (deg or rad)
%  HOWNOW    - Convert system time and date to different formats
%  RAD2DEG   - Convert radians to degrees
 
