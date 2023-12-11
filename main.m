clc; clear;
[signal, fs] = loadSignal('eric.wav');
%sound(signal, fs)
%pause(8);
[signalFiltered, fs] = transmitterDSB(signal, fs);
%sound(real(abs(signalFiltered)),fs);
%pause(8);
fc = 100000;

[modulatedSignalTC, tTC] = modulator(signalFiltered, fc, 5, fs, "TC");
[modulatedSignalSC, tSC] = modulator(signalFiltered, fc, 5, fs, "SC");

[envelopeTC] = envelopeDetector(modulatedSignalTC);
figure(7)
plot(tTC,envelopeTC);
title('DSB-TC DEMODULATION IN THE TIME DAOMAIN USING ENVELOPE');
xlabel('time ');
ylabel('amplitude');

[envelopeSC] = envelopeDetector(modulatedSignalSC);
figure(8)
plot(tSC,envelopeSC);
title('DSB-SC DEMODULATION IN TIME DAOMAIN USING ENVELOPE');
xlabel('time ');
ylabel('amplitude');

