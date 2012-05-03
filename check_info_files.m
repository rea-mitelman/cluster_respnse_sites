function check_info_files
clc
root_dir='G:\users\ream\Prut\Ctx-Thal\data\HugoData-CtxThl\';
sessions = dir([root_dir '\h*']);
for i_sess=1:length(sessions)
    if ~sessions(i_sess).isdir || sessions(i_sess).name(1)=='.'
        continue
    end
    [SESSparam, DDFparam, MAT_base_name, curr_MrgEd_dir, curr_mat_dir]=get_info(root_dir, sessions(i_sess).name);
    MrgEd_base_name=[MAT_base_name(1) num2str(DDFparam.ID)];
    if isfield(DDFparam,'Electrode')
        continue
    end

    fprintf('Session #%g\n===========\n',DDFparam.ID)
    for i_ss=1:length(SESSparam.SubSess)
        fprintf('Subsessio #%g\n-------------\n',i_ss)
        first_file=SESSparam.SubSess(i_ss).Files(1);
        [MrgEd_filename,wvf_filename,bhv_filename] = ...
            get_load_filenames(curr_MrgEd_dir,MrgEd_base_name,i_ss,first_file,curr_mat_dir,MAT_base_name, first_file);
        load(wvf_filename,'Unit*');
        
        elecs=1:2;
        elec_fields={'SR','SL'}; %according to the pages, Unit1 is right and Unit2 is left
        elec_glob_fields={'SpinalRight','SpinalLeft'};
        for elec=elecs
            prob=false;
            if exist(['Unit' num2str(elec)],'var')
                fprintf('Data for unit %g exists, this should be %s\n', elec, elec_glob_fields{elec})
            else
                fprintf('Could not find data for unit %g , this should be %s\n', elec, elec_glob_fields{elec})
                prob=true;
            end
            
            try
                fprintf('Depth for this electrode is %g\n',SESSparam.SubSess(i_ss).(elec_fields{elec}).Depth)
            catch
                disp('could not find depth of this electrode')
                prob=true;
            end
            
            try
                fprintf('Entry depth for this electrod is %g\n', DDFparam.(elec_glob_fields{elec}).Cell1st);
            catch
                disp('could not find endty depth of this electrode')
                prob=true;
            end
            fprintf \n
            if prob
                keyboard
            end
        end %                for elec=1:elecs
        clear Unit*
    end
end %for i_file = ...

    
