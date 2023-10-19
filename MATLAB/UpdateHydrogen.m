function m = UpdateHydrogen(V, p)
% UPDATEFUELCELL configures the hydrogen fuel in the model
% Author: Jan Luca Uphoff
% Project: ZEPS

p = p*1e5; %pressure in Pascal
V = V*1e-3; %Volume in m3
Rs = 4125; %specific gas constant for hydrogen 
T = 293.15; %temperature in K -> 15°C
m = p*V/(Rs*T); %ideal gas law

m = 0.9*m; %adaption for Linde data sheet

mdl = 'ZEPS';
block = 'PEM fuel cell';
ID = [mdl, '/', block];

%% model manipulation
load_system(mdl)
set_param(ID + "/Hydrogen (kg)", "Value", string(m));

save_system(mdl)
end