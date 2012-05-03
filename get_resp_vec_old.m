function [norm_resp_vec, ttest_p_vec] = get_resp_vec(raw_sig, Fs, stim_times, do_plot)
if ~unempty_exist('do_plot')
    do_plot=true;
end

%parameters
ds_Fs=5;%binning/downsample is to a final Fs of 5 KHz
high_pass=1;
org_art_dur=1;
dead_time=0.0;
filt_ord=8;
resp_dur=[-20,100];
p_conf=0.01;

clean_sig=remove_stim_artifact(raw_sig,Fs,stim_times,org_art_dur,dead_time);
dec_fact=Fs/ds_Fs;
highpass_sig = highpass_butter_filt(clean_sig,high_pass,Fs, filt_ord);
rect_sig = abs(highpass_sig);
rect_sig=rect_sig-mean(rect_sig);

[rect_mat, t.rect]=get_resp_mat_old(rect_sig,stim_times,Fs,resp_dur);
[rect_bin_mat, Fs_binned,t.bin]=bin_trials(rect_mat,dec_fact,Fs,t.rect);

p_conf_corr=p_conf/size(rect_bin_mat,1);
prestim_mat=rect_bin_mat(t.bin<-ds_Fs^-1,:);
prestim_vec=reshape(prestim_mat,[],1);
presrim_std=std(prestim_vec);

norm_resp_vec=mean(rect_bin_mat,2)./presrim_std;

ttest_p_vec=zeros(size(rect_bin_mat,1),1);
for i_dat=1:size(rect_bin_mat,1)
    [~,ttest_p_vec(i_dat)] = ttest2(prestim_vec,rect_bin_mat(i_dat,:),p_conf_corr,[],'unequal');
end



if do_plot
    [mat.raw,t.raw]=get_resp_mat(raw_sig,stim_times,Fs,resp_dur);
    figure
    clf
    subplot(1,2,1)
    N=50;
    m=repmat(1:N,size(mat.raw,1),1);
    ixs=randperm(size(mat.raw,2));ixs=ixs(1:N);
    plot(t.raw,mat.raw(:,ixs)+m)
    titles=fieldnames(mat);
    subplot(2,2,2)
    plot(t.(titles{1}),mat.(titles{1}))
    title(titles{1})
    hold on
    plot(t.bin,norm_resp_vec,'k','LineWidth',2.5)
    subplot(2,2,4)
    bar(t.bin,norm_resp_vec)
    hold on
    plot(t.bin(ttest_p_vec<p_conf_corr), norm_resp_vec(ttest_p_vec<p_conf_corr),'.r');
    xlim(resp_dur)
    
end
end


