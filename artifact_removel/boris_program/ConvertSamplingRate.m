function sampleArray = ConvertSamplingRate(oldSampleArray,oldSamplingRateKHz, newSamplingRateKHz)
%   ConvertSamplingRate - rewrites the array of samples in  new sampling
%   rate
        sampleArray = round(oldSampleArray*(newSamplingRateKHz/oldSamplingRateKHz));
        %First sample can not be zero
        if sampleArray(1) == 0
            sampleArray(1) = 1;
        end
        