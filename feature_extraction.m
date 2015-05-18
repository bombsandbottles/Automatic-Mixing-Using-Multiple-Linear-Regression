% Harrison Zafrin
% stem_frame = time domain frame of a signal
% win_size = size of the window
% fs = sampling rate
% -------------------------------------------------------------------------
% Compute the feature extraction
% -------------------------------------------------------------------------
function [ features ] = feature_extraction( filenames, x_t, frame_window, frame_overlap, fs)

% TESTINGSHORTSTEMS, 30 seconds
% x_t = round(x_t(1:end/6));

% This length will be used to zero-pad all stems to length of track
x_len = length(x_t);

% Buffer with n_overlap
x_t_buff = buffer(x_t, frame_window, frame_overlap, 'nodelay');

% Create a Cell Array filled with buffered matrices
for i=1:length(filenames)
    
    % Import Stem
    [ stem ] = import_audio( filenames{i} );

    % Make the stem and the 2-track the same length
    stem = stem(1:x_len);

    % Buffer with n_overlap
    stem_buff = buffer(stem, frame_window, frame_overlap, 'nodelay');
    
    % Put into Cell Array
    stem_data{i} = stem_buff;
    
end

% Now for each stem we extract the 3 audio features
for j=1:length(stem_data)

    % Pull out stem from stem_data cell array, curr_stem is a matrix
    curr_stem = stem_data{j};

    % Go through the frames in the stem and extract the features
    for i=1:size(curr_stem, 2)
        
        % Grab the current frame in time
        stem_frame = curr_stem(:,i);
        
        % Compute Spectral Centroid of Frame
        SC = spectral_centroid(stem_frame, fs);
        
        % Compute the Spectral Spread of a signal (Spectral Width)     
%         SW = spectral_spread( stem_frame, SC, fs );

        % Compute RMS of the Frame
        rms_val = rms(stem_frame);
        
        % Compute spectral slope
        [ SS ] = spectral_slope ( stem_frame, fs);
        
        % Create feature vector        
        feature_vector = [SC rms_val SS];
        
        % N x M matrix where M is features and N is frames
        feature_matrix(i,:) = feature_vector;

    end

    % Load feature matrix into cell array of all stems
    features{j} = feature_matrix;

end


end

