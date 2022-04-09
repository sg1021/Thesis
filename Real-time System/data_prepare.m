function [trainX, targets] = data_prepare

load randData.mat

%% generate data array (train and test)
trainlen = 0.9*size(inputData_HPF,2); testlen = 0.1*size(inputData_HPF,2); 
trainX = inputData_HPF(:,1:trainlen);
testX = inputData_HPF(:,trainlen+1:trainlen+testlen);

%target!
trainY = targetData_HPF(1:trainlen);
testY = targetData_HPF(trainlen+1:trainlen+testlen);

%% One-hot encoding

%% After run trtsXY.m, you can run this code.
%one-hot converter for train 
n = size(trainX,2);
C =5;
targets = zeros(C,n);

%added 1 to the ground truth
trainY(1,:) = trainY(1,:) + 1;

%one-hot target
for i = 1:n
    targets(trainY(i),i) = 1;
end


nT = size(testX,2);
targetsT = zeros(C,nT);

testY(1,:) = testY(1,:) + 1;

for ii = 1:nT
    targetsT(testY(ii),ii) = 1;
end

end