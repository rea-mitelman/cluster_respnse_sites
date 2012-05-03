function   arrayForSubtraction = ConstructSubtractionArrayByCurveFitting(artifactsArray ,stimuliArray)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function ConstructSubtractionArrayByCurveFitting
%                                                                                                                            
%   Purpose: Adjust the stimuli artifacts, as computed by averaging, by finding the best fit in the mean                                                                                                                    
% 
%
%  Receives 3 parameters: 
%       I -       artifactsArray : an array of size 7X(bin width *2 +1),
%                   containing the computed shapes of the stimuli artifacts
%       II -    stimuliArray: an aray containing the data segments
%                   around the various stimuli
%     
%       
%                  
%  Returns 1 parameter:
%        I -     arrayForSubtraction: an array containing the augmnented
%                   stimuli artifacts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Code begin%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Compute the number of data segments and preallocate the output array
sizeOfDataArray = size(stimuliArray);
arrayForSubtraction = zeros(sizeOfDataArray);
numberOfStimuliInTrain = sizeOfDataArray(1);
numberOfStimuliSegments = sizeOfDataArray(3);




%Iterate over the stimulus array, find the best fit for 
for (i = 1:numberOfStimuliSegments)
    for (j = 1:numberOfStimuliInTrain)
        % Create the fit type structure for the Curve Fitting toolbox
        % funtion fit, specifying the type of fit - linear least squares
        fitTypeStruct = fittype('poly1' );
        % Compute the fit between the artifat template and the data segment
        thisArtifact = artifactsArray(j, :);
        thisStimulusDataSegment = stimuliArray(j, :, i);
        curveFitResult = fit( thisArtifact(:) , thisStimulusDataSegment(:), fitTypeStruct );
        %Compute the augmented stimulus artifact template and place it in
        %the output array
        augmentedStimulusArtifact = (curveFitResult.p1 * thisArtifact + curveFitResult.p2);
        arrayForSubtraction(j, :, i) = augmentedStimulusArtifact;
    end
end
