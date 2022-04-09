function [ W ] = regression( X, Y, lambda)

% This is linear regression (Normal Equatioin) to calculate the weight.
%*The other way to calculate the weight is the interative method (Gradient Descent)

%include lambda with eye
%start with 0
W = Y'*X'*inv(X*X'+lambda*eye(size(X,1))); 

end