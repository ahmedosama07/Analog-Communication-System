function [signalF ,magnitude, phase] = frequencyDomain(signal, fs)
%frequencyDomain Summary of this function goes here
%   This function used to ]plot the signal in time domain, it returns the 
%   signal, magnitude and phase
signalF = fftshift(fft(signal));
magnitude = abs(signalF);
phase = angle(signalF);
f = linspace( -fs/2 , fs/2 , length(signalF) );

figure();
subplot(2,1,1);
title('signal in the frequency domain');
plot(f,magnitude);
xlabel('Frequency');
ylabel('Amplitude'); 
title('Magnitude spectrum');

subplot(2,1,2);
plot(f,phase);
xlabel('Frequency');
ylabel('Phase'); 
title('Phase spectrum');
saveas(gcf,'figures\Original Signal - Frequency Domain.png')

end

