%% Tank Volumen:
p = 300e5;
V = 50e-3;
Rs = 4124; 
T = 293; %°C
N = 12;
m1 = p*V/(Rs*T) * 12 % kg

%% Norm flow DIN 1343
V = 154e-3;
T = 273.15; 
p = 101325;
Rs = 4124; 
m2 = p*V/(Rs*T) % kg

%% Norm flow ISO 2533
V = 154e-3;
T = 288.15; 
p = 101325;
Rs = 4124; 
m3 = p*V/(Rs*T) % kg

%% Norm flow ISO 6358
V = 154e-3;
T = 293.15; 
p = 1e5;
Rs = 4124; 
m4 = p*V/(Rs*T) % kg

%%
m1/m2/60
m1/m3/60
m1/m4/60