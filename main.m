clc; clear;
%% Transmitter
[signal, fs] = loadSignal('eric.wav');
fprintf("Original sound is playing\n");
sound(signal, fs)
pause(8);
[signalFiltered, fs] = transmitterDSB(signal, fs);
%sound(real(abs(signalFiltered)),fs);
%pause(8);
fc = 100000;

[modulatedSignalTC, modulatedSignalTCTime, tTC] = modulator(signalFiltered, fc, 5, fs, "TC");
[modulatedSignalSC, modulatedSignalSCTime, tSC] = modulator(signalFiltered, fc, 5, fs, "SC");

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

