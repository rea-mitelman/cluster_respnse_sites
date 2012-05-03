function [stimulusArray, preStimulusDataArray] = BuildStimulusArtifactArray(analogueData, digitalData, analogueFrequencyKHz, digitalFrequencyKHz, trainLength, binWidthInMiliseconds)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function BuildStimulusArtifactArray by borisr
%                                                                                                                            
%                                                                                                                           
%  Objective: Create an array containing in each row a part of the analogue
%  aquisition during  which stimuli with theeir artifacts  were given. 
%
% takes 6 parameters: 
% I - analogueData - the vector of the analogue data aquisition
% II - digitalData - the vector of the digital data aquisition around which
% the analogue data is to be cut, i.e. Cmcp_gain_Up
% III - analogueFrequencyKHz - the frequency of the analogue data
% IV - digitalFrequencyKHz - the frequency of the digital data
% V - trainLength - number of spikes in the stimulus train 
% VI - binWidthInMiliseconds - the width of the cut in milisconds
%
%
%returns 1 parameter
% I - stimulusArray - the constructed array
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Constants definition%%%%%%%%%%%%%%%%%%%%%%

%IMPORTATNT   - USE LARGER BIN FOR SINGLE PULSE%

if (nargin < 6)
    binWidthInMiliseconds = 90; %  milliseconds bin width
end

%%%%%%%%%%%%%%%%%%%%%End of constants definition%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Code begin%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If required, convert the frequency of the digital data so it will fit the
% analogue data frequency. 
if (analogueFrequencyKHz ~= digitalFrequencyKHz)
    convertedDigitalData = ConvertSamplingRate(digitalData, digitalFrequencyKHz, analogueFrequencyKHz);
else
    convertedDigitalData = digitalData;
end
%%% end of conversion


% cut the data
[stimulusArray, preStimulusDataArray] =  CutAnalogueDataAccordingToDigitalData(analogueData,  convertedDigitalData, floor( binWidthInMiliseconds*analogueFrequencyKHz), trainLength);


% NOT RELEVANT HERE - use only for cutting out entire spike trains
% Desect only the segments containing the full spike train (here every 4-th
% segment, provided  Cmcp_gain_Up is used as the digital data reference

%SEGMENT_TO_BE_DESECTED = 4;

%numberOfSegments = size(tempArray);

%numberOfSegments = numberOfSegments(1);

%myIndices = 1:numberOfSegments;

%myIndices = myIndices - SEGMENT_TO_BE_DESECTED;

%myIndices = mod(myIndices, trainLength);

%myIndices = find (myIndices == 0);

%stimulusArray = tempArray(myIndices, :);

