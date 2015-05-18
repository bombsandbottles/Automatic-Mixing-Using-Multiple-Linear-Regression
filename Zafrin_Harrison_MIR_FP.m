% Harrison Zafrin and Collin Chudwick
% MIR Final Project
% Automatic Multi-Track Mixing using Multiple Linear Regression
% -------------------------------------------------------------------------

clear;
clc;

% -------------------------------------------------------------------------
% These are the training tracks for pop music mix
% -------------------------------------------------------------------------

% Song 1, Katy Perry - California Gurls
[ coef, features ] = katy_perry( );
train_coefs{1} = coef;
test_features{1} = features;

% Song 2, Betty Who All Of You
[ coef, features ] = katy_perry( );
train_coefs{2} = coef;
test_features{2} = features;

% % Song 2, Betty Who All Of You
% [ coef, features ] = betty_who( );
% train_coefs{2} = coef;
% test_features{2} = features;
% 
% % Song 3, Britney Spears - Break The Ice
% [ coef, features ] = bs_breaktheice( );
% train_coefs{3} = coef;
% test_features{3} = features;
% 
% % Song 4, Britney Spears - Break The Ice
% [ coef, features ] = bs_gimmemore( );
% train_coefs{4} = coef;
% test_features{4} = features;
% 
% % Song 5, Katy Perry - ET
% [ coef, features ] = katy_perry_et( );
% train_coefs{5} = coef;
% test_features{5} = features;
% 
% % Song 6, Oh Land - Rennesaince Girls
% [ coef, features ] = OL_rengirls( );
% train_coefs{6} = coef;
% test_features{6} = features;
% 
% % Song 7, Lady Gaga - Alejandro
% [ coef, features ] = lg_alejandro( );
% train_coefs{7} = coef;
% test_features{7} = features;

% Create the Training Set (N-1 files)
[ Y_train, alpha_train ] = create_training_sets( train_coefs, test_features );

% -------------------------------------------------------------------------
% This is the test track
% -------------------------------------------------------------------------
% Create the Test Set, (1 file)
[ ground_truth, test_features ] = katy_perry( );

% -------------------------------------------------------------------------
% Compute the Multiple Linear Regression
% -------------------------------------------------------------------------
[ predicted_coefs ] = compute_MLR( Y_train, alpha_train, test_features );

% plot(coef(1,:));
% hold on;
% plot(predicted_coefs(1,:), 'g');

% -------------------------------------------------------------------------
% Compute the Mean Square Error
% -------------------------------------------------------------------------
[ MSE ] = mean_square_error( ground_truth, predicted_coefs );

% -------------------------------------------------------------------------
% Perform and Auto-Mix with the predicted coefficients
% -------------------------------------------------------------------------

% 2-Track Katy Perry
master = 'Master Section.aif';

% Choose the stems you want to auto-mix
stems = {'drumBus.aif',...
         'Bass.aif',...
         'melodyBus.aif',...
         'Vocals Main.aif'};
     
% Perform the Mix
[ mix, fs ] = auto_machine_mix( master, stems, predicted_coefs );

    






