function [e,cnfig]=getfilenums_localstim(subsess_param)
e=[];
elec=[];
if ~isfield(subsess_param,'Electrode')
        cnfig=[];
        return
end

for ii=1:length(subsess_param.Electrode)
    if subsess_param.Electrode(ii).Stim.Flag
        e=[e subsess_param.Files(1):subsess_param.Files(2)];
        elec=[elec ii];
    end
end
e=unique(e);
if ~isempty(e)
    cnfig=[' Local stim at elec(s) ' num2str(elec)];
else
    cnfig=[];
end