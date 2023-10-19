function data = get_scenario(Scenario)
%% Function to get scenario specific data
% Author: Jan Luca Uphoff
% Project: ZEPS

load dataset data;
if nargin == 0
    Scenario = getVariable(get_param('ZEPS', 'modelWorkspace'),'scenario');
end

switch Scenario
    case 1
        FROM    = '05.07.2020 08:00:00';
        TO      = '10.07.2020 08:01:00';
    case 2
        FROM    = '12.07.2020 06:00:00';
        TO      = '12.07.2020 18:01:00';
    case 3
        FROM    = '13.07.2020 00:00:00';
        TO      = '27.07.2020 00:01:00';
    otherwise
        disp("Error, Scenario not existing.");
        return
end

%% return timetables
data = data(timerange(datetime(FROM, 'InputFormat', 'dd.MM.yyyy HH:mm:ss'),datetime(TO, 'InputFormat', 'dd.MM.yyyy HH:mm:ss')),:);
data.EpWh1min = data.EpWh1min-data.EpWh1min(1);
data.time = seconds(minutes(1))*[0:height(data)-1]';
end

