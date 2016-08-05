
%% Load Elevation Data

% tEphase Attributes:
% long_name = 'tidal elevation phase angle'
% units     = 'degrees, time of maximum elevation with respect to chosen time origin'
% field     = 'tide_Ephase, scalar, series'

    tEphase_s2 = tEphase(:,:,1);
    tEphase_m2 = tEphase(:,:,2);
    tEphase_n2 = tEphase(:,:,3);
    tEphase_k1 = tEphase(:,:,4);
    tEphase_o1 = tEphase(:,:,5);

% tEamp Attributes:
% long_name = 'tidal elevation amplitude'
% units     = 'meter'
% field     = 'tide_Eamp, scalar, series'

    tEamp_s2 = tEamp(:,:,1);
    tEamp_m2 = tEamp(:,:,2);
    tEamp_n2 = tEamp(:,:,3);
    tEamp_k1 = tEamp(:,:,4);
    tEamp_o1 = tEamp(:,:,5);

%% Load Current Data

% tCphase Attributes:
% long_name = 'tidal current phase angle'
% units     = 'degrees, time of maximum velocity with respect chosen time origin'
% field     = 'tide_Cphase, scalar'

    tCphase_s2 = tCphase(:,:,1);
    tCphase_m2 = tCphase(:,:,2);
    tCphase_n2 = tCphase(:,:,3);
    tCphase_k1 = tCphase(:,:,4);
    tCphase_o1 = tCphase(:,:,5);

% tCangle Attributes:
% long_name = 'tidal current inclination angle'
% units     = 'degrees between semi-major axis and East'
% field     = 'tide_Cangle, scalar'

    tCangle_s2 = tCangle(:,:,1);
    tCangle_m2 = tCangle(:,:,2);
    tCangle_n2 = tCangle(:,:,3);
    tCangle_k1 = tCangle(:,:,4);
    tCangle_o1 = tCangle(:,:,5);

% Cmax Attributes:
% long_name = 'maximum tidal current, ellipse semi-major axis'
% units     = 'meter second-1'
% field     = 'tide_Cmax, scalar'

    tCmax_s2 = tCmax(:,:,1);
    tCmax_m2 = tCmax(:,:,2);
    tCmax_n2 = tCmax(:,:,3);
    tCmax_k1 = tCmax(:,:,4);
    tCmax_o1 = tCmax(:,:,5);


% Cmin Attributes:
% long_name = 'minimum tidal current, ellipse semi-minor axis'
% units     = 'meter second-1'
% field     = 'tide_Cmin, scalar'

    tCmin_s2 = tCmin(:,:,1);
    tCmin_m2 = tCmin(:,:,2);
    tCmin_n2 = tCmin(:,:,3);
    tCmin_k1 = tCmin(:,:,4);
    tCmin_o1 = tCmin(:,:,5);

