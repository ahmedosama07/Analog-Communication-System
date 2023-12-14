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

[modulatedSignalTC, modulatedSignalTCTime, tTC] = modulatorDSB(signalFilteredTime, fc, 5, fs, "TC");
[modulatedSignalSC, modulatedSignalSCTime, tSC] = modulatorDSB(signalFilteredTime, fc, 5, fs, "SC");

%% Reciever using ED
[envelopeTC] = envelopeDetector(modulatedSignalTCTime);
figure()
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
[msgFreq, msgTime, f] = coherentDetection(modulatedSignalSCTime, 0, 5, fc, tSC, 0);
figure();
subplot(2, 1, 1);
plot(f, abs(msgFreq));
title('DSB-SC DEMODULATION IN FREQUENCY DOMAIN', 'SNR = 0');
xlabel('frequency(hz)');
ylabel('amplitude');
subplot(2, 1, 2);
plot(tSC, msgTime);
title('DSB-SC DEMODULATION IN Time DOMAIN', 'SNR = 0');
xlabel('time');
ylabel('amplitude');



[msgFreq, msgTime, f] = coherentDetection(modulatedSignalSCTime, 10, 5, fc, tSC, 0);
figure();
subplot(2, 1, 1);
plot(f, abs(msgFreq));
title('DSB-SC DEMODULATION IN FREQUENCY DOMAIN', 'SNR = 10');
xlabel('frequency(hz)');
ylabel('amplitude');
subplot(2, 1, 2);
plot(tSC, msgTime);
title('DSB-SC DEMODULATION IN Time DOMAIN', 'SNR = 10');
xlabel('time');
ylabel('amplitude');



[msgFreq, msgTime, f] = coherentDetection(modulatedSignalSCTime, 30, 5, fc, tSC, 0);
figure();
subplot(2, 1, 1);
plot(f, abs(msgFreq));
title('DSB-SC DEMODULATION IN FREQUENCY DOMAIN', 'SNR = 30');
xlabel('frequency(hz)');
ylabel('amplitude');
subplot(2, 1, 2);
plot(tSC, msgTime);
title('DSB-SC DEMODULATION IN Time DOMAIN', 'SNR = 30');
xlabel('time');
ylabel('amplitude');


fe = 100;
[msgFreq, msgTime, f] = coherentDetection(modulatedSignalSCTime, "No noise", 5, fc + fe, tSC, 0);
figure();
subplot(2, 1, 1);
plot(f, abs(msgFreq));
title('DSB-SC DEMODULATION IN FREQUENCY DOMAIN', 'frequency error = 100 Hz');
xlabel('frequency(hz)');
ylabel('amplitude');
subplot(2, 1, 2);
plot(tSC, msgTime);
title('DSB-SC DEMODULATION IN Time DOMAIN', 'frequency error = 100 Hz');
xlabel('time');
ylabel('amplitude');


phase = 20;
[msgFreq, msgTime, f] = coherentDetection(modulatedSignalSCTime, "No noise", 5, fc, tSC, phase);
figure();
subplot(2, 1, 1);
plot(f, abs(msgFreq));
title('DSB-SC DEMODULATION IN FREQUENCY DOMAIN', 'phase error = 20 degree');
xlabel('frequency(hz)');
ylabel('amplitude');
subplot(2, 1, 2);
plot(tSC, msgTime);
title('DSB-SC DEMODULATION IN Time DOMAIN', 'phase error = 20 degree');
xlabel('time');
ylabel('amplitude');