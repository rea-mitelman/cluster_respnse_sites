function [MrgEd_filename,wvf_filename,bhv_filename] = get_load_filenames(curr_MrgEd_dir,MrgEd_base_name,i_ss,file_in_ss,curr_mat_dir,MAT_base_name, i_file)

MrgEd_filename=sprintf('%s%s%02.0fee.%1.0f.mat',curr_MrgEd_dir,MrgEd_base_name,i_ss,file_in_ss);
wvf_filename=sprintf('%s%s%03.0f_wvf.mat',curr_mat_dir,MAT_base_name,i_file);
bhv_filename=sprintf('%s%s%03.0f_bhv.mat',curr_mat_dir,MAT_base_name,i_file);
