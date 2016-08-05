fname = 'tide_hampton2011.nc';
% 
% Global Attributes:
%            type               = 'ROMS Forcing File'
%            title              = 'Forcing for Combined2016_v2  domain'
%            base_date          = 'days since 2015-08-21 00:00:00'
%            grid_file          = '/Users/scook/Desktop/PhD_Research/greatbaydata/grid_files/Combined2016/Combined2016_grd.nc'
%            source             = 'OTPS'
%            source_url         = 'http://www.coas.oregonstate.edu/research/po/research/tide/region.html'
%            history            = '03-Feb-2016 12:12:58:  Created by scook with write_roms_otps_ncfile.
%                                 '
%            comment            = 'Inputs for OTPS executable "extract_HC" created with m-file roms2ll.m using the grid file as input.Data/Model_EC was used as the OTPS regional model.   '
%            tidal_constituents = 's2, m2, n2, k1, o1'
% Dimensions:
%            two         = 2
%            eta_rho     = 834
%            xi_rho      = 801
%            tide_period = 5     (UNLIMITED)

mask_rho = ncread(fname,'mask_rho');   
lat_rho = ncread(fname,'lat_rho'); 
lon_rho = ncread(fname,'lon_rho'); 
tperiod = ncread(fname,'tide_period');   

tEphase = ncread(fname,'tide_Ephase'); 

%     tide_Ephase       
%            Size:       734x834x5
%            Dimensions: xi_rho,eta_rho,tide_period
%            Datatype:   double
%            Attributes:
%                        long_name = 'tidal elevation phase angle'
%                        units     = 'degrees, time of maximum elevation with respect to chosen time origin'
%                        field     = 'tide_Ephase, scalar, series'
                       
tEamp = ncread(fname,'tide_Eamp'); 

%     tide_Eamp         
%            Size:       734x834x5
%            Dimensions: xi_rho,eta_rho,tide_period
%            Datatype:   double
%            Attributes:
%                        long_name = 'tidal elevation amplitude'
%                        units     = 'meter'
%                        field     = 'tide_Eamp, scalar, series'

tCphase = ncread(fname,'tide_Cphase'); 

%     tide_Cphase       
%            Size:       734x834x5
%            Dimensions: xi_rho,eta_rho,tide_period
%            Datatype:   double
%            Attributes:
%                        long_name = 'tidal current phase angle'
%                        units     = 'degrees, time of maximum velocity with respect chosen time origin'
%                        field     = 'tide_Cphase, scalar'

tCangle = ncread(fname,'tide_Cangle'); 

%     tide_Cangle       
%            Size:       734x834x5
%            Dimensions: xi_rho,eta_rho,tide_period
%            Datatype:   double
%            Attributes:
%                        long_name = 'tidal current inclination angle'
%                        units     = 'degrees between semi-major axis and East'
%                        field     = 'tide_Cangle, scalar'

tCmin = ncread(fname,'tide_Cmin'); 

%     tide_Cmin         
%            Size:       734x834x5
%            Dimensions: xi_rho,eta_rho,tide_period
%            Datatype:   double
%            Attributes:
%                        long_name = 'minimum tidal current, ellipse semi-minor axis'
%                        units     = 'meter second-1'
%                        field     = 'tide_Cmin, scalar'
                       
tCmax = ncread(fname,'tide_Cmax'); 

%     tide_Cmax         
%            Size:       734x834x5
%            Dimensions: xi_rho,eta_rho,tide_period
%            Datatype:   double
%            Attributes:
%                        long_name = 'maximum tidal current, ellipse semi-major axis'
%                        units     = 'meter second-1'
%                        field     = 'tide_Cmax, scalar'
                       
tconstit = ncread(fname,'tidal_constituents'); 

%     tidal_constituents
%            Size:       2x5
%            Dimensions: two,tide_period
%            Datatype:   char
%            Attributes:
%                        long_name = 'Tidal Constituent Names'                       
                       


