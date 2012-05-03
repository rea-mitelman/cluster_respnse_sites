%test_param
load trial_data
close all
% test_is_resp_site(Unit3,Unit3_KHz,stim_times,1,.5);
[a,b]=get_resp_vec(Unit3,Unit3_KHz,stim_times);
title('New')
[a_old,b_old]=get_resp_vec_old(Unit3,Unit3_KHz,stim_times);
title('Old')