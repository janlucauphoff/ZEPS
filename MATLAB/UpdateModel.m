function UpdateModel(mdl)
% Function to update the model and the workspace variables
% Author: Jan Luca Uphoff
% Project: ZEPS

mdlWks = get_param(mdl, 'ModelWorkspace');

scenario = getVariable(mdlWks,'scenario');
data = get_scenario(scenario);

set_param(mdl,'SimulationCommand','Update')
disp("Model update successful");
end