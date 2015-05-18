% Harrison Zafrin
% stem_frame = single frame of audio
% -------------------------------------------------------------------------
% Calc loudness measurement according to ITU standard on a single window
% -------------------------------------------------------------------------
function [ LU ] = loudness_ebu( stem_frame )

% Square each element, mean over the window size, convert to dB scale
LU = 0.691 * 10*log10(mean(stem_frame.^2)+eps);

end

