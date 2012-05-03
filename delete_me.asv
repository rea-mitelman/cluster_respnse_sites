%%
stim_config='mono';
stim_files=[];
for i_file=all_files
    if SESSparam.fileConfig(i_file).SCPStim && SESSparam.fileConfig(i_file).SCPStimAmp==stim_amp && ...
            ~isempty(findstr(SESSparam.fileConfig(i_file).SCPConfig,stim_config))
        stim_files=[stim_files i_file];
    end
end

%%