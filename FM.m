clc; clear;
%% Transmitter
[signal, fs] = loadSignal('eric.wav');
fprintf("Original sound is playing\n");
sound(signal, fs)
pause(8);
[signalFilteredFreq, signalFilteredTime, fs] = transmitterFM(signal, fs);

t=linspace(0,length(signalFilteredTime)/fs,length(signalFilteredTime));

figure(3);
plot(t,signalFilteredTime);
xlabel('time');
ylabel('amplitude'); 
title('Filtered signal in time domain');
saveas(gcf,'figures\Exp3\Filtered Signal - Time Domain.png');

f_received = linspace(-fs/2,fs/2,length(signalFilteredTime)) ;
magnitudeFiltered = abs(signalFilteredFreq) ;
phaseFiltered = angle(signalFilteredFreq) ;
figure(4);
subplot(2,1,1);
plot(f_received,magnitudeFiltered);
xlabel('Frequency');
ylabel('Magnitude'); 
title('magnitude of filtered signal');
saveas(gcf,'figures\Exp3\Filtered Signal Magnitude - Frequency Domain.png');

subplot(2,1,2);
plot(f_received,phaseFiltered);
xlabel('Frequency');
ylabel('Phase'); 
title('Phase of filtered signal ');
saveas(gcf,'figures\Exp3\Filtered Signal Phase - Frequency Domain.png');


fprintf("Filtered sound is playing\n");
sound(signalFilteredTime, fs)
pause(8);


fc = 100000;

Kf = input('Enter a value for Kf ');
A=input('Enter Gain Value ');
[modulatedSignal, modulatedSignalTime, f, t, scale] = modulatorNBFM(signalFilteredTime, fc, 5, fs, Kf, A);

figure()
plot(t, real(modulatedSignalTime));
title("Modulated Signal in Time Domain");
saveas(gcf,'figures\Exp3\Modulated Signal - Time Domain.png');

figure()
subplot(2,1,1);
plot(f, abs(modulatedSignal));
title("Modulated Signal Magnitude in Frequency Domain");
saveas(gcf,'figures\Exp3\Modulated Signal Magnitude - Frequency Domain.png');
subplot(2,1,2);
plot(f, angle(modulatedSignal));
title("Modulated Signal Phase in Frequency Domain");
saveas(gcf,'figures\Exp3\Modulated Signal Phrequency - Frequency Domain.png');

%% Reciever 
[envelopeNBFM] = envelopeDetector(modulatedSignalTime);

recievedNBFM = [0; diff(envelopeNBFM)];
xm = resample(recievedNBFM, fc, 5*fc);

t = linspace(0,length(xm)/fc,length(xm));
xm = xm / scale;
Xm = fftshift(fft(xm));
%[b, a] = butter(6, 4000/(fs/2), 'low');
%signalFilteredTime = filter(b, a, xm);
[signalFilteredFreq, signalFilteredTime] = lowPassFilter(Xm,fs);
%signalFilteredFreq = fftshift(fft(signalFilteredTime));
f = linspace(-(5*fc)/2, (5*fc)/2, length(signalFilteredFreq));

figure()
plot(t,signalFilteredTime);
title('NBFM DEMODULATION IN THE TIME DOMAIN');
xlabel('time ');
ylabel('amplitude');
saveas(gcf,'figures\Exp3\Demodulated Signal - Time Domain.png');

figure()
subplot(2,1,1);
plot(f,abs(signalFilteredFreq));
title('NBFM DEMODULATION MAGNITUDE IN THE FREQUENCY DOMAIN');
xlabel('frequency ');
ylabel('amplitude');
subplot(2,1,2);
plot(f,angle(signalFilteredFreq));
title('NBFM DEMODULATION PHASE IN THE FREQUENCY DOMAIN');
xlabel('frequency ');
ylabel('phase');
saveas(gcf,'figures\Exp3\Demodulated Signal - Frequency Domain.png');

sound(signalFilteredTime, fc);
pause(8);

