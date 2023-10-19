function UpdateWindturbine(windturbine)
% Function to configure the windturbine power in the simulink model
% Author: Jan Luca Uphoff
% Project: ZEPS

m = windturbine.power/(windturbine.nomWind-windturbine.cutInWind);
b = -m*windturbine.cutInWind;

mdl = 'ZEPS';
block = 'Wind/turbine function';
ID = [mdl, '/', block];
%% model manipulation
load_system(mdl)
set_param(ID + "/m", "Gain", string(m));
set_param(ID + "/b", "Value", string(b));
set_param(ID + "/Saturation", "upperLimit", string(windturbine.nomWind));
save_system(mdl)
end