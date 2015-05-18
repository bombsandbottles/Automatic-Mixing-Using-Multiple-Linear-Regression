% Harrison Zafrin
% x_t = time domain signal
% -------------------------------------------------------------------------
% K-frequency weighting (perceptual filtering) for loudness measurement
% -------------------------------------------------------------------------
function [ x_t_kfilt ] = K_freq_weighting( x_t )

% Create Stage 1 of Pre-Filter, High Shelf Boost of +4dB at 1681hz
a1=[1,-1.69065929318241,0.73248077421585];
b1=[1.53512485958697,-2.69169618940638,1.19839281085285];
    
x_t_hishelf = filter(b1, a1, x_t);

% Create Stage 2 of Pre-Filter, high pass at 38hz
a2=[1,-1.99004745483398,0.99007225036621];
b2=[1.0,-2.0,1.0];
    
x_t_kfilt = filter(b2, a2 ,x_t_hishelf);

end

