function all_depth=depths_hist(root_dir)

if ~unempty_exist('root_dir')
    root_dir='G:\users\ream\Prut\Ctx-Thal\data\HugoData-CtxThl';
end

sessions = dir(root_dir);
all_depth=[];
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
    fprintf('Accessing session %g, ',DDFparam.ID)
    MrgEd_base_name=[MAT_base_name(1) num2str(DDFparam.ID)];
%     if any(strcmp(MAT_base_name,{'h040210','h050210'}));
%         keyboard
%     end
    for i_ss=1:length(SESSparam.SubSess)
        fprintf('\nsubsession %g,',i_ss);
        for i_file=SESSparam.SubSess(i_ss).Files(1):SESSparam.SubSess(i_ss).Files(2)
            if isfield(SESSparam.SubSess(i_ss),'Electrode')
                for elect=1:length(SESSparam.SubSess(i_ss).Electrode)
                    fprintf('elec. %g',elect);
                    all_depth=[all_depth; SESSparam.SubSess(i_ss).Electrode(elect).Depth];
                end
            elseif isfield(SESSparam.SubSess(i_ss),'SL')
                flds1={'SL','SR'};
                flds2={'SpinalLeft','SpinalRight'};
                
                for elect=1:2
                    try
                        all_depth=[all_depth; SESSparam.SubSess(i_ss).(flds1{elect}).Depth-DDFparam.(flds2{elect}).Cell1st];
                    end
                end
                
            else 
                fprintf('Could not find relevant fields in session #%g, subsession #%g\n', DDFparam.ID, i_ss);
            end
            
        end %for i_file = ...
        
        %call is_resp_site
        
        %db_file(correct location)=resp_index
        
    end %for i_ss = ...
    fprintf \n
end

hist(all_depth)
end
