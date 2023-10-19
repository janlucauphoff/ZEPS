function UpdateSystem(system, value)
% Function to update static simulation values
% Author: Jan Luca Uphoff
% Project: ZEPS

mdl = 'ZEPS';
load_system(mdl)

switch system
    case 'Fresh Water'
        subsystem = "/Fresh Water/Power";
        param = 'Value';
        set_param(mdl+subsystem, param, string(value))
    case 'Waste Water'
        subsystem = "/Waste Water/Power";
        param = 'Value';
        set_param(mdl+subsystem, param, string(value))
    case 'RPM threshold'
        subsystem = "/Engines/Motorfunction/Switch";
        param = 'Threshold';
        set_param(mdl+subsystem, param, string(value))
    case 'Converter'
        sys = find_system('ZEPS', 'BlockType','SubSystem');
        sys = sys(contains(sys, 'AC converter simple'));
        for i = 1:length(sys)
            subsystem = string(sys(i));
            param = 'eff';
            set_param(subsystem, param, string(value))
        end 
    otherwise
        disp('Error! System not found.')
end


save_system(mdl)
end