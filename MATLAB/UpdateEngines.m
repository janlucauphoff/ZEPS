function UpdateEngines(p,nmin,nmax)
% UPDATEBATTERY configures the engines inside the ZEPS model
% Author: Jan Luca Uphoff
% Project: ZEPS
%   
% Inputs:
% - p: propeller factor
% - nmin: minimum threshold for engine activation
% - nmax: rpm limitation
%
% UPDATEENGINES(1.71150818e-4,600,1200)
% This usage example will configure the model with an engine following the
% law p*rpm^3. The activation threshold is set to 600 rpm and the
% limitation to 1200 rpm. 

mdl = 'ZEPS';
block = 'Engines/propeller function';
ID = [mdl, '/', block];

%% model manipulation
load_system(mdl)
set_param(ID + "/p", "Value", string(p));
set_param(ID + "/activation", "Threshold", string(nmin));
set_param(ID + "/limit", "UpperLimit", string(nmax));
save_system(mdl)
end