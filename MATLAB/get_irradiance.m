function sun = get_irradiance(peakpower, loss, date)
%% Function to communicate with EU PV irradiance database
% Author: Jan Luca Uphoff
% Project: ZEPS

lat = 50.008000; %Mainz
lon = 8.275000;
min_year = 2016;
max_year = 2016;

%% load dataset
BaseURL = 'https://re.jrc.ec.europa.eu/api/seriescalc?';
location = ['lat=' num2str(lat) '&lon=' num2str(lon) '&'];
param1 = ['startyear=' num2str(min_year) '&endyear=' num2str(max_year) '&'];
param2 = 'components=0&';
param3 = ['pvcalculation=1&peakpower=' num2str(peakpower) '&loss=' num2str(loss) '&'];
param4 = 'pvtechchoice=crystSi&mountingplace=free&';
output = 'outputformat=json';  
url = [BaseURL location param1 param2 param3 param4 output];
%disp(url)
options = weboptions('ContentType','json');
sun = webread(url, options);

%% create timetable 
% H_sun = hight as angle 
% G_i = irradiance

sun = struct2table(sun.outputs.hourly);
sun.time = datetime(sun.time,'InputFormat',"uuuuMMdd:HHmm");
sun = table2timetable(sun);
sun = sun(:,1:5);
sun.time.Format = 'dd.MM.yyyy HH:mm:ss';
sun.Properties.DimensionNames(1) = "Date";
sun.Properties.VariableNames = {'power' 'irradiance' 'sun' 'temperature' 'windspeed'};
sun = sun(sun.Date>date,:);
%sun = retime(sun, "minutely", "pchip");
sun.time = [0:height(sun)-1]'*3600;
end

