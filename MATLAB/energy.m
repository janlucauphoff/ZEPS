clear;
load ZEPS_results.mat;
names = whos;

%%
t = [];
e = [];
levelFuel = [];
levelBat = [];
hydrogen = [];
t_fuel = [];
p = [];
n = [];

for i=1:length(names)
    name = names(i).name;
    out = eval(name);
    t = [t, hours(seconds(out.tout(end)))];
    e = [e, round(out.LoadE.Data(end,end)/1000,2)];
    levelFuel = [levelFuel, round(out.Power{1}.Values.Data(end,1))];
    levelBat = [levelBat, round(out.Power{1}.Values.Data(end,2))];
    hydrogen = [hydrogen, round(out.Fuel.Data)];
    a = find(out.Power{1}.Values.Data(:,1) <= 0,1);
    if ~isempty(a)
        t_fuel = [t_fuel, hours(seconds(out.tout(a)))];
    else
        t_fuel = [t_fuel, hours(seconds(out.tout(end)))];
    end
end

T1 = struct2table(names);
T = table(T1.name, t',e',levelFuel',levelBat',hydrogen', t_fuel',...
    'VariableNames',{'Simulation', 'T', 'Energy', 'Fuel level', 'Battery level', 'Hydrogen', 'Out of fuel'});

%% comparison Cruise
T_cruise = T([1,5,8],:);
T_cruise.T = [];
T_cruise.("Out of fuel") = []
%%
load = round([optCruise.LoadE.Data(end,:);minCruise.LoadE.Data(end,:);recCruise.LoadE.Data(end,:)]/1000,2);

E_Cruise = array2table(load, 'VariableNames', {'Hotel Services','Bow Thruster','Fresh Water','Waste Water','Engines','Battery charger', 'Total'});

%% Cost estimation
c = [4.8e6 0.72e6 2.4e6; 0.45e6 0.35e6 0.45e6; 0.54e6 0.42e6 0.53e6; 0.25e6 0.25e6 0.25e6; 0.09e6 0.052e6 0.075e6; 0.15e6, 0.15e6, 0.15e6; 0.25e6, 0.25e6, 0.25e6; 0.075e6, 0.075e6, 0.075e6]


%%

