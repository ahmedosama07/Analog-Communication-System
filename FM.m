clc; clear;
%% Transmitter
[signal, fs] = loadSignal('eric.wav');
fprintf("Original sound is playing\n");
sound(signal, fs)
pause(8);
[signalFilteredFreq, signalFilteredTime, fs] = transmitterDSB(signal, fs);

t=linspace(0,length(signalFilteredTime)/fs,length(signalFilteredTime));

figure(3);
plot(t,signalFilteredTime);
xlabel('time');
ylabel('amplitude'); 
title('Filtered signal in time domain');

f_received = linspace(-fs/2,fs/2,length(signalFilteredTime)) ;
magnitudeFiltered = abs(signalFilteredFreq) ;
phaseFiltered = angle(signalFilteredFreq) ;
figure(4);
subplot(1,2,1);
plot(f_received,magnitudeFiltered);
xlabel('Frequency');
ylabel('Magnitude'); 
title('magnitude of filtered signal');

subplot(1,2,2);
plot(f_received,phaseFiltered);
xlabel('Frequency');
ylabel('Phase'); 
title('Phase of filtered signal ');

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

figure()
plot(f, abs(modulatedSignal));
title("Modulated Signal Magnitude in Frequency Domain");
figure()
plot(f, angle(modulatedSignal));
title("Modulated Signal Phase in Frequency Domain");

%% Reciever 
[envelopeNBFM] = envelopeDetector(modulatedSignalTime);

recievedNBFM = zeros(length(modulatedSignalTime), 1);
recievedNBFM(2:end) = diff(envelopeNBFM);

xm = resample(recievedNBFM, fc, 5*fc);
t = linspace(0,length(xm)/(5*fc),length(xm));
xm = xm / scale;

Xm = fftshift(fft(xm));
[signalFilteredFreq, signalFilteredTime] = lowPassFilter(Xm,fs);
f = linspace(-(5*fc)/2, (5*fc)/2, length(signalFilteredFreq));

figure()
plot(t,signalFilteredTime);
title('NBFM DEMODULATION IN THE TIME DOMAIN');
xlabel('time ');
ylabel('amplitude');

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

sound(signalFilteredTime, fc);
pause(8);