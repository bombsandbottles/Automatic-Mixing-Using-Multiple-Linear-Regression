% Collin Chudwick
% stem_frame = time domain frame of a signal
% fs = sampling rate
% -------------------------------------------------------------------------
% Compute the Spectral Slope on a Window
% -------------------------------------------------------------------------

function [ SS ] = spectral_slope ( stem_frame, fs)

% Create frequency vector
f_vector = linspace(0, fs, (length(stem_frame)/2));
f_vector = f_vector';

% FFT magnitude spectrum
stem_mags = abs(fft(stem_frame));
stem_mags = stem_mags(1:(length(stem_frame)/2), 1);

% Linear Regression
lin_reg_model = polyfit(f_vector, stem_mags, 1);

SS = lin_reg_model(1);

% Test plot
% plot(f_vector, stem_mags)
% hold on
% refline( lin_reg_model(1), lin_reg_model(2))

end