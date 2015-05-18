% Harrison Zafrin and Collin Chudwick
% -------------------------------------------------------------------------
% Create training sets by concatenating the features and ground truth per
% song and per instrument
% -------------------------------------------------------------------------
function [ Y_train, alpha_train ] = create_training_sets( train_coefs, test_features )

% Loop through train_coefs, each index is a new song
for i=1:length(train_coefs)
   
    % Grab a songs coefficient matrix
    song_coefs = train_coefs{i};
        
        % Each row corresponds to an instrument type         
        drums = song_coefs(1,:);
        bass  = song_coefs(2,:);
        melody = song_coefs(3,:);
        vocal = song_coefs(4,:);
        
    % If we're on the first loop, it's the first song, create alpha_train        
    if i == 1
        
        drum_train = drums;
        bass_train = bass;
        melody_train = melody;
        vocal_train = vocal;  
        
    % Otherwise, add the new coefficients horizantally to concatenate them all       
    else
        drum_train = [drum_train, drums];
        
        bass_train = [bass_train, bass];
        
        melody_train = [melody_train, melody];
        
        vocal_train = [vocal_train, vocal];
        
    end
    
end

% Now to create alpha train, we put all the coefs back into a matrix
alpha_train = [drum_train ; bass_train ; melody_train ; vocal_train];

for i=1:length(test_features)
    
    % Grab a songs feature matrix cell array
    song_features = test_features{i};
    
        % Each Cell Array is an Instrument    
        drums = song_features{1};
        bass = song_features{2};
        melody = song_features{3};
        vocal = song_features{4};

    % If we're on the first loop, it's the first song, create Y_train         	
    if i == 1
        
        Y_train{1} = drums;
        Y_train{2} = bass;
        Y_train{3} = melody;
        Y_train{4} = vocal;
        
    % Otherwise, add the new coefficients vertically to concatenate them all       
    else
        
        Y_train{1} = [Y_train{1}; drums];
        Y_train{2} = [Y_train{2}; bass];
        Y_train{3} = [Y_train{3}; melody];
        Y_train{4} = [Y_train{4}; vocal];
        
    end
    
end


end

