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

%sound(real(abs(signalFiltered)),fs);
%pause(8);
fc = 100000;

[modulatedSignalTC, modulatedSignalTCTime, tTC] = modulator(signalFilteredTime, fc, 5, fs, "TC");
[modulatedSignalSC, modulatedSignalSCTime, tSC] = modulator(signalFilteredTime, fc, 5, fs, "SC");

%% Reciever using ED
[envelopeTC] = envelopeDetector(modulatedSignalTCTime);
figure(14)
plot(tTC,envelopeTC);
title('DSB-TC DEMODULATION IN THE TIME DOMAIN USING ENVELOPE');
xlabel('time ');
ylabel('amplitude');

envelopeTC=resample(envelopeTC, fc, 5*fc) ;
sound(envelopeTC, fc);
pause(8);

[envelopeSC] = envelopeDetector(modulatedSignalSCTime);
figure(8)
plot(tSC,envelopeSC);
title('DSB-SC DEMODULATION IN TIME DOMAIN USING ENVELOPE');
xlabel('time ');
ylabel('amplitude');
envelopeSC=resample(envelopeSC, fc,5*fc) ;
sound(envelopeTC, fc);
pause(8);

%% Reciever using Coherent Detection
