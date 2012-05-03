function [meanArray, stimulusArray, residualDataArray] = ComputeStimulusArtifactFromMultipleFiles(directoryPath, fileNumbers, electrodeNumber, numberOfPulsesInBurst)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function ComputeStimulusArtifactFromMultipleFiles by borisr
%                                                                                                                            
%                                                                                                                           
%  Objective: Compute the stimulus artifact of the files supplied by the
%  user and rreturn the computed artifact and the segmented data
%
% Receives 4 parameters: 
% I - directoryPath: a string the path under which the files are located
% II - file numbers:  an array containing the numbers of data files to be used
%                     for computation
% III - electrodeNumber: the number of electrode containing the relevant
%                         signal
% IV - numberOfPulsesInBurst: the number of pulses in a stimulation burst,
%                             use 1 or do not specify if single pulse
%                             stimulation
%
% Returns 3 parameters:
% I -      meanArray : an array containing the computed stimulus
%            artifact(s), one for each stimulus in a train. 
% II -   stimulusArray: a cell array, in which every entery contains
%            segmented (around the stimulus) data from a single file
%            supplied by the user. 
% III - residualDataArray: the data not tontaining the stimuli artifacts,
%            i.e. the data between stimulations, each entery contains data from a
%            single file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Code Begin%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fileNamePrefix = DetermineFilePrefix(directoryPath);
electrodeName = sprintf('%s%d', 'CSPK', electrodeNumber);
if(nargin < 4)
    numberOfPulsesInBurst = 1;
end

%Load the files and compute the mean for each, place the result in a 3-D
%array

numberOfFiles = size(fileNumbers);
numberOfFiles = numberOfFiles(2);

for i=1:numberOfFiles
    
    currentFileName = [directoryPath, '\',  BuildFileName(fileNamePrefix, fileNumbers(i))];
    
    %load the file
   load(currentFileName);
  
   [periStimulusDataArray, preStimulusDataArray] = BuildStimulusArtifactArray(eval(electrodeName), Cstim_in_Down, CSPK8_KHz, Cstim_in_KHz, numberOfPulsesInBurst);
   
   %if this is not the first file, concatenate it to the previous results,
   %else just place the results in the output array
   
   if (i > 1)
       dataFromAll = cat (3, dataFromAll, periStimulusDataArray);
   else
       dataFromAll = periStimulusDataArray;
   end
    
   stimulusArray {i} = periStimulusDataArray;
   residualDataArray{i} = preStimulusDataArray;
   
end

 meanArray = mean(periStimulusDataArray, 3);
 clear('fleNamePrefix', 'electrodeName');
 
end








    
    
