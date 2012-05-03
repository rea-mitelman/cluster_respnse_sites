function [SESSparam, DDFparam, MAT_base_name, curr_MrgEd_dir, curr_mat_dir,Info_fullfilename]=get_info(rootdir, sessdir) %#ok<*STOUT>

curr_day_dir=[rootdir filesep sessdir filesep];
curr_mat_dir=[curr_day_dir 'MAT' filesep];
curr_MrgEd_dir=[curr_day_dir 'MergedEdFiles' filesep];

if ~isdir(curr_mat_dir) || ~isdir(curr_MrgEd_dir)
    fprintf('%s is not a propper session subdirectory in the directory %s\n',sessdir, rootdir);
    SESSparam=[];DDFparam=[];MAT_base_name=[];Info_fullfilename=[];
    return
end

slsh_i = find(curr_day_dir==filesep,2,'last');
MAT_base_name = curr_day_dir(slsh_i(1)+1:slsh_i(2)-1); %mat files have the following form (e.g. 1st bhv file: [MAT_base_name '001' '_bhv'] )
Info_fullfilename = [curr_day_dir 'Info' filesep MAT_base_name '_param.mat'];
if exist(Info_fullfilename,'file')
    load(Info_fullfilename)
else
    error (['Info file was not found at: ' curr_info_file ' please locate it and run again']);
end

