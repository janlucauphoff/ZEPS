%% define parameters

lat = 49.873;
lon = 7.57833;
min_year = 2016;
max_year = 2016;
peakpower = 210;
loss = 14;

%% load dataset
BaseURL = 'https://re.jrc.ec.europa.eu/api/seriescalc?';
location = ['lat=' num2str(lat) '&lon=' num2str(lon) '&'];
param1 = ['startyear=' num2str(min_year) '&endyear=' num2str(max_year) '&'];
param2 = 'components=0&';
param3 = ['pvcalculation=1&peakpower=' num2str(peakpower) '&loss=' num2str(loss) '&'];
param4 = 'pvtechchoice=crystSi&mountingplace=free&';
output = 'outputformat=json';  
url = [BaseURL location param1 param2 param3 param4 output];

%%
options = weboptions('ContentType','json');
sun = webread(url, options);

%% create timetable 
% H_sun = hight as angle 
% G_i = irradiance

sun = struct2table(sun.outputs.hourly);
sun.time = datetime(sun.time,'InputFormat',"uuuuMMdd:HHmm");
sun = table2timetable(sun);
sun.time = sun.time - minutes(10);
sun = sun(:,1:4);
sun.time.Format = 'dd.MM.yyyy HH:mm:ss';
sun.Properties.DimensionNames(1) = "Date";
sun.Properties.VariableNames = {'power' 'irradiance' 'sun' 'temperature'};

%% save dataset
save('sun_irradiance', 'sun');
clearvars -except sun
