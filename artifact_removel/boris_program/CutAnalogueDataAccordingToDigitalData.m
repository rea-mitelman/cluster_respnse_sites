function [periSignalArray, preSignalArray] = CutAnalogueDataAccordingToDigitalData(analogueData, digitalData, cutWidth, trainLength)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function CutAnalogueDataAccordingToDigitalData by borisr
%                                                                                                                            
%                                                                                                                           
%Usage: Cut the analogue data and place it into a matrix, in which each row
%               cointains an analogue signal of 2*cutWidth  length around the digital
%               detection index. 
%
% Receives 4 parameters: 
%       I - analogueData - the vector of the analogue data aquisition
%       II - digitalData - the vector of the digital data aquisition, containing the
%               indices of the spike detection sample number
%       III - cutWidth - the width of the analogue segment to be cut to each side 
%       IV - trainLength - the number of stimuli in each train (1 if single spike)
%
%
%  Returns 2 parameters:
%       I -  periSignalArray - a 3D array of the following dimentions:
%               X axis: number of stimuli in train (>= 1)
%               Y axis: the width of the bin specified by the user *2 +1
%               Z axis: the number of stimuli trains in the data supplied by the user 
%       II - preSignalArray - a cell array containing the analogue data segments (of cariable length) between the stimuli 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

digitalData = digitalData + cutWidth;

periSignalArray = analogueData(digitalData - cutWidth:digitalData + cutWidth);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Constants definition%%%%%%%%%%%%%%%%%%%%

RIGHT_OFFSET = 30;

%%%%%Check whether a train length was specified, if not - use single spike
if nargin < 4
     trainLength = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Code begin %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Compute the number of digital signals
numOfDigitalSignals = length(digitalData);
%numOfDigitalSignals = numOfDigitalSignals(2);

analogueDataLength = length(analogueData);

%Calculate the dimentions of the output array
preSignalArrayRowsNumber = trainLength;
periSignalArrayRowsNumber = preSignalArrayRowsNumber;
periSignalArrayColumnsNumber = (cutWidth*2) + 1;
 periSignalArrayDepth = floor(numOfDigitalSignals/trainLength);
 preSignalArrayColumnNumber  = periSignalArrayDepth;

%Preallocate the output arrays
periSignalArray = zeros(periSignalArrayRowsNumber, periSignalArrayColumnsNumber, periSignalArrayDepth);
%enlarge the preSignalArray in order to acomodate the rest of the data. 
preSignalArray = cell(preSignalArrayRowsNumber, preSignalArrayColumnNumber + 1);

%Set the axilliary variable prevUpperIndex to 1;
prevUpperIndex = 1;

%Cut the data and place it in the output array
for i=1:numOfDigitalSignals
    
    leadingZerosLength = 0;
    
    followingZerosLength = 0;
    
    
    
    %place the data in the output array
    lowerIndex = max (digitalData(i) - cutWidth, 1);
    upperIndex =  min (digitalData(i) + cutWidth, analogueDataLength);
    
    
    %debug
    if(prevUpperIndex > lowerIndex)
        %serious kaka 
      %  disp('kaka');
    end
    %%%%%%%%%%%%% AN IMPORTANT ASSUMPTION, BEWARE!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %find the maximum in the segment - the artifact highest point and place
    %the cut around it. The assumption - the artifact's lowpoint  has the minimum value%%
    
    
    %%%%%%%%%%%%%%%IMPORTANT EDITED CODE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% This is in use in stimulus artifact remval only, commented out in
    %%% ASDSHift, better place in a separate function
   
  %  temp  = analogueData(lowerIndex:upperIndex);
   %localMaxima, rightOffset] = max(temp);
    %rightOffset = rightOffset - cutWidth;
    
    
    %Update the value of the lower and upper indices of the cut according
    %to the found offset
    
    %lowerIndex =max (1, lowerIndex + rightOffset);
    %upperIndex =  min (upperIndex +  rightOffset, analogueDataLength);
    
    rightOffset = 0;
      %%%%%%%%%%%%%%%%%%%%END OF EDITED CODE%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    % Cut out the data
    thisCycleData = analogueData(lowerIndex:upperIndex);
    
  
        
        
    
    %pad with zeros if necessary
     if (digitalData(i) - cutWidth + rightOffset < lowerIndex)
        leadingZerosLength = lowerIndex - (digitalData(i) - cutWidth + rightOffset);
        leadingZeros = zeros(1, leadingZerosLength);
    end
    
    if (digitalData(i) + cutWidth + rightOffset> upperIndex)
        followingZerosLength = digitalData(i) + cutWidth + rightOffset  - upperIndex;
        followingZeros = zeros (1, followingZerosLength);
    end
    
    if (leadingZerosLength ~= 0)
        thisCycleData = [leadingZeros,thisCycleData];
    end
    
    if(followingZerosLength ~= 0)
      thisCycleData = [thisCycleData, followingZeros];
    end
    %end of zero padding
   
   %Place the data in an output arrays 
    trainNumber = floor ((i - 1)/trainLength) + 1; 
    rowNumber = mod(i - 1, trainLength) + 1;
    
    
    periSignalArray(rowNumber, :, trainNumber) = thisCycleData;
  
    if (lowerIndex - 1 > prevUpperIndex)
        preSignalArray{rowNumber, trainNumber} = analogueData(prevUpperIndex + 1: lowerIndex - 1);
    else
        preSignalArray{rowNumber, trainNumber} = [];
    end
    
    %If this is the last signal place the rest of the data into the cell
    %array
   
   if (i == numOfDigitalSignals && upperIndex < analogueDataLength)
           %Place the data in an output arrays 
        trainNumber = floor (i/trainLength) + 1; 
        rowNumber = mod(i, trainLength) + 1;
        preSignalArray{rowNumber, trainNumber} = analogueData(upperIndex + 1:analogueDataLength); 
      % disp('kaka');
    end
  
    prevUpperIndex = upperIndex;
       
end



    

 

                                                                                                                            
                                                                                                                         