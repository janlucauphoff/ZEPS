function sun = get_solar_from_file(FROM, TO)
    load sun_irradiance.mat sun;
    dt = years(year(sun.Date(1)) - year(FROM));
    sun = sun(timerange(FROM+dt, TO+dt),:);
    sun.time = seconds(hours(1))*[0:height(sun)-1]';
end
