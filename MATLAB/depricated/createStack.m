function createStack(parent, name, N)
    run('sim_initial_values.m');

    sys = parent + "/" + name;
    open_system(parent);

    %%
    add_block('built-in/Subsystem',sys);

    add_block('powerlib/powergui',sys+"/powergui");
    set_param(sys+"/powergui",'position',[75 30 155 70]);

    add_block('powerlib/Electrical Sources/Controlled Current Source',sys+"/Load");
    set_param(sys+"/Load",'position',[410   190   446   235]);

    %add_block('dspswit3/Counter',sys+"/Counter");
    %set_param(sys+"/Counter",'position',[115   170   185   230]);

    add_block('simulink/Math Operations/Add',sys+"/add");
    set_param(sys+"/add","Position", [645   300   675   300+N*20]);
    set_param(sys+"/add","Inputs", repmat('+',1,N));

    add_block('simulink/Commonly Used Blocks/In1',sys+"/N");
    set_param(sys+"/N","Position", [45   228    75   242]);

    add_block('simulink/Commonly Used Blocks/In1',sys+"/P");
    set_param(sys+"/P","Position", [45   173    75   187]);

    add_block('simulink/Commonly Used Blocks/Out1',sys+"/V");
    set_param(sys+"/V","Position", [725   278   755   292]);

    add_block('simulink/Commonly Used Blocks/Out1',sys+"/I");
    set_param(sys+"/I","Position", [725   303   755   317]);

    hAdd = get_param(sys+"/add",'PortHandles');
    hSource = get_param(sys+"/Load",'PortHandles');
    %hCounter = get_param(sys+"/Counter",'PortHandles');
    hInput1 = get_param(sys+"/N",'PortHandles');
    hInput2 = get_param(sys+"/P",'PortHandles');
    hOutput1 = get_param(sys+"/V",'PortHandles');
    hOutput2 = get_param(sys+"/I",'PortHandles');

    % wiederholbar
    for i = 1:N
    x = 45;
    y = 80+i*200;
    w = 140;
    h = 130;
    stack = append(sys, '/Stack', string(i));
    breaker = append(sys,'/Breaker', string(i));
    comparator = append(sys,'/Compare', string(i));
    selector = append(sys,'/Selector', string(i));

    % Configure Fuel Cell Stack
    add_block('electricdrivelib/Extra Sources/Fuel Cell Stack',stack);
    set_param(stack,'position',[x   y   x+w   y+h]);
    set_param(stack,'PresetModel', 'No (User-Defined)');

    set_param(stack, 'Eoc', params.pem.EOC);
    set_param(stack, 'NomVI', params.pem.NomIV);
    set_param(stack, 'EndVI', params.pem.EndIV);
    set_param(stack,'Nc', params.pem.N,'n', params.pem.NomEff,'TOp', params.pem.NomT,'AirFr', params.pem.NomAirRate,'SuppPress', params.pem.NomPress,'Comp', params.pem.NomComp);

    set_param(stack, 'FlowRateH2', 'off')
    set_param(stack, 'FlowRateAir', 'off')
    set_param(stack, 'systemTemp', 'off')
    set_param(stack, 'systemPH2', 'off')
    set_param(stack, 'systemPAir', 'off')


    add_block('powerlib/Elements/Breaker', breaker);
    set_param(breaker,'position',[350   y+27   410   y+78]);

    add_block('simulink/Logic and Bit Operations/Compare To Constant', comparator)
    set_param(comparator,'position',[270   y+25   300   y+55]);
    set_param(comparator,'const', string(i));
    set_param(comparator,'relop', '>=');

    add_block('simulink/Commonly Used Blocks/Bus Selector',selector);
    set_param(selector,'position',[500   y   505   y+40]);
    set_param(selector,'OutputSignals', 'Voltage,Current,Stack Efficiency (%)');

    hStackNew = get_param(stack,'PortHandles');
    hBreaker = get_param(breaker,'PortHandles');
    hCompare = get_param(comparator,'PortHandles');
    hSelector = get_param(selector,'PortHandles');

    add_line(sys,hCompare.Outport(1),hBreaker.Inport(1),'autorouting','on');
    add_line(sys,hInput1.Outport(1),hCompare.Inport(1),'autorouting','on');
    add_line(sys,hStackNew.Outport(1),hSelector.Inport(1),'autorouting','on');
    add_line(sys,hSelector.Outport(2),hAdd.Inport(i),'autorouting','on');
    if i==1
        add_line(sys,hSelector.Outport(1),hOutput1.Inport(1),'autorouting','on');
    end

    add_line(sys,hStackNew.RConn(1),hBreaker.LConn(1),'autorouting','on');
    add_line(sys,hBreaker.RConn(1),hSource.RConn(1),'autorouting','on');
    add_line(sys,hStackNew.RConn(2),hSource.LConn(1),'autorouting','on');
    end
    %%
    add_line(sys,hInput2.Outport(1),hSource.Inport(1),'autorouting','on');
    %add_line(sys,hLoad.Inport(1),hOutput1.Inport(1),'autorouting','on');
    add_line(sys,hAdd.Outport(1),hOutput2.Inport(1),'autorouting','on');
end









