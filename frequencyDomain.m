function [signalF ,magnitude, phase] = frequencyDomain(signal, fs)
%frequencyDomain Summary of this function goes here
%   This function used to ]plot the signal in time domain, it returns the 
%   signal, magnitude and phase
signalF = fftshift(fft(signal));
magnitude = abs(signalF);
phase = angle(signalF);
f = linspace( -fs/2 , fs/2 , length(signalF) );

figure(2);
subplot(1,2,1);
title('signal in the frequency domain');
plot(f,magnitude);
xlabel('Frequency');
ylabel('Amplitude'); 
title('Magnitude spectrum');

subplot(1,2,2);
plot(f,phase);
xlabel('Frequency');
ylabel('Phase'); 
title('Phase spectrum');
end

