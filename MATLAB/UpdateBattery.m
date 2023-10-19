function [V_ref, Q_ref, N_ser, N_par] = UpdateBattery(name,V_set,Q_set,method, UpdateSimulink)
% UPDATEBATTERY configures the battery inside the ZEPS model
% Author: Jan Luca Uphoff
% Project: ZEPS
%   
% Inputs:
% - battery type from list: 'A48100R', 'EASy Marine', 'EASy Marine 100'
% - DC main network voltage
% - capacity in kWh
% - calculation method: 'round', 'floor'
%
% UPDATEBATTERY('A48100R', 800, 2e6, 'round')
% This usage example will configure the model with an 2MWh battery of type
% A48100R with a series voltage of ~800V.

% Battery database
switch name
    case 'A48100R' % AENTRON
        type = 'Lithium-Ion';
        responeTime = 0.1; % TODO
        nominalVoltage = 50.4;
        nominalCapacity = 203;
        maximumCapacity = 210;
        minimumVoltage = 42;
        fullVoltage = 56;
        dischargeRate = 300;
        
    case "EASy Marine"
        type = 'Lithium-Ion';
        responeTime = 0.1; % TODO
        nominalVoltage = 38.4;
        nominalCapacity = 80;
        maximumCapacity = 100;
        minimumVoltage = 30;
        fullVoltage = 42;
        dischargeRate = 80;
        
   case "EASy Marine 100"
        type = 'Lithium-Ion';
        responeTime = 0.1; % TODO
        nominalVoltage = 38.4;
        nominalCapacity = 100;
        maximumCapacity = 125;
        minimumVoltage = 30;
        fullVoltage = 42;
        dischargeRate = 50;
    otherwise
        disp("Error! Battery not found.")
end
% End of database

switch method
    case 'round'
        N_ser = round(V_set/nominalVoltage);
        N_par = round(Q_set/(N_ser*nominalVoltage*nominalCapacity));
    case 'floor'
        N_ser = floor(V_set/nominalVoltage);
        N_par = floor(Q_set/(N_ser*nominalVoltage*nominalCapacity));
    otherwise
        disp("Error! Method not defined.")
end


V_ref = N_ser*nominalVoltage;
Q_ref = N_par*N_ser*nominalVoltage*nominalCapacity;

if UpdateSimulink == true
    mdl = 'ZEPS';
    block = 'Battery';
    ID = [mdl, '/', block];

    %% model manipulation
    load_system(mdl)
    set_param(ID, "BatType", type);
    set_param(ID, "NomV", string(nominalVoltage)+"*"+string(N_ser));
    set_param(ID, "NomQ", string(nominalCapacity)+"*"+string(N_par));
    set_param(ID, "SOC", '90');
    set_param(ID, "Batt_Tr", string(responeTime));
    set_param(ID, "MaxQ", string(maximumCapacity)+"*"+string(N_par));
    set_param(ID, "MinV", string(minimumVoltage)+"*"+string(N_ser));
    set_param(ID, "FullV", string(fullVoltage)+"*"+string(N_ser));
    set_param(ID, "Dis_rate", string(dischargeRate)+"*"+string(N_par));
    set_param(ID, "Normal_OP", string(nominalCapacity)+"*"+string(N_par));
    set_param(ID, "expZone", "[" + string(fullVoltage*N_ser*0.95) + " " +  string(dischargeRate*N_par) + "]");
        
    save_system(mdl)
end
end
