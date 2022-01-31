%This program inserts the train and test data to ESN, and shows the accuracy with confusion matrix. 

%reservoir size, i_scaling, leaky_rate, connectivity, spectral_radius,
%i_dimension, activation, lambda
esn = shoESN(100,1,0.9,0.3,0.9,14,"tanh",0); 

%train ESN
esn.train(trainX, targets);

%test ESN
result = esn.predict(testX)';


%Modify the format for the evaluation of time-series classificatioin (for confusion matrix)
[H, GT_Class] = classifyOutput(result,testY);


%Comfusion matrix (F,B,P,M,S)
C = confusionmat(GT_Class,H); % targetsT values should not be float, be 0 and 1 in this case.->refer to how did it.
%Accuracy
ACC = (sum(diag(C)))/(sum(C,'all'));
ACC = round(ACC,4);
confusionchart(C)
title("The accuracy for classification is " + 100*ACC + "%")


