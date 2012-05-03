function y_filt = highpass_butter_filt(y,high_pass,Fs, order)
% y_filt = highpass_butter_filt(y,high_pass,Fs, order)
% highpass butterworth filter - should be debugged, consider using the
% function buttord to determin the order of the filter.

F_Nyq=Fs/2;
Wn=high_pass /F_Nyq;
[b,a] = butter(order,Wn,'high');
y_filt=filtfilt(b,a,y);

