% NBFM Demodulation using Envelope Detector and Differentiator

% Parameters
fs = 1000;          % Sampling frequency
fc = 100;           % Carrier frequency
fm = 10;            % Message frequency
kf = 5;             % Frequency deviation constant

% Time vector
t = 0:1/fs:1-1/fs;

% Modulate the signal
message_signal = cos(2*pi*fm*t);
modulated_signal = cos(2*pi*fc*t + kf*cumsum(message_signal)/fs);

% Add noise (optional)
snr = 200000; % Signal-to-noise ratio in dB
noisy_signal = awgn(modulated_signal, snr, 'measured');

% Demodulation using Envelope Detector and Differentiator
envelope_signal = abs(hilbert(noisy_signal));
derivative_signal = [0, diff(envelope_signal)];

% Low-pass filter to remove high-frequency noise
cutoff_frequency = 50; % Adjust as needed
[b, a] = butter(6, cutoff_frequency/(fs/2), 'low');
demodulated_signal = filtfilt(b, a, derivative_signal);

% Plotting
figure;

subplot(4,1,1);
plot(t, message_signal);
title('Message Signal');

subplot(4,1,2);
plot(t, modulated_signal);
title('Modulated Signal');

subplot(4,1,3);
plot(t, noisy_signal);
title('Noisy Signal');

subplot(4,1,4);
plot(t, demodulated_signal);
title('Demodulated Signal');

xlabel('Time (s)');
