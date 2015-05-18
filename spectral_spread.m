% Harrison Zafrin
% stem_frame = time domain frame of a signal
% SC = spectral centroid of the current stem_frame
% fs = sampling rate
% -------------------------------------------------------------------------
% Compute the Spectral Centroid on a Window
% -------------------------------------------------------------------------
function [ SS ] = spectral_spread( stem_frame, SC, fs )

% Create fk vector
hertz_vector = linspace(0, fs, length(stem_frame));
hertz_vector = hertz_vector(1:end/2);

% Get the magnitudes of the frame
stem_mags = abs(fft(stem_frame));
stem_mags = stem_mags(1:end/2);

% Calculate the numerator
numerator = sum(((hertz_vector-SC).^2).*stem_mags');

% Sum across k 
denominator = sum(stem_mags);

% Calc the SC for the window/frame
SS = numerator/denominator;

% If the frame is silent this will blow up cuz divide by zero?
SS(isnan(SS)) = 0;

end

