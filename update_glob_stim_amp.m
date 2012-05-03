function update_glob_stim_amp(root_dir,auto_skip_flag)
% updates the info files to include the amplitude of the SCP stimuli, by
% manual input.
if ~unempty_exist('root_dir')
    root_dir='G:\users\ream\Prut\Ctx-Thal\data\HugoData-CtxThl';
end

if ~unempty_exist('auto_skip_flag')
    auto_skip_flag=true;
end

% function build_resp_site_db
% this function builds a data base of all sub-session of all electrodes, and
% calculate their responsiveness to SCP stimulation

sessions = dir(root_dir);
clc
for i_sess=1:length(sessions)
    if ~sessions(i_sess).isdir
        continue
    end
    
    %get info file data
    [SESSparam, DDFparam, MAT_base_name, curr_MrgEd_dir, curr_mat_dir, Info_fullfilename]=get_info(root_dir, sessions(i_sess).name);
    
    if isempty(SESSparam)
        continue
    end
    
    
    %find the relevant raw data directory
    MrgEd_base_name=[MAT_base_name(1) num2str(DDFparam.ID)];
%     if any(strcmp(MAT_base_name,{'h040210','h050210'}));
%         keyboard
%     end
    for i_ss=1:length(SESSparam.SubSess)
        try
            stim_files=getfilenums(SESSparam.SubSess(i_ss));
        catch
            stim_files=SESSparam.SubSess(i_ss).Files(1):SESSparam.SubSess(i_ss).Files(2);
        end
        fprintf \n
        for i_file=stim_files
            clear AMstim AMstim_on StimTime
            [MrgEd_filename,wvf_filename,bhv_filename] = ...
                get_load_filenames(curr_MrgEd_dir,MrgEd_base_name,i_ss,i_file,curr_mat_dir,MAT_base_name, i_file);
%             load(wvf_filename,'Unit*'); 
            load(bhv_filename,'*tim*');
            
            stim_times = get_stim_times;
            
            if isempty(stim_times), continue, end   
            fprintf('Session name: %s (#%g), subsession %g, file #%g\n',sessions(i_sess).name, DDFparam.ID, i_ss,i_file)

            update_flag=true;
            if ~isfield(SESSparam.SubSess(i_ss),'GlobalStim') || ~isfield(SESSparam.SubSess(i_ss).GlobalStim, 'Amp') || isempty(SESSparam.SubSess(i_ss).GlobalStim.Amp)
                disp('Stimulation "Amp" field is empty or non existing')
            else
                fprintf('Stimulus "Amp" field equals %g\n',SESSparam.SubSess(i_ss).GlobalStim.Amp)
            end
            
            if isfield(SESSparam.SubSess(i_ss),'GlobalStim')
                if isfield(SESSparam.SubSess(i_ss).GlobalStim,'AmpMat') && length(SESSparam.SubSess(i_ss).GlobalStim.AmpMat) >= i_file
                    fprintf('Current amplitude matrix shows the amplitude is %g. ',SESSparam.SubSess(i_ss).GlobalStim.AmpMat(i_file));
                    if ~auto_skip_flag
                        yn=input('Update current value?\n','s');
                        if strcmpi(yn,'n')
                            update_flag=false;
                        end
                    else
                        fprintf('Skipping update automatically.\n')
                        update_flag=false;
                        
                    end
                end
            else
                fprintf('the variable SESSparam.SubSess(%g) does not have the field GlobalStim. It is being created.\n',i_ss)
            end 
            if update_flag
                SESSparam.SubSess(i_ss).GlobalStim.AmpMat(i_file)=input('Please insert amplitude value, in µAmp\n');
            end

        end %for i_file = ...
        
        %call is_resp_site
        
        %db_file(correct location)=resp_index
        
    end %for i_ss = ...
    fprintf('saving SESSparam to file %s\n\n',Info_fullfilename);
    save(Info_fullfilename,'SESSparam','-append')
    
end

end
