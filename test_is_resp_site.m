function [rsp_flag, rsp_p] = test_is_resp_site(raw_sig, Fs, stim_times, high_pass, low_pass)
do_plot=true;
org_art_dur=1;
dead_time=0.0;

% check different frequencies (both high and low pass)
% check at a "best typical" case
% compare with std (/mad) prior to stim
% mean? median?
% plot some quantifier's values over all sites

clean_sig=remove_stim_artifact(raw_sig,Fs,stim_times,org_art_dur,dead_time);
order=8;
dec_fact=5;

highpass_sig = highpass_butter_filt(clean_sig,high_pass,Fs, order);

rect_sig = abs(highpass_sig);

rect_sig=rect_sig-mean(rect_sig);

lowpass_rect_sig = lowpass_butter_filt(rect_sig,low_pass,Fs, order);

lowpass_rect_sig = decimate(lowpass_rect_sig,dec_fact);

Fs_dec=Fs/dec_fact;




resp_dur=[-20,100];

[mat.raw,t.raw]=get_resp_mat(raw_sig,stim_times,Fs,resp_dur);
[mat.clean, t.clean]=get_resp_mat(clean_sig,stim_times,Fs,resp_dur);
[mat.highpass, t.highpass]=get_resp_mat(highpass_sig,stim_times,Fs,resp_dur);
[mat.rect, t.rect]=get_resp_mat(rect_sig,stim_times,Fs,resp_dur);
[mat.lowpass,t.lowpass]=get_resp_mat(lowpass_rect_sig,stim_times,Fs_dec,resp_dur);
[mat.binned, Fs_binned,t.binned]=bin_trials(mat.rect,dec_fact,Fs,t.rect);

% mean_prestim=mean(prestim_mat,2);
% sem_prestim=std(prestim_mat,[],2)/sqrt(size(mat.lowpass,2));
p_conf=0.01;
% p_conf_corr_rect=p_conf/size(mat.rect,1);
% conf=norminv(1-p_conf,0,1)*sem_prestim;
% mad_prestim=mad(prestim_vec.lowpass);
% ci=zeros(size(mat.lowpass,1),2);

flds={'rect','lowpass','binned'};
for i_field=1:length(flds)
    p_conf_corr.(flds{i_field})=p_conf/size(mat.(flds{i_field}),1);
    prestim_mat=mat.(flds{i_field})(t.(flds{i_field})<-low_pass^-1,:);
    prestim_vec.(flds{i_field})=reshape(prestim_mat,[],1);
    pttest.(flds{i_field})=zeros(size(mat.(flds{i_field}),1),1);
    pftest.(flds{i_field})=zeros(size(mat.(flds{i_field}),1),1);
    for i_dat=1:size(mat.(flds{i_field}),1)
        [~,pttest.(flds{i_field})(i_dat)] = ttest2(prestim_vec.(flds{i_field}),mat.(flds{i_field})(i_dat,:),p_conf_corr.(flds{i_field}),[],'unequal');
        [~,pftest.(flds{i_field})(i_dat)] = ttest2(prestim_vec.(flds{i_field}),mat.(flds{i_field})(i_dat,:),p_conf_corr.(flds{i_field}));
    end
    
end


if do_plot
    clf
    subplot(1,2,1)
    N=50;
    m=repmat(1:N,size(mat.raw,1),1);
    ixs=randperm(size(mat.raw,2));ixs=ixs(1:N);
    plot(t.raw,mat.raw(:,ixs)+m)

    titles=fieldnames(mat);
    figure(1)
    for ii=1:length(titles)
        subplot(length(titles)+1,2,2*ii)
        plot(t.(titles{ii}),mat.(titles{ii}))
        title(titles{ii})
    end
    hold on
    plot(t.lowpass,mean(mat.lowpass,2),'k','LineWidth',2.5)

    figure(2)
    flds=fieldnames(pttest);
    for ii=1:length(flds)
        subplot(length(flds),1,ii)
        mean_resp=mean(mat.(flds{ii}),2)';
        
        bar(t.(flds{ii}),mean_resp)
        %     plot(t,mean(mat.lowpass,2),'k','LineWidth',1)
        %     plot(t.lowpass(t.lowpass<-low_pass^-1),mean_prestim+conf,':b',t.lowpass(t.lowpass<-low_pass^-1),mean_prestim-conf,':b',t.lowpass(t.lowpass<-low_pass^-1),mean_prestim,':k')
        %     p_conf_corr.lowpass=10^-16;
        hold on
        plot(t.(flds{ii})(pttest.(flds{ii})<p_conf_corr.(flds{ii})), mean_resp(pttest.(flds{ii})<p_conf_corr.(flds{ii})),'.r');
    
        %     plot(t.lowpass,ci)
        title([(flds{ii}) ' filtered MUA'])
    end
    suptitle('Mean')
    
    figure(3)
    flds=fieldnames(pftest);
    for ii=1:length(flds)
        subplot(length(flds),1,ii)
        std_resp=std(mat.(flds{ii}),[],2)';
        std_resp=std_resp-mean(std_resp);
        
        bar(t.(flds{ii}),std_resp)
        %     plot(t,mean(mat.lowpass,2),'k','LineWidth',1)
        %     plot(t.lowpass(t.lowpass<-low_pass^-1),mean_prestim+conf,':b',t.lowpass(t.lowpass<-low_pass^-1),mean_prestim-conf,':b',t.lowpass(t.lowpass<-low_pass^-1),mean_prestim,':k')
        %     p_conf_corr.lowpass=10^-16;
        hold on
        plot(t.(flds{ii})(pftest.(flds{ii})<p_conf_corr.(flds{ii})), std_resp(pftest.(flds{ii})<p_conf_corr.(flds{ii})),'.r');
    
        %     plot(t.lowpass,ci)
        title([(flds{ii}) ' filtered MUA'])
    end
    suptitle('STD')
    
    figure(4)
    flds=fieldnames(pftest);
    for ii=1:length(flds)
        subplot(length(flds),1,ii)
        var_resp=var(mat.(flds{ii}),[],2)';
        var_resp=var_resp-mean(var_resp);
        
        bar(t.(flds{ii}),var_resp)
        %     plot(t,mean(mat.lowpass,2),'k','LineWidth',1)
        %     plot(t.lowpass(t.lowpass<-low_pass^-1),mean_prestim+conf,':b',t.lowpass(t.lowpass<-low_pass^-1),mean_prestim-conf,':b',t.lowpass(t.lowpass<-low_pass^-1),mean_prestim,':k')
        %     p_conf_corr.lowpass=10^-16;
        hold on
        plot(t.(flds{ii})(pftest.(flds{ii})<p_conf_corr.(flds{ii})), var_resp(pftest.(flds{ii})<p_conf_corr.(flds{ii})),'.r');
    
        %     plot(t.lowpass,ci)
        title([(flds{ii}) ' filtered MUA'])
    end
    suptitle('Variance')
    
    figure(5)
    flds=fieldnames(pftest);
    for ii=1:length(flds)
        subplot(length(flds),1,ii)
        std_resp=std(mat.(flds{ii}),[],2)';
        mean_resp=mean(mat.(flds{ii}),2)';
        CV=mean_resp.*std_resp;

        bar(t.(flds{ii}),CV)
        %     plot(t,mean(mat.lowpass,2),'k','LineWidth',1)
        %     plot(t.lowpass(t.lowpass<-low_pass^-1),mean_prestim+conf,':b',t.lowpass(t.lowpass<-low_pass^-1),mean_prestim-conf,':b',t.lowpass(t.lowpass<-low_pass^-1),mean_prestim,':k')
        %     p_conf_corr.lowpass=10^-16;
        hold on
%         plot(t.(flds{ii})(pftest.(flds{ii})<p_conf_corr.(flds{ii})), CV(pftest.(flds{ii})<p_conf_corr.(flds{ii})),'.r');
    
        %     plot(t.lowpass,ci)
        title([(flds{ii}) ' filtered MUA'])
    end
    suptitle('STD*Mean')
    
    
%     mean_rect=mean(mat.rect,2);
%     errorbar_patch(t.rect,mean_rect,std(mat.rect,[],2)/sqrt(size(mat.rect,2)))
%     %     plot(t,mean(mat.lowpass,2),'k','LineWidth',1)
%     %     plot(t.lowpass(t.lowpass<-low_pass^-1),mean_prestim+conf,':b',t.lowpass(t.lowpass<-low_pass^-1),mean_prestim-conf,':b',t.lowpass(t.lowpass<-low_pass^-1),mean_prestim,':k')
%     %     p_conf_corr.lowpass=10^-16;
%     plot(t.rect(p.rect<p_conf_corr_rect), mean_rect(p.rect<p_conf_corr_rect),'.r');
%     title('Raw MUA')
    
end




rsp_flag=[]; rsp_p=[];



% filter the raw signal (over 1 KHz? 1-6KHz?)

% cut the 20 msec after each stimulus (get this from the remove srimulus
% artifact code)

% create the matrix of all post stimulus segments

% calculate mean, std,
%...?

