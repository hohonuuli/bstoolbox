% OCEAN General Purpose Function Library 
% Copyright (c)  Moss Landing Marine Laboratories
% Rev 22 August 1997
%
% Oceanographic Functions
%
%  ATG_      - Adiabatic temperature gradient (S,T,P) UNESCO 44
%  BO4K1_    - First apparent dissociation constant of boric acid (S,T,P)
%  BULKMOD_  - Seawater bulk modulus (S,T,P) UNESCO 44
%  C2T_      - Convert beam attenuation (/m) to percent beam transmission
%  CELERTY_  - Ideal wave phase speed f(Period, Depth)
%  CONDUCT_  - Electrical conductivity of seawater (S,T,P) Salinity-78
%  CO2K1_    - First apparent dissociation constant for CO2 (S,T,P)
%  CO2K2_    - Second apparent dissociation constant for CO2 (S,T,P)
%  CO2SOL_   - CO2 Solubility (S,T,P)
%  DELTA_    - Specific volume anomaly IES-80
%  DENSITY_  - Seawater density (S,T,P) IES-80
%  DEPTH_    - Ocean depth (P, latitude) UNESCO 44
%  EKMANMU_  - Seawater compressibility from Ekman (1908)     
%  FREEZE_   - Freezing point of seawater (S,P) UNESCO 44
%  FRESNEL_  - Fresnel reflectance (theta,refractive index)
%  KEDNSTY_  - Seawater density (S,T,P) Knudsen(1901) & Ekman(1908)
%  KSIGMAT_  - Sigma-t of seawater (S,T) Knudsen (1901)
%  LABSAL_   - Salinity from laboratory salinometer (R,T)
%  LDENSTY_  - Linearized seawater density for simple modelling (S,T)
%  MLTIDE_   - Tidal predictions using the NOAA 37 Constituent method
%              Uses tide constituents saved in MLDBASE formatted files.
%  OXYSOL_   - Oxygen solubility of seawater (S,T) Postma (1976)
%  PRESRSP_  - Pressure transfer function for wave spectra made with pressure sensors
%  RSCFLUR_  - Convert MLML Chlorophyll fluorescence to approximate pigment concentration
%  SALIN_    - Convert conductivity ratio to practical salinity UNESCO 44 (R,T,P)
%  SIGMAGR_  - Plot sigma-t isopleths on T-S graph
%  SIGMAT_   - Sigma-T for seawater (S,T) IES-80
%  SPCHEAT_  - Specific heat for seawater (S,T,P) UNESCO 44
%  SPDNUM_   - Tidal speed numbers (degrees/hr) as beat frequencies 
%  SVEL_     - Sound velocity in seawater (S,T,P) UNESCO 44
%  TIDECST_  - Default tidal height constituents for Monterey, California
%  TIDEPHS_  - Compute tidal phase lags for use in MLTIDE_
%  THETA_    - Potential temperature (S,T,P,Pr) UNESCO 44
%  T2C_      - Convert percent beam transmission to beam attenuation (1/m)
%  VECTAVG_  - Vector average magnitude and direction (degrees geographic) 
%  WILSON_   - Sound velocity in seawater (S,T,P) Wilson (1960)
%
% Angle, Date and Number Conversion 
%
%  BIN2INT_  - Convert vector of set bit positions to base-10 integer
%  CALDATE_  - Convert Julian date to DD.MMYY and year, month, day of year
%  DATEFMT_  - Output date as string of day month and year in several styles
%  DEC2BIN_  - Convert decimal fraction to binary string
%  DEC2BN2_  - Convert decimal integer to binary string
%  DEG2DMS_  - Convert angle DD.ddd decimal format to DD.MMm or DD.MMSSs 
%  DEG2RAD_  - Convert degrees to radians
%  DMS2DEG_  - Convert angle DD.MMm or DD.MMSSs format to decimal degrees
%  FILDATE_  - Calculate packed file date from julian day of year
%  FINDIGT_  - Return position in the input string of all digits 0..9
%  FRC2PI_   - Returns positive angle in radians from input angle in degrees
%  GEO2MTH_  - Convert geographic direction to math angle (deg or rad)
%  GEOPOLR_  - Plot polar graph using geographic angle (0..360 clockwise)
%  HLPDATE_  - Show the essence of all of the time and date conversions
%  ISBTSET_  - Tests whether a binary value is included in a test value
%  JULDATE_  - Convert calendar date (Year, Month, Day) to Julian date
%  JULDAY_   - Determine Julian day of the year (1..365) and day of week (1..7)
%  JULSEC_   - Return the Julian date in seconds from packed calendar date 
%  MTH2GEO_  - Convert math angle to geographic direction (deg or rad)
%  NOW_      - Convert system time and date to different formats
%  RAD2DEG_  - Convert radians to degrees  
%  TIMEPK_   - Pack Y,M,D,H,M,S in the YYMMDD.HHMMSS format
%  TIMESNC_ -  Return the time between T1 and T2 in specified Units
%  TIMEUPK_  - Unpack time from the YYMMDD.HHMMSS packed form into Y,M,D,H,M,S
%
% Charts and Geographical Distance
%
%  DEADRKN_  - Advance latitude & longitude by rhumbline distance and course
%  GCINTRP_  - Intermediate great circle position between 2 points (lat1,lon1,lat2,lon2,dist)
%  GCIRCLE_  - Great circle distance and heading (lat1,lon1,lat2,lon2)
%  GCTRACK_  - Great circle trackline between 2 positions
%  INVMERD_  - Inverse meridional parts, use in digitizing Mercator maps
%  MERIDN1_  - Spherical meridional distance = minutes of latitude per degree of longitude
%  MERIDN2_  - Spheroidal meridional distance
%  MRCTMAP_  - Plot Mercator map with trackline overlay
%  ORTHLBL_  - Creates grid labels for orthographic projection maps
%  ORTHMAP_  - Create orthographic map of the world on the default display
%  ORTHPLT_  - Plot orthographic projection of the world
%  RHUMBL_   - Rhumbline distance between latitude-longitude pairs
% 
% Solar Ephemeris
%
%  ALMANAC_  - Moderate precision sun ephemeris Van Flanderen and Pulkkinen (1979)
%  ALTAZM_   - Celestial altitude and azimuth f(declin,GHA,lat,long)
%  ANALEMA_  - Plot sun altitude vs Eq. Time and noon sun altitude vs azimuth
%  DAYNITE_  - Polar plot of the sun altitude vs azimuth
%  ERTHSUN_  - Low precision Earth-Sun distance f(julian day of year)
%  EPHEMS_   - High precision solar ephemeris Wilson (1980) 
%  NECKLAB_  - Return Neckle and Labs extraterrestrial irradiance
%  NOON_     - Time of Local Apparant Noon (LAN) from date and longitude
%  PLANCK_   - Evaluate Planck's black-body spectral radiance function
%  RISESET_  - Plot yearly graph giving time of sunrise, sunset, local noon
%  SUNALT_   - Daily sun altitude, azimuth, sunrise, sunset and airmass predictions
%  SUNANG2_  - Low precision solar altitude, azimuth, declination, eq of time 
%  SUNRISE_  - Time and azimuth of sunrise from date and position
%  SUNSET_   - Time and azimuth of sunset from date and position
%
% Atmospheric Correction/Image Processing
%
%  AIRMASS_  - Atmospheric thickness for all constituents; Gordon (ca 1977)
%  AIRMAS1_  - Atmospheric thickness for all constituents; Kasten (1966)
%  AIRMAS2_  - Atmospheric thickness for ozone; Platridge & Platt (1976)
%  OZONE_    - Atmospheric ozone concentration in Dobsons
%  PAR_      - Photosynthetically Active Radiation f(lambda,irradiance)
%  READEPH_  - Read NASA/NORAD 2-line satellite ephemeris
%  QUANTA_   - Convert irradiance uW/cm^2 s nm to uEinstein/m^2 s nm
%  TAUOZON_  - Ozone optical thickness; Gregg & Carder (1990)
%  TAURAY_   - Rayleigh optical thickness f(wavelength); Bird & Riordan (1986)
%  TAURAY1_  - Rayleigh optical thickness f(wavelength); Gordon et al. (1988)
%  TAURAY2_  - Rayleigh optical thickness f(wavelength); Reaves & Broenkow (1989)
%
% Utilities
%
%  DIGITIZ_  - Digitize line graphs using mouse or digitizing tablet
%  DIRLIST_  - Returns a list of filenames from the specified directory
%  FUNCOPY_  - Copy all functions listed in contents.m to disk
%  FUNREQR_  - List OCEAN and MLDBASE functions required by target function
%  FUNUSED_  - List OCEAN and MLDBASE functions that use the target function
%  LISTCHR_ -  Create a table of ACSII Characters and codes
%  LOADASC_  - Read an ASCII data file, replace missing number codes
%  PLIST_    - List programs or text files to LaserJet printer
%
%  See Also:  help MLDBASE; help CZCS 

% Copyright (c) 1996 by Moss Landing Marine Laboratories

