% Harrison Zafrin
% stem_frame = single frame of audio
% -------------------------------------------------------------------------
% Calc Zero Crossing rate on a single frame of audio
% -------------------------------------------------------------------------
function [ zcr ] = zero_crossing_rate( stem_frame )

% Initialize ZCR counter
zcr = 0;

% Loop through the frame and count the ZCRs
for i = 2:length(stem_frame)
    
    % If we shifted from a pos to a neg or the other way, we crossed zero    
    if sign(stem_frame(i)) ~= sign(stem_frame(i-1))
    
        % Increase the counter
        zcr = zcr+1;
    
    end
    
end

end

