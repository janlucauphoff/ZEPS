%%
load ZEPS_results.mat;
%%

close all;

colormap = {'finnja1','finnja2','finnja3','finnja4'};
colormap = {'finnja3'};
for i=1:length(colormap)
    color = colormap{i};
    switch color
        case 'system'
        % system
        SourceColors = [...
            0,      1,      0;      % Fuel Cell
            1,      165/256,0;      % Solar
            0.06,   1,      1;      % Wind
            1,      0,      1;      % Battery
            ];

        LoadColors = [...
            0.72,   0.27,   1;      % Hotel Services
            1,      0.41,   0.16;   % Bow Thruster
            0,      1,      1;      % Fresh Water
            0.93,   0.69,   0.13;   % Waste Water
            1,      0,      0;      % Engines
            1,      0,      1;      % Battery
            ];

        case 'hanna'
        % hanna
        SourceColors = [...
            181, 75, 190;           % Fuel Cell
            207, 117, 56;           % Solar
            119, 238,248;           % Wind
            71, 151, 76;            % Battery
            ]/256;

        LoadColors = [...
            32, 26, 159;            % Hotel Services
            112, 219, 89;           % Bow Thruster
            55, 111, 227;           % Fresh Water
            77, 48, 52;             % Waste Water
            185,47, 75;             % Engines
            71, 151, 76;            % Battery
            ]/256;

        case 'finnja1'
        % finnja 1 
        SourceColors = [...
            175 49 255;     % Fuel Cell
            253 124 8;      % Solar
            95 199 36;      % Wind
            198 0 7;        % Battery
            ]/256;

        LoadColors = [...
            181 1 113;      % Hotel Services
            32 80 25;       % Bow Thruster
            0 0 148;        % Fresh Water
            15 116 141;     % Waste Water
            25 196 255;     % Engines
            198 0 7;        % Battery
            ]/256;

        case 'finnja2'
        % finnja 2
        SourceColors = [...
            175 49 255;     % Fuel Cell
            253 124 8;      % Solar
            25 196 255;     % Wind
            198 0 7;        % Battery
            ]/256;

        LoadColors = [...
            181 1 113;      % Hotel Services
            32 80 25;       % Bow Thruster
            0 0 148;        % Fresh Water
            15 116 141;     % Waste Water
            95 199 36;      % Engines
            198 0 7;        % Battery
            ]/256;

        case 'finnja3'
        % finnja 3
        SourceColors = [...
            175 49 255;     % Fuel Cell
            253 124 8;      % Solar
            25 196 255;     % Wind
            95 199 36;      % Battery
            ]/256;

        LoadColors = [...
            181 1 113;      % Hotel Services
            32 80 25;       % Bow Thruster
            0 0 148;        % Fresh Water
            15 116 141;     % Waste Water
            198 0 7;        % Engines
            95 199 36;      % Battery
            ]/256;

        case 'finnja4'
        % finnja 4
        SourceColors = [...
            175 49 255;     % Fuel Cell
            253 124 8;      % Solar
            95 199 36;      % Wind
            25 196 255;     % Battery
            ]/256;

        LoadColors = [...
            181 1 113;      % Hotel Services
            32 80 25;       % Bow Thruster
            0 0 148;        % Fresh Water
            15 116 141;     % Waste Water
            198 0 7;        % Engines
            25 196 255;     % Battery
            ]/256; 
    end
    cm = [SourceColors;LoadColors];
    %get_scopes(optTransfer, '11101',false,cm)
    get_scopes(recCruise, '11101',false,cm)
end
%%




