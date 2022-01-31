%Inside ESN model 

classdef shoESN < handle
    
    properties
        win
        wout
        wb
        wr
        state
        rsize
        iscaling
        leaky_rate
        connectivity
        training_method
        spectral_radius
        idim
        activation
        lambda
    end
    
    methods
        function esn = shoESN(rsize,iscaling,leaky_rate,connectivity,spectral_radius,idim,activation, lambda)
            
            
            esn.rsize = rsize;%100
            esn.iscaling = iscaling;%0.01 [-0.01 0.01]
            esn.leaky_rate = leaky_rate;%0.01
            esn.connectivity = connectivity;%0.8
            esn.spectral_radius = spectral_radius;%0.5
            esn.idim = idim;%14
            esn.activation = activation;%tanh
            esn.lambda = lambda;%0
        end
        
        function train(esn, trainx, trainy)
           
            %set input weights as factor of input scaling
            esn.win = esn.iscaling * (rand(esn.rsize, esn.idim) * 2 - 1);
            %input bias weights
            esn.wb = rand(esn.rsize, 1) * 2 - 1;
            %reservoir weights sparsely populated based on connectivity
            esn.wr = full(sprand(esn.rsize,esn.rsize,esn.connectivity));
            %update according to spectral radius 
            esn.wr = esn.wr * (esn.spectral_radius / max(abs(eig(esn.wr))));
            
            X = zeros(1+esn.idim+esn.rsize, size(trainy,2));
            
            idx = 1;
               
            
            U = trainx;
            x = zeros(esn.rsize,1);
            for i = 1:size(U,2)

                %u is U(t)
                u = U(:,i);
                if esn.activation == "sigmoid"
                    x_ = sigmoid(esn.win*u + esn.wr*x + esn.wb);
                else
                    x_ = tanh(esn.win*u + esn.wr*x + esn.wb);
                end
                %update x based on leaky rate
                x = (1-esn.leaky_rate)*x + esn.leaky_rate*x_;

                X(:,idx) = [1;u;x];
                idx = idx+1;

            end
                
            esn.state = X(1+esn.idim+1:end,:);
            
            %Calculate the output weights by linear regression (Normal Equation)
            esn.wout = feval('regression',X, trainy', esn.lambda);
            
        end
        
        function y = predict(esn, input)
            
            
            train_length = size(input,1);
            X = zeros(1+esn.idim+esn.rsize, train_length);
            idx = 1;
            
            U = input;
            x = zeros(esn.rsize,1);

            % same as above
            for i = 1:size(U,2)
                u = U(:,i);
                if esn.activation == "sigmoid"
                    x_ = sigmoid(esn.win*u + esn.wr*x + esn.wb);
                else
                    x_ = tanh(esn.win*u + esn.wr*x + esn.wb);
                end
                x = (1-esn.leaky_rate)*x + esn.leaky_rate*x_;
                X(:,idx) = [1;u;x];
                idx = idx+1;
            end
            % compute output
            esn.state = X(1+esn.idim+1:end,:);
            y = esn.wout * X;
            y = y';
        end
    end
end

