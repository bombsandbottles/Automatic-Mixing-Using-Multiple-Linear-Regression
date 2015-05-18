function [ frame_coef, features ] = bw_aoy( )
% -------------------------------------------------------------------------
% Create fft params structure to pass to all functions 
% -------------------------------------------------------------------------

% FFT Params for Spectrogram
field1 = 'win_size'; win_size = 1028;
field2 = 'hop_size'; hop_size = win_size/2;
field3 = 'noverlap'; noverlap = win_size - hop_size;

% Create ffrparams Structure
fftparams = struct(field1, win_size,...
                   field2, hop_size,...
                   field3, noverlap);
               
% -------------------------------------------------------------------------
% Create Frame Buffering Parameters
% -------------------------------------------------------------------------

% Import 2-Track
[x_t, fs, t] = import_audio('bw_aoy_master.wav');

% 1 Second Frames
frame_window = fs;

% 0.75 seconds of overlap
frame_overlap = fs*0.75;

% -------------------------------------------------------------------------
% 4.1 Weight Estimation
% -------------------------------------------------------------------------

% Create Stem Database
% -------------------------------------------------------------------------
filenames = {'bw_aoy_drums.wav',...
             'bw_aoy_bass.wav',...
             'bw_aoy_melody.wav',...
             'bw_aoy_vocals.wav'};

% Get the estimated ground truth weights
[ frame_coef ] = weight_estimation( filenames, x_t, frame_window, frame_overlap, fftparams );

% -------------------------------------------------------------------------
% 4.2 Feature Extraction
% -------------------------------------------------------------------------

% Returns a cell array containing feature matrices for each stem (Y)
[ features ] = feature_extraction( filenames, x_t, frame_window, frame_overlap, fs);

end

