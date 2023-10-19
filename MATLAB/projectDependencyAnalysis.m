prj = openProject('ZEPS.prj');
dep = {'MATLAB','Simscape Electrical','Simulink'}; % minimum dependencies

%% check dependencies of project files
for i = 1:length(prj.Files)
    disp(prj.Files(i).Path);
    if ~all(ismember(d,dep))
        d = dependencies.toolboxDependencyAnalysis(prj.Files(i).Path);
        disp(d);
    end
end
