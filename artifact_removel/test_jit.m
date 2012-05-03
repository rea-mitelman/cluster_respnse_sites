load test_data
signal_clean=remove_artifact_advanced(signal, Fs, stim_times, stim_times_Fs, upsamp_factor, art_begin, art_end, max_dead_time_dur, do_lin_decay);
