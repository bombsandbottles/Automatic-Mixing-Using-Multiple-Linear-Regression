function [ output, fs ] = auto_machine_mix( master, stems, predicted_coefs )
% -------------------------------------------------------------------------
% Create Frame Buffering Parameters
% -------------------------------------------------------------------------

% Import 2-Track
[x_t, fs, t] = import_audio(master);

% TESTINGSHORTSTEMS, 30 seconds
x_t = round(x_t(1:end/6));

% This length will be used to zero-pad all stems to length of track
x_len = length(x_t);

% 1 Second Frames
frame_window = fs;

% 0.75 seconds of overlap
frame_overlap = fs*0.75;

% -------------------------------------------------------------------------
% Buffer the stems into 1-second frames and load into stem data cell array
% -------------------------------------------------------------------------

% Create a Cell Array filled with buffered matrices
for i=1:length(stems)
    
    % Import Stem
    [ stem ] = import_audio( stems{i} );

    % Make the stem and the 2-track the same length
    stem = stem(1:x_len);

    % Buffer with n_overlap
    stem_buff = buffer(stem, frame_window, frame_overlap, 'nodelay');
    
    % Put into Cell Array
    stem_data{i} = stem_buff;
end

% -------------------------------------------------------------------------
% Apply fader coefficients to each stem
% -------------------------------------------------------------------------

% Now for each stem we extract the 3 audio features
for j=1:length(stem_data)

    % Pull out stem from stem_data cell array, curr_stem is a matrix
    curr_stem = stem_data{j};
    
    % Pull out the coefficients which correspond to the current stem
    curr_coef = predicted_coefs(j,:);

    % Go through the frames in the stem and extract the features
    for i=1:size(curr_stem, 2)
        
        % Grab the current frame in time
        stem_frame = curr_stem(:,i);
        
        % Apply coefficient to frame        
        stem_frame = stem_frame * curr_coef(i);
        
        % Put it back into the matrix        
        curr_stem(:,i) = stem_frame;

    end

    % Put the processed buffered stem back into the stem database    
    stem_data{j} = curr_stem;

end

% Let's create the auto mix now
for i=1:length(stem_data);
    
    % Unbuffer for Overlap and Add
    % Pre-Allocate Output Vector
    track = stem_data{i};
    [win_length, num_win] = size(track);
    hop_size = 0.25*fs;
    x_t_unbuffered = zeros(((num_win-1) * hop_size)+win_length, 1);

    % Unbuffer the Windowed Kernel
    for j=1:num_win
        seg_start    = (j-1)*hop_size+1;
        seg_end      = (win_length)+(hop_size*(j-1));
        x_t_unbuffered(seg_start:seg_end)  = x_t_unbuffered(seg_start:seg_end) + track(:,j); 
    end
    
    mix(i,:) = x_t_unbuffered';
    
end

% Sum the tracks together across time
output = sum(mix);

end

