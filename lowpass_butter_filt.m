function y_filt = lowpass_butter_filt(y,low_pass,Fs, order)
% y_filt = lowpass_butter_filt(y,low_pass,Fs, order)
% lowpass butterworth filter - should be debugged, consider using the
% function buttord to determin the order of the filter.

F_Nyq=Fs/2;
Wn=low_pass /F_Nyq;
[b,a] = butter(order,Wn,'low');
y_filt=filtfilt(b,a,y);

