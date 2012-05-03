function rejoinedData = RemoveStimulsArtifactFromMultipleFiles(directoryPath, fileNumbers, electrodeNumber, numberOfPulsesInBurst)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function RemoveStimulsArtifactFromMultipleFiles by borisr
%                                                                                                                            
%                                                                                                                           
%  Objective: Remove stimulus artifacts from anlaogue data in files supplied by the
%                           user
%
% Receives 4 parameters: 
% I -    directoryPath: a string containing the path under which the data files are located
% II -   file numbers:  an array containing the numbers of data files to be used
%        for computation
% III -  electrodeNumber: the number of the electrode from which the
%        stimulus artifact is to be removed.
% IV  -  numberOfPulsesInBurst: the number of pulses in a single stimulus
%                               burst, use 1 or do not specify if single pulse stimulation
%
% Returns 1 parameter: the rejoined data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Code Begin%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (nargin < 4)
    numberOfPulsesInBurst = 1;
end

%Compute the stimulus artifact
 [artifactsArray, stimulusArray, residualDataArray] = ComputeStimulusArtifactFromMultipleFiles(directoryPath, fileNumbers, electrodeNumber, numberOfPulsesInBurst);
 
 %Remove voltage offset from all data
% [artifactsArray, stimulusArray, residualDataArray] = RemoveVoltageOffsetFromData(artifactsArray, stimulusArray, residualDataArray);
 
 %Remove the stimulus artifact from the data
 stimulusArrayWithouArtifact = RemoveStimulusArtifactFromData(artifactsArray ,stimulusArray, 'n');
 
 %Rejoin the data segments
 rejoinedData = RejoinData(stimulusArrayWithouArtifact, residualDataArray);
 clear('artifactsArray', 'stimulusArray', 'residualDataArray', 'stimulusArrayWithouArtifact');
 