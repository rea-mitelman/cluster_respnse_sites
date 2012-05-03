function all_resp = build_resp_site_db(root_dir, db_file)
stim_amp=150;
depth_thresh=10;
do_plot=false;
bin_dur=0.2;%bin duration in ms
resp_dur=[-20,100];%[time_begin time_end] of the response vector, in ms
do_mean=false;%do_mean==true => use median and MAD indtead of mean and STD
if ~unempty_exist('root_dir')
    root_dir='G:\users\ream\Prut\Ctx-Thal\data\HugoData-CtxThl';
end
% function build_resp_site_db
% this function builds a data base of all sub-session of all electrodes, and
% calculate their responsiveness to SCP stimulation
all_depths=[];
sessions = dir(root_dir);
all_resp.ctx=[];all_resp.thal=[];
counter.ctx=1;counter.thal=1;
all_resp_id.ctx=[];all_resp_id.thal=[];
for i_sess=1:length(sessions)
    if ~sessions(i_sess).isdir
        continue
    end
    
    %get info file data
    [SESSparam, DDFparam, MAT_base_name, curr_MrgEd_dir, curr_mat_dir]=get_info(root_dir, sessions(i_sess).name);
    
    if isempty(SESSparam)
        continue
    end
    
    
    %find the relevant raw data directory
    MrgEd_base_name=[MAT_base_name(1) num2str(DDFparam.ID)];
    
    for i_ss=1:length(SESSparam.SubSess)
        all_files=SESSparam.SubSess(i_ss).Files(1):SESSparam.SubSess(i_ss).Files(2);
        try
            stim_files=getfilenums(SESSparam.SubSess(i_ss));
        catch
            stim_files=all_files;
        end
        
        for i_file=stim_files
            ii = find(i_file==all_files);
            clear AMstim AMstim_on StimTime Unit*
            [MrgEd_filename,wvf_filename,bhv_filename] = ...
                get_load_filenames(curr_MrgEd_dir,MrgEd_base_name,i_ss,i_file,curr_mat_dir,MAT_base_name, i_file);
            load(wvf_filename,'Unit*'); load(bhv_filename,'*tim*');
            
            stim_times = get_stim_times;
            
            if isempty(stim_times), continue, end
            max_stim_amp = max(SESSparam.SubSess(i_ss).GlobalStim.AmpMat);
            if isfield(SESSparam.SubSess(i_ss),'GlobalStim') && isfield(SESSparam.SubSess(i_ss).GlobalStim,'AmpMat') &&...
                    ~isempty(SESSparam.SubSess(i_ss).GlobalStim.AmpMat) && SESSparam.SubSess(i_ss).GlobalStim.AmpMat(ii)==max_stim_amp && max_stim_amp>=stim_amp
                
                if isfield(DDFparam,'Electrode')
                    elecs=1:length(DDFparam.Electrode);
                    four_elec=true;
                else
                    elecs=1:2;
                    elec_fields={'SR','SL'}; %according to the pages, Unit1 is right and Unit2 is left
                    elec_glob_fields={'SpinalRight','SpinalLeft'};
                    four_elec=false;
                end
                
                for elec=elecs
                    %                     if four_elec && ~DDFparam.Electrode(elec).InUse, continue, end
                    
                    if four_elec
                        [resp_vec,t] = get_resp_vec_fast(eval(DDFparam.Electrode(elec).Channel), ...
                            eval([DDFparam.Electrode(elec).Channel '_KHz']), stim_times, bin_dur,resp_dur,do_mean);
                    else
                        if ~exist(['Unit' num2str(elec)],'var')
                            continue
                        end
                        resp_vec = get_resp_vec_fast(eval(['Unit' num2str(elec)]), ...
                            eval(['Unit' num2str(elec) '_KHz']), stim_times,bin_dur,resp_dur,do_mean);
                    end
                    
                    if any(isnan(resp_vec))
                        disp('Warning, NaNs in the response vector')
                        beep
                        keyboard
                    end
                    if do_plot
                        v=resp_vec;
                        v(-2<t & t<1)=NaN;
                        plot(t,v);
                        suptitle(sprintf('Session: %1.0f, Subsession: %1.0f, File: %1.0f, Electrode %1.0f, Depth=%1.3f', ...
                            DDFparam.ID, i_ss, i_file, elec,SESSparam.SubSess(i_ss).Electrode(elec).Depth));
                    end
                    
                    if four_elec
                        this_depth=SESSparam.SubSess(i_ss).Electrode(elec).Depth ;
                        all_depths=[all_depths this_depth];
                        if  this_depth < depth_thresh
                            loc='ctx';
                        else
                            loc='thal';
                        end
                    else
                        try
                            this_depth = SESSparam.SubSess(i_ss).(elec_fields{elec}).Depth - DDFparam.(elec_glob_fields{elec}).Cell1st;
                            
                        catch
                            this_depth=NaN;
                            disp('Warning, probably single electrode session with discrepancy, session ignored')
                            beep
                            keyboard
                        end
                        if this_depth < depth_thresh
                            loc='ctx';
                        elseif this_depth >= depth_thresh
                            loc='thal';
                        end
                        
                    end %if four_elec
                    %                     all_resp.(loc)=[all_resp.(loc),resp_vec];
                    all_resp.(loc)(:,counter.(loc))=resp_vec;
                    all_resp_id.(loc)(counter.(loc)).ed_file=MrgEd_filename;
                    all_resp_id.(loc)(counter.(loc)).ss=i_ss;
                    counter.(loc)=counter.(loc)+1;

                    %                     pause
                end %                for elec=1:elecs

            end
        end %for i_file = ...
            
            %call is_resp_site
            
            %db_file(correct location)=resp_index
            
    end %for i_ss = ...
        
end
if do_mean
    save test_resp all_resp t
else
    save test_resp_med all_resp all_resp_id t
end


% calc. stim. locs:

clear all;
% dat.mean=load('test_resp.mat');
% dat.med=load('test_resp_med.mat');
load('test_resp_med.mat');
% mm={'med'};
locs={'thal','ctx'};
% t=dat.med.t;
d=3;
K=3;
cols='kmcrgby';
for l=1:2
%     clear St
    %     dat_mat = dat.med.all_resp.(locs{l});
    dat_mat = all_resp.(locs{l});
    dat_mat(t>-2 & t<1.1,:)=0;
    [U,~,V] = svds(dat_mat,d);
    
    %         IDX=kmeans(V(:,1:2),2);
    [~,ix_sort]=sort(abs(V));
    %         V_sort=V(ix_sort);
    %         St.mu=([zeros(1,d);V_sort(end,:)]);
    %         St.Sigma(:,:,1)=cov(V_sort(1:end/2,:));
    %         St.Sigma(:,:,2)=cov(V_sort(end/2+1:end,:));
    %         St.PComponent=
    %         obj = gmdistribution.fit(V,K,'Start',St);
    opts_obj.MaxIter=200;
    obj = gmdistribution.fit(V,K,'Replicates',2000,'Options',opts_obj);
    
    IDX = cluster(obj,V);
    clf
    subplot(2,2,1)
    hold on
    [~,sort_clust_ixs]=sort(sum(obj.mu.^2,2).^.5);
    sort_clust_ixs=sort_clust_ixs';
    for j=1:K
        kk=sort_clust_ixs(j);
        if d>=3
            plot3(V(IDX==kk,1),V(IDX==kk,2),V(IDX==kk,3),['.' cols(j)]);
        elseif d==2
            plot(V(IDX==kk,1),V(IDX==kk,2),['.' cols(j)]);
        else
            plot(ones(sum(IDX==kk),1),V(IDX==kk),['.' cols(j)]);
        end
    end
    title('Projection on PCs, sorted by EM')
    subplot(2,2,3)
    plot(t,U)
    xlabel('Time (msec)')
    title('PCs')
    legend(num2cell(num2str([1:d]')))
    %         suptitle(sprintf('%s activity in %s, %g clusters based on %g PCs',med,locs{l},K,d));
    for j=1:K
        kk=sort_clust_ixs(j);
        subplot(K,2,2*j)
        %             this_mat=dat_mat(:,IDX==j);
        %             this_mat=repmat(2*[0:size(this_mat,2)-1],size(this_mat,1),1)+this_mat;
        %             plot(t,this_mat)
        %             ylim([-inf inf])
        plot(t,dat_mat(:,IDX==kk),cols(j))
        
        if j==1
            tit='Clustered as non-responsive';
        else
            tit=sprintf('Clustered as type %g response',j-1);
        end
        title(sprintf('%s, %g sites',tit,sum(IDX==kk)))
        ylabel('# MADs from Median')
        if j==K
            xlabel('Time (msec)')
        end
    end
    
    keyboard
    %         [U,S,V]=svds(dat_mat,25);
    %         figure
    %         for pc=1:25
    %             subplot(5,5,pc)
    %             hist(sum(abs(V(:,1:pc)),2),100);
    %             title(num2str(pc))
    %         end
end


%% now, run over all the sites, and save in each of the correct data file the correct response index (responsive / not responsive)



