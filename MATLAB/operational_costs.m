%% variable definition
load ZEPS_results.mat;
pricekwh = 0.3;
cruiseweeks = 26;
hotelweeks = 6;
pricehydrogen = 5.32;

%% Operational costs as-is
diesel = 55;                                        % 55.000€ in 2018
electricity = 13;                                   % 13.000€, 500€ per week
freshwater = @(N,T) round(100*N*T*0.005 / 1000,1);  % 100L / per person per day @ 5€/m3

costs1 = [...
    freshwater(62, 7*26);
    electricity;
    round(optHarbour.LoadE.Data(end,1) * pricekwh * hotelweeks/2 / 1000,1); % hotel services only
    freshwater(30, 7*6);
    diesel]

%% Operational costs rebuild
electricity = round([...
    optCruise.SourceE.Data(end,end-1) - optCruise.LoadE.Data(end,end-1);
    minCruise.SourceE.Data(end,end-1) - minCruise.LoadE.Data(end,end-1);
    recCruise.SourceE.Data(end,end-1) - recCruise.LoadE.Data(end,end-1);
    ] * pricekwh * cruiseweeks / 1000,0);

hydrogen = round([...
    optCruise.Fuel.Data;
    minCruise.Fuel.Data;
    recCruise.Fuel.Data;
    ]  * pricehydrogen * cruiseweeks / 1000,1);

electricity_hotel = round([...
    (optHarbour.SourceE.Data(end,end-1) - optHarbour.LoadE.Data(end,end-1));
    (minHarbour.SourceE.Data(end,end-1) - minHarbour.LoadE.Data(end,end-1));
    (recHarbour.SourceE.Data(end,end-1) - recHarbour.LoadE.Data(end,end-1));
    ] * pricekwh * hotelweeks/2 / 1000,1);

watertreatment = [10, 10, 10]; % Annual costs for water tratment system

costs2 = [electricity';hydrogen';electricity_hotel'; watertreatment]

%% Total costs
total = [sum(costs1),sum(costs2)]
