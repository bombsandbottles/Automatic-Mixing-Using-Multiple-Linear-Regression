% Harrison Zafrin and Collin Chudwick
% MIR Final Project
% Automatic Multi-Track Mixing using Multiple Linear Regression
% -------------------------------------------------------------------------

clear;
clc;

addpath('/Volumes/LaCie/StemsForMIR/allstems');
addpath('/Users/harrison/Desktop/Github/Automatic-Mixing-Using-Multiple-Linear-Regression/stem_files');

% -------------------------------------------------------------------------
% These are the training tracks for pop music mix
% -------------------------------------------------------------------------

% Britney Spears - Break The Ice
% [ coef, features ] = bs_bti( );
[ coef, features ] = lg_a( );
train_coefs{1} = coef;
test_features{1} = features;

% Betty Who All Of You
[ coef, features ] = bw_aoy( );
train_coefs{2} = coef;
test_features{2} = features;
 
% Britney Spears - Break The Ice
[ coef, features ] = bs_gm( );
train_coefs{3} = coef;
test_features{3} = features;

% Katy Perry - ET
[ coef, features ] = kp_et( );
train_coefs{4} = coef;
test_features{4} = features;

% Lady Gaga - Alejandro
[ coef, features ] = kp_cg( );
train_coefs{5} = coef;
test_features{5} = features;

% Oh Land - Rennesaince Girls
[ coef, features ] = ol_rg( );
train_coefs{6} = coef;
test_features{6} = features;

% Katy Perry - California Gurls
% train_coefs{7} = coef;
% test_features{7} = features;

% Create the Training Set (N-1 files)
[ Y_train, alpha_train ] = create_training_sets( train_coefs, test_features );

% -------------------------------------------------------------------------
% This is the test track that will get auto mixed in the end
% -------------------------------------------------------------------------
% Create the Test Set, (1 file)
[ ground_truth, test_features ] = bs_bti( );

% -------------------------------------------------------------------------
% Compute the Multiple Linear Regression
% -------------------------------------------------------------------------
[ predicted_coefs ] = compute_MLR( Y_train, alpha_train, test_features );

% -------------------------------------------------------------------------
% Compute the Mean Square Error
% -------------------------------------------------------------------------
[ MSE ] = mean_square_error( ground_truth, predicted_coefs );

% -------------------------------------------------------------------------
% Perform and Auto-Mix with the predicted coefficients
% -------------------------------------------------------------------------

% 2-Track Katy Perry
master = 'bs_bti_master.wav';

% Choose the stems you want to auto-mix
stems = {'bs_bti_drums.wav',...
         'bs_bti_bass.wav',...
         'bs_bti_melody.wav',...
         'bs_bti_vocals.wav'};
     
% Perform the Mix
[ auto_mix, fs ] = auto_machine_mix( master, stems, predicted_coefs );
auto_mix = auto_mix / abs(max(auto_mix));

% Write Out
audiowrite('cross_genre.wav', auto_mix, fs);

% -------------------------------------------------------------------------
% Plot the ground truth against the predicted weights for a song
% -------------------------------------------------------------------------

figure;

% Drums
subplot(4,1,1);
plot(ground_truth(1,:), 'k');
hold on;
plot(predicted_coefs(1,:), 'r');
title('DRUMS');
ylabel('Amplitude');
legend('Ground Truth','Predicted');

% Bass
subplot(4,1,2);
plot(ground_truth(2,:), 'k');
hold on;
plot(predicted_coefs(2,:), 'r');
title('BASS');
ylabel('Amplitude');

% Melody
subplot(4,1,3);
plot(ground_truth(3,:), 'k');
hold on;
plot(predicted_coefs(3,:), 'r');
title('MELODY');
ylabel('Amplitude');

% Vocals
subplot(4,1,4);
plot(ground_truth(4,:), 'k');
hold on;
plot(predicted_coefs(4,:), 'r');
title('VOCALS');
xlabel('Frames');
ylabel('Amplitude');

% -------------------------------------------------------------------------
% Plot Spectral Differences
% -------------------------------------------------------------------------

% Get averaged spectra for auto_mix and 2_track
[ X_mag, X_mag_mean, X_mag_cum, fs ] = average_spectra( 'lg_a_master.wav' );
[ X_mag_auto, X_mag_mean_auto, X_mag_cum_auto, fs ] = average_spectra( 'lg_a_master.wav', auto_mix );

% Create Frequency Vector
freq_vector = linspace(0, fs/2, length(X_mag_mean));

% Plot Against Each Other
figure;
semilogx(freq_vector, mag2db(X_mag_mean)-6, 'k');
hold on;
semilogx(freq_vector, mag2db(X_mag_mean_auto), 'r');
axis([0 22050 -20 40])
set(gca,'XTickLabel',num2str(get(gca,'XTick').'));
title('Auto Mix vs Professional Mix');
xlabel('Frequency in Hz') % x-axis label
ylabel('Magnitude (dB)') % y-axis label
legend('Human Mix','Auto Mix')

% Plot Difference
difference = abs((mag2db(X_mag_mean)-6)) - abs(mag2db(X_mag_mean_auto));
figure;
semilogx(freq_vector, difference, 'k');
axis([0 22050 0 40])
set(gca,'XTickLabel',num2str(get(gca,'XTick').'));
title('Difference Between Spectra');
xlabel('Frequency in Hz') % x-axis label
ylabel('Magnitude (dB)') % y-axis label
