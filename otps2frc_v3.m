function otps2frc_v3(gfile,base_date,pred_date,ofile,model_file)
%otps2frc_v1 Generete OTPS tidal forcing file for ROMS
%
%otps2frc_v1(gfile,base_date,ofile,flag) generates a ROMS tidal
%forcing  ofile using the ROMS gridfile gfile and the tidal
%reference time base_date in matlab time. pred_date is the
%prediction timde for nodal corrections, typically the center time
%of a two year prediction period, also in MATLAB time.model_file is
%the path to the directory contained to appropriate OTPS model output
%
%Example:
%>> t=datenum(2005,1,1);
%>> tpred=datenum(2005,1,1);
%>> gfile='/home/hunter/roms/in/roms_latte_grid_3c.nc';
%>> otps2frc_v3(gfile,t,tpred,'test_EC.nc','DATA/Model_EC') 
%
%Requirements:
%T_TIDE tidal analysis package
%"tidal_ellipse" (Zhigang Xu) package, ap2ep.m
%Requires extract_HC.f.f to be compiled as extract_HC
%
%Originally written by John Evans
%Revised by Eli Hunter 3/7/07
%Revised by Eli Hunter 5/25/07 (corrected phase lag error)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Collect the information necessary to run extract_HC and 
%create setup files. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vars=['z','u','v'];
harmonics_prefix='otps_harmonics_';
%Build grid file 
llfile='./ll.dat';
roms2ll(gfile,llfile);
disp(['Gridfile ' gfile ' lat/lon written to ' llfile])

if ~(exist(model_file,'file'))
  error(['No Such model file: ' model_file])  
end

disp(['Mode parameter file used: ' model_file])

%% SEC Added 2/1/2016 in order to get the PATH correct to run extract_HC
setenv('DYLD_LIBRARY_PATH','usr/local/bin/');

PATH = getenv('PATH');
setenv('PATH',[PATH ':/usr/bin/local']);

PATH = getenv('PATH');
setenv('PATH',[PATH ':/Users/scook/Desktop/PhD_Research/src/OTPS']);

PATH = getenv('PATH');
setenv('PATH',[PATH ':/opt/local']);



for i=1:length(vars)
  disp(['Generating parameter file for ' vars(i)])
  fid=fopen('otps_input','w');
  fprintf(fid,'%s\n',model_file);
  fprintf(fid,'%s\n',llfile);
  fprintf(fid,'%s\n',vars(i));
  fprintf(fid,'%s\n','m2,s2,k1,o1,n2');
  fprintf(fid,'%s\n','AP');
  fprintf(fid,'%s\n','oce');
  fprintf(fid,'%s\n','0');
  fprintf(fid,'%s\n',[harmonics_prefix vars(i)]);
  fclose(fid);
  
  
  disp(['Extracting ' vars(i) ' Harmonics'])
  
  [s,w]=unix('extract_HC < otps_input');
  disp([' '])
  disp(['*******************************************'])
  disp(w)
  disp(['*******************************************'])
end  

mask_rho = nc_varget ( gfile, 'mask_rho' );
 land = find(mask_rho==0);
water = find(mask_rho==1);




fprintf ( 1, 'Reading %s...\n', [harmonics_prefix vars(1)] );

[z_hc,lon,lat] = read_otps_output([harmonics_prefix vars(1)]);
[period, z_amp, z_phase, names] = reshape_to_grid ( z_hc, gfile );

fprintf ( 1, 'Reading %s...\n', [harmonics_prefix vars(2)]);

[u_hc,lon,lat] = read_otps_output([harmonics_prefix vars(2)]);
[period, u_amp, u_phase, names] = reshape_to_grid ( u_hc, gfile );

fprintf ( 1, 'Reading %s...\n', [harmonics_prefix vars(3)]);

[v_hc,lon,lat] = read_otps_output([harmonics_prefix vars(3)]);
[period, v_amp, v_phase, names] = reshape_to_grid ( v_hc, gfile );


cnames=upper(char(names));


%
% Make sure that the OTPS mask agrees with the ROMS mask.
% Fill in any points that ROMS thinks is water but OTPS thinks is land.

num_constituents = length(period);
lon_rho = nc_varget ( gfile, 'lon_rho' );
lat_rho = nc_varget ( gfile, 'lat_rho' );
mask_rho = nc_varget ( gfile, 'mask_rho' );
a=t_getconsts;

depth = ncread(gfile,'h')';

for j = 1:num_constituents

	component = squeeze ( z_amp(j,:,: ) );
	z_amp(j,:,:) = match_roms_mask ( lon_rho, lat_rho, mask_rho, depth, component );

	component = squeeze ( z_phase(j,:,: ) );
	z_phase(j,:,:) = match_roms_mask ( lon_rho, lat_rho, mask_rho, depth, component );

	component = squeeze ( u_amp(j,:,: ) );
	u_amp(j,:,:) = match_roms_mask ( lon_rho, lat_rho, mask_rho, depth, component );

	component = squeeze ( u_phase(j,:,: ) );
	u_phase(j,:,:) = match_roms_mask ( lon_rho, lat_rho, mask_rho, depth, component );

	component = squeeze ( v_amp(j,:,: ) );
	v_amp(j,:,:) = match_roms_mask ( lon_rho, lat_rho, mask_rho, depth, component );

	component = squeeze ( v_phase(j,:,: ) );
	v_phase(j,:,:) = match_roms_mask ( lon_rho, lat_rho, mask_rho, depth, component );

        iconst(j)=strmatch(cnames(j,:), a.name)
        Tide.period(j)=1/a.freq(iconst(j));
end


% Tide.period = period;
Tide.names = names;


Ntide = length(z_hc);
rg = roms_get_grid ( gfile );
[Lp,Mp] = size(rg.lon_rho);

z_amp = zero_out_land ( z_amp, land );
z_phase = zero_out_land ( z_phase, land );
	

%***********************************************************************
% This is the call to t_vuf that
% will correct the phase to be at the user specified time.  Also, the amplitude
% is corrected for nodal adjustment.

% Reference latitude for 3rd order satellites (degrees) is 
% set to 55.  You don't need to adjust this to your local latitude
% It could also be set to NaN as in Xtide, with very little effect.  
% See T_VUF for more info.
type = 'nodal';
reflat=55;
[V,U,F]=t_vuf(type, base_date,iconst,reflat);
[Vp,Up,Fp]=t_vuf(type, pred_date,iconst,reflat);%Only used for nodal correction. 

%vv and uu are returned in cycles, so * by 360 to get degrees or * by 2 pi to get radians

V=V*360;  % convert vv to phase in degrees
U=U*360;  % convert uu to phase in degrees
Vp=Vp*360;  % convert vv to phase in degrees
Up=Up*360;  % convert uu to phase in degrees


for k=1:Ntide;
    z_phase(k,:,:) = z_phase(k,:,:) - Up(k)  - V(k);   % degrees
    z_amp(k,:,:) =z_amp(k,:,:) .* Fp(k);

    u_phase(k,:,:) =u_phase(k,:,:) - Up(k) - V(k);   % degrees
    u_amp(k,:,:) = u_amp(k,:,:) .* Fp(k);
    
    v_phase(k,:,:) = v_phase(k,:,:) - Up(k)  - V(k);   % degrees
    v_amp(k,:,:) =v_amp(k,:,:) .* Fp(k);

end


z_phase=mod(z_phase,360);
u_phase=mod(u_phase,360);
v_phase=mod(v_phase,360);

Tide.Ephase    = z_phase(:,:,:);
Tide.Eamp      = z_amp(:,:,:);



%---------------------------------------------------------------------
%  Convert tidal current amplitude and phase lag parameters to tidal
%  current ellipse parameters: Major axis, ellipticity, inclination,
%  and phase.  Use "tidal_ellipse" (Zhigang Xu) package.
%---------------------------------------------------------------------
[major,eccentricity,inclination,phase]=ap2ep(u_amp,u_phase,v_amp,v_phase);
	
major = zero_out_land ( major, land );
eccentricity = zero_out_land ( eccentricity, land );
major = major/100;
Tide.Cmax=major;
Tide.Cmin=major.*eccentricity;
Tide.Cangle= zero_out_land ( inclination, land );
Tide.Cphase = zero_out_land ( phase, land );


write_roms_otps_ncfile ( Tide, gfile, ofile,base_date,model_file);
