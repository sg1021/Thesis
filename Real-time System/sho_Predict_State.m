
%reservoir size, i_scaling, leaky_rate, connectivity, spectral_radius,
%i_dimension, activation, lambda
esn = shoESN(100,1,0.009,0.9,0.9,14,"tanh",0); 


%train ESN
esn.train(trainX, targets);

%test ESN
result = esn.predict(testX)';


%Modify the format for Classificatioin (for confusion matrix)
[H, GT_Class] = classifyOutput(result,testY);

%MAE(Mean Absolute Error) & MSE
perf = mae(H-GT_Class); %no random 1.50, rand 1.60, [0-1]scaled 1.55, HPF 1.48
accuracy = immse(H,GT_Class); %no rand 3.86, rand 4.08, [0-1]scaled 3.87, HPF 3.68

%Comfusion matrix (F,B,P,M,S)
C = confusionmat(GT_Class,H); % targetsT values should not be float, be 0 and 1 in this case.->refer to how did it.
%Accuracy
ACC = (sum(diag(C)))/(sum(C,'all'));
ACC = round(ACC,4);
confusionchart(C)
title("The accuracy for classification is " + 100*ACC + "%")

% Histogram
%eachSqErr = (GT_Class-H).^2;
%figure
%histogram(eachSqErr); 
%ylim([0 100])
%title("With HPF input; MSE:" + accuracy + ", MAE:" + perf)


