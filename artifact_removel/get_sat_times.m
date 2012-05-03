function sat_times=get_sat_times(signal,stim_times, signal_Fs, resp_dur)
%%
% resp_dur=[0 1];%This assumes that no stim. artifact saturation occurs after one millisecond
do_plot=false;
maxV=5;a2d_res=14;
minmax_val=maxV-2*maxV*2^-a2d_res;

sat_ixs = abs(signal)>=minmax_val;

[sat_ixs_mat,t]=get_resp_mat(sat_ixs, stim_times, signal_Fs, resp_dur);
all_sat_times = t(any(sat_ixs_mat,2));
if ~isempty(all_sat_times)
	sat_times=all_sat_times([1,end]);
else
	sat_times=[Inf -Inf];
end
%%
if do_plot
	
	p_sat=sum(sat_ixs_mat,2);
	% 	p_sat=p_sat(p_sat>0);
	% 	dx=0.001;
	% 	[a,b]=hist(p_sat,[0:dx:1]);
	% 	a=a/sum(a)*100;
	% 	stairs(b,a)
	% 	ylim([0,100])
	% 	xlim([0,1+dx])
	plot(p_sat,'.-')
	keyboard
	
end

