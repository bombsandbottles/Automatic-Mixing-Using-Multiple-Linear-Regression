% Harrison Zafrin and Collin Chudwick
% groun_truth = ground truth fader coefficients
% predicted_coefs = MLR predicted coeffficients
% MSE = Mean Sqaure Error matrix containing the MSE of each instrument
% -------------------------------------------------------------------------
% Compute the mean square error between two data sets
% -------------------------------------------------------------------------
function [ MSE ] = mean_square_error( ground_truth, predicted_coefs )

% For each instrument in the mix, compute the MSE
for i=1:size(ground_truth,1)
   
    % Compute the MSE for an instrument    
    inst_error = mean(((ground_truth(i,:)-predicted_coefs(i,:)).^2));
   
    % Load out into MSE matrix, contains all the MSEs for each instrument
    MSE(i,:) = inst_error;
    
end

end

