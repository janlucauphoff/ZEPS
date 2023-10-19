function UpdateFuelCell(name, N, usage)
% UPDATEFUELCELL configures the fuel cells inside the ZEPS model
% Author: Jan Luca Uphoff
% Project: ZEPS   
%
% Inputs:
% - name: Nedstack fuel cell type (NEDSTACK FCS 7-XXL,NEDSTACK FCS 10-XXL,NEDSTACK FCS 13-XXL
% - N: amount of fuel cell stacks
% - usage: usage during 12h
%
% UPDATEFUELCELLS('NEDSTACK FCS 10-XXL', 10, 0.25)
% This usage example will configure the model with 10x Nedstack FCS 10-XXL
% fuel stacks with a usage time of 3h/12h.

% Battery database
switch name
    case 'NEDSTACK FCS 13-XXL' 
        power = 13600;
        flowRate = 154; % Nl = Normliter
        
    case 'NEDSTACK FCS 10-XXL' 
        power = 10600;
        flowRate = 120;
        
    case 'NEDSTACK FCS 7-XXL' 
        power = 6800;
        flowRate = 77;
        
    otherwise
        disp("Error! Fuel cell not found.")
end
% End of database

mdl = 'ZEPS';
block = 'PEM fuel cell';
ID = [mdl, '/', block];

%% model manipulation
load_system(mdl)
set_param(ID + "/N", "Value", string(N));
set_param(ID + "/Normvolume", "Value", string(flowRate));
set_param(ID + "/usage", "Value", string(usage/100));
set_param(ID + "/Power", "Value", string(power));
save_system(mdl)
end
