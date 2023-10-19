%% load data
data = get_scenario(1);
FROM = data.Date(1);
TO = data.Date(end);

%% Simulation time parameter
params.time.step = 60;
params.time.stop = seconds(days(20));
params.time.repeat = seconds(TO-FROM);

%% Motor parameter
params.motor.pmin = 50e3;
params.motor.pmax = 600e3;

params.motor.nmin = 500;
params.motor.nmax = 1600;

fx = linsolve(...   % assuming linear function y=ax+b
    [params.motor.nmin 1; params.motor.nmax 1,],...
    [params.motor.pmin; params.motor.pmax]...
    );  
params.motor.a = fx(1);
params.motor.b = fx(2);

%% PEM Fuel Cell parameter
params.pem.capacity = 2*12e3;
params.pem.delay = 20;

params.pem.EOC          = '[93.2 88]';    % Voltage at 0A and 1A
params.pem.NomIV        = '[160 65.5]';   % Nominal I and V
params.pem.EndIV        = '[230 58.9]';   % Maximum I, Minimum V
params.pem.N            = '96';           % Number of fuel cells
params.pem.NomEff       = '54';           % Stack Efficiency
params.pem.NomT         = '65';           % Operating Temperature
params.pem.MaxAirRate   = 732;
params.pem.NomAirRate   = string(params.pem.MaxAirRate * params.pem.NomIV(1) / params.pem.EndIV(1));
params.pem.NomPress     = '[1.225,1]';
params.pem.NomComp      = '[99.95,21,1]';

%% LI battery parameter
params.battery.threshhold = 1e3;
params.battery.capacity = 136;
params.battery.maxsoc = 0.8;
params.battery.minsoc = 0.2;
params.battery.initsoc = 0.6;
params.battery.charge = 1e3;
params.battery.power = inf;

%% network parameter
params.network.frequency = 50; % network frequency
params.network.efficiency = 0.9;

%% solar model parameter
params.solar.module.power = 0.220; %kW
params.solar.module.current = 7.48;
params.solar.module.voltage = 29.4;
params.solar.module.height = 1.660;
params.solar.module.width = 0.990;
params.solar.module.area = 1.6434;
params.solar.module.mass =  19; %kg

params.solar.area = 7.6* 62 * 0.4; % w x h x usage
params.solar.amount = floor(params.solar.area / params.solar.module.area);
params.solar.power = params.solar.amount * params.solar.module.power;

params.solar.year = 2016; % EU database only until 2016
params.solar.lat = 49.873;
params.solar.lon = 8.343;
params.solar.loss = 0.9;

% get_solar_online(params) % only after updates on upper parameters
solar = get_solar_from_file(data.Date(1),data.Date(end));

%% clear workspace variables
clearvars -except data params solar
