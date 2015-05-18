% Harrison Zafrin
% filenames = cell array containing stems that will be weight estimated
% x_t = time domain 2-track vector on which NNLS will be performed
% -------------------------------------------------------------------------
% Ground truth weight estimation via NNLS
% -------------------------------------------------------------------------
function [ frame_coef ] = weight_estimation( filenames, x_t, frame_window, frame_overlap, fftparams )

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

% -------------------------------------------------------------------------
% For each frame we calculate a ground truth weight coefficient
% -------------------------------------------------------------------------
for i=1:size(x_t_buff, 2);
    
    % Grab Frame out of 2-track and compute STFT of said frame
    master_frame = x_t_buff(:,i);
    
    % Compute STFT
    master_stft = spectrogram(master_frame, fftparams.win_size, fftparams.noverlap);
    
    % Vectorize and Concatenate the STFT into one column V
    V = master_stft( : );
    
    % Get the mags    
    V = abs(V);
    
    % Now we do the same for all stems, STFT, Vectorize and Concatenate
    for j=1:length(stem_data)
        
        % Pull out stem from stem_data cell array, curr_stem is a matrix
        curr_stem = stem_data{j};
        
        % Grab the current frame in time
        stem_frame = curr_stem(:,i);
        
        % Compute RMS of the Frame to determine whether or not it's active
        rms_val = rms(stem_frame);
        
        % If the frame is active        
        if rms_val > 0.01
        
            % Compute STFT of current stem Frame
            stem_stft = spectrogram(stem_frame, fftparams.win_size, fftparams.noverlap);
            
            % Vectorize and Concatenate the STFT into one column U_k            
            U_stem = stem_stft( : );
            
            % Get the mags            
            U_stem = abs(U_stem);
            
        % Else the stem is not active in the current frame and does not contribute to V
        else
            
            % Negate the stem (Rachel says this is kewl to do)            
            U_stem = zeros(length(V), 1);
            
        end
        
        % Load stem into combination spectra matrix
        U_matrix(:,j) = U_stem;
        
    end
    
    % Now with U matrix and V vector, NNLS to get coefficients per frame
    weighting_coef = lsqnonneg(U_matrix, V);
    
    % This should contain the bass/vocal fader coefficients now as a test	 
    frame_coef(:,i) = weighting_coef;
    
end

% -------------------------------------------------------------------------
% Filter Curve Smoothing via Exponential Moving Average (No Kalman)
% -------------------------------------------------------------------------

% Determine degree of filtering
alpha = 0.9;

% Make output for prev_value storage
output = 0;

% Run through the EMA
for i=2:size(frame_coef, 2)
    
    % EMA = frame'(w) = alpha* frame-1'(w) + (1-alpha) * frame(w)
    frame_coef(:,i) = (alpha * output) + ((1-alpha) * frame_coef(:,i));
    output = frame_coef(:,i);
    
end

% -------------------------------------------------------------------------
% Test Plot
% -------------------------------------------------------------------------
% Test Plot for Vocals
% plot(frame_coef(2,:))

end

