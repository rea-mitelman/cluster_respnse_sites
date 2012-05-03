function update_glob_stim_amp_patch(root_dir)
% updates the info file to include the SCP stimulus in a way that can be
% read by build_resp_site_db, after it was already inputted by the user
% with the function update_glob_stim_amp


if ~unempty_exist('root_dir')
    root_dir='G:\users\ream\Prut\Ctx-Thal\data\HugoData-CtxThl';
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
        files=SESSparam.SubSess(i_ss).Files(1):SESSparam.SubSess(i_ss).Files(2);
        
        fprintf \n
        if ~isfield(SESSparam.SubSess(i_ss).GlobalStim,'AmpMat'), continue, end
        stim_amp_old=SESSparam.SubSess(i_ss).GlobalStim.AmpMat;
        SESSparam.SubSess(i_ss).GlobalStim.AmpMat=[];
        for i_file=1:length(files)
            this_file=files(i_file);
            if length(stim_amp_old)>=this_file
                SESSparam.SubSess(i_ss).GlobalStim.AmpMat(i_file)=stim_amp_old(this_file);
            else
                SESSparam.SubSess(i_ss).GlobalStim.AmpMat(i_file)=0;
            end
        end %for i_file = ...
        clear stim_amp_old
        
    end %for i_ss = ...
    fprintf('saving SESSparam to file %s\n\n',Info_fullfilename);
%     keyboard
    save(Info_fullfilename,'SESSparam','-append')
    
end

end
