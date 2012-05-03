function stimuliArrayWithoutArtifact = RemoveStimulusArtifactFromData(artifactsArray ,stimuliArray, useCurveFitting)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function ComputeVoltageOffset by borisr
%                                                                                                                            
% Compute the voltage offset of the analogue data                                                                                                                          
% 
%
%  Receives 3 parameters: 
%       I -       artifactsArray : an array of size 7X(bin width *2 +1),
%                   containing the computed shapes of the stimuli artifacts
%       II -    stimuliArray: a cell aray containing the data segments
%                   around the various stimuli,  one entry per file
%       III-   useCureFittig - a charcter, if equals 'y' linear curve
%                   fitting will be used, otherwise simples subtraction
%       
%                  
%  Returns 1 parameter:
%        I -     stimuliArrayWithoutOffset: a cell aray containing the data segments
%                  around the various stimuli,  one entry per file with the
%                  offset removed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Code begin%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%check from how many files was the data collected
numberOfFiles = size(stimuliArray);
numberOfFiles = numberOfFiles(2);

for (i = 1:numberOfFiles)
    %extract the data for the file in the current iteration
    currentFileData = stimuliArray{1, i};
    %check how many data segments (stimuli) are in the file
    numberOfDataSegmentsInFile = size(currentFileData);
    numberOfDataSegmentsInFile = numberOfDataSegmentsInFile(3);
    %construct a 3*d array by attaching artifact arrays along the z axis,
    %once for each stimulus given.
    if (useCurveFitting == 'y')
        arrayForSubtraction = ConstructSubtractionArrayByCurveFitting(artifactsArray ,currentFileData);
    else
        arrayForSubtraction = repmat(artifactsArray, [1,1, numberOfDataSegmentsInFile]);
    end
    %subtract the artifact from the data
    stimuliArrayWithoutArtifact{1,i} = currentFileData -  arrayForSubtraction;
    %go home
end
