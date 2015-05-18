% Harrison Zafrin
% Y_train = Our concatenated features across songs and instrument class
% alpha_train = concatenated coefficients across song and instrument class
% test_features = these features will have the projection matrix applied to
% -------------------------------------------------------------------------
% Do Multiple Linear Regression
% -------------------------------------------------------------------------
function [ predicted_coefs ] = compute_MLR( Y_train, alpha_train, test_features )

for i=1:length(Y_train)
   
    % Get items to create projection matrix, these are the same instrument  
    instr_features = Y_train{i};
    instr_grndtruth = alpha_train(i,:);
    
    % Make projection matrix, each column is an instrument class
    proj_matrx(:,i) = lsqnonneg(instr_features, instr_grndtruth');
    
end

% Get the Instruments out of the test features
% instruments = test_features{1};

for i=1:length(test_features)
   
    predicted_coefs(i,:) = test_features{i} * proj_matrx(:,i);
    
end

% -------------------------------------------------------------------------
% Filter Curve Smoothing via Exponential Moving Average (No Kalman)
% -------------------------------------------------------------------------

% Determine degree of filtering
alpha = 0.9;

% Make output for prev_value storage
output = 0;

% Run through the EMA
for i=1:size(predicted_coefs, 2)
    
    % EMA = frame'(w) = alpha* frame-1'(w) + (1-alpha) * frame(w)
    predicted_coefs(:,i) = (alpha * output) + ((1-alpha) * predicted_coefs(:,i));
    output = predicted_coefs(:,i);
    
end

end

