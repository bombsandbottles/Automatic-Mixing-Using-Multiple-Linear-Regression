% Harrison Zafrin
% stem_frame = time domain frame of a signal
% fs = sampling rate
% -------------------------------------------------------------------------
% Compute the Spectral Centroid on a Window
% -------------------------------------------------------------------------
function [ SC ] = spectral_centroid( stem_frame, fs )

% Create fk vector
hertz_vector = linspace(0, fs, length(stem_frame));
hertz_vector = hertz_vector(1:end/2);

% Get the magnitudes of the frame
stem_mags = abs(fft(stem_frame));
stem_mags = stem_mags(1:end/2);

% Calculate the numerator
numerator = hertz_vector.*stem_mags';

% Sum across k
numerator = sum(numerator);

% Sum across k 
denominator = sum(stem_mags);

% Calc the SC for the window/frame
SC = numerator/denominator;

% If the frame is silent this will blow up cuz divide by zero?
SC(isnan(SC)) = 0;

end

