function [H, GT_Class] = classifyOutput(result,testY)

% For classification, since the target output is given as a one-hot vector,
% we expect only the c-th node output of the output layer to take a value close to 1 and the rest to take values close to 0.
%
% Therefore, we take the maximum element from each column and find the most frequent class.
%
%
%
%
%

%Find the maximum index on each column.
[M,I] = max(result); % M contains the max values, I has the index (1~5).

%Make a array for storing the hypothesis classes.
H = zeros(1,length(result)/256);


%Find the element the most frequently appears in each range (1~256 samples)
%and add to the array
for n = 0:length(result)/256 - 1
   F = mode(I(n*256+1:(n+1)*256)); % F is the hyphothesis class.
   H(n+1) = F;
end


%Same as above for GT
GT_Class = zeros(1,length(testY)/256);
for m = 0:length(testY)/256 - 1
   F_GT = mode(testY(m*256+1:(m+1)*256));
   GT_Class(m+1) = F_GT;
end



end