clc; clear;
%% Transmitter
[signal, fs] = loadSignal('eric.wav');
fprintf("Original sound is playing\n");
sound(signal, fs)
pause(8);
[signalFilteredFreq, signalFilteredTime, fs] = transmitterDSB(signal, fs);

t=linspace(0,length(signalFilteredTime)/fs,length(signalFilteredTime));

figure();
plot(t,signalFilteredTime);
xlabel('time');
ylabel('amplitude'); 
title('Filtered signal in time domain');
saveas(gcf,'figures\Exp1\Filtered Signal - Time Domain.png')

f_received = linspace(-fs/2,fs/2,length(signalFilteredTime)) ;
magnitudeFiltered = abs(signalFilteredFreq) ;
phaseFiltered = angle(signalFilteredFreq) ;
figure();
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
saveas(gcf,'figures\Exp1\Filtered Signal - Frequency Domain.png')

%sound(real(abs(signalFiltered)),fs);
%pause(8);
fc = 100000;

[modulatedSignalTC, modulatedSignalTCTime, tTC, fTC] = modulatorDSB(signalFilteredTime, fc, 5, fs, "TC");
[modulatedSignalSC, modulatedSignalSCTime, tSC, fSC] = modulatorDSB(signalFilteredTime, fc, 5, fs, "SC");

figure()
plot(tTC, modulatedSignalTCTime);
title('DSB-TC MODULATION IN TIME DOMAIN');
xlabel('time');
ylabel('magnitude');
saveas(gcf,'figures\Exp1\DSB-TC Modulated Signal - Time.png')

figure()
subplot(2, 1, 1);
plot(fTC,abs(modulatedSignalTC));
title('DSB-TC MODULATION MAGNITUDE IN FREQUENCY DOMAIN');
xlabel('frequency(hz)');
ylabel('magnitude');
subplot(2, 1, 2);
plot(fTC,angle(modulatedSignalTC));
title('DSB-TC MODULATION PHASE IN FREQUENCY DOMAIN');
xlabel('frequency(hz)');
ylabel('phase');
saveas(gcf,'figures\Exp1\DSB-TC Modulated Signal - Frequency.png')

figure()
plot(tSC, modulatedSignalSCTime);
title('DSB-SC MODULATION IN TIME DOMAIN');
xlabel('time');
ylabel('magnitude');
saveas(gcf,'figures\Exp1\DSB-SC Modulated Signal - Time.png')

figure()
subplot(2, 1, 1);
plot(fSC,abs(modulatedSignalSC));
title('DSB-SC MODULATION MAGNITUDE IN FREQUENCY DOMAIN');
xlabel('frequency(hz)');
ylabel('magnitude');
subplot(2, 1, 2);
plot(fSC,angle(modulatedSignalSC));
title('DSB-SC MODULATION PHASE IN FREQUENCY DOMAIN');
xlabel('frequency(hz)');
ylabel('phase');
saveas(gcf,'figures\Exp1\DSB-SC Modulated Signal - Frequency.png')


%% Reciever using ED
[envelopeTC] = envelopeDetector(modulatedSignalTCTime);
figure();
plot(tTC,envelopeTC);
title('DSB-TC DEMODULATION IN THE TIME DOMAIN USING ENVELOPE DETECTOR');
xlabel('time ');
ylabel('amplitude');
saveas(gcf,'figures\Exp1\DSB-TC Demodulated Signal Using ED - Time Domain.png')

l = length(envelopeTC);
f = linspace(-(5*fc)/2,(5*fc)/2,l);
figure();
subplot(2, 1, 1);
plot(f, abs(fftshift(fft(envelopeTC))));
title('DSB-TC DEMODULATION IN FREQUENCY DOMAIN USING ENVELOPE DETECTOR', 'SNR = 0');
xlabel('frequency(hz)');
ylabel('amplitude');
subplot(2, 1, 2);
plot(f, angle(fftshift(fft(envelopeTC))));
title('DSB-TC DEMODULATION IN Time DOMAIN USING ENVELOPE DETECTOR', 'SNR = 0');
xlabel('time');
ylabel('amplitude');
saveas(gcf,'figures\Exp1\DSB-TC Demodulated Signal USING ENVELOPE DETECTOR.png')

envelopeTC=resample(envelopeTC, fc, 5*fc) ;
fprintf("DSBTC Recieved using ED sound is playing\n");
sound(envelopeTC, fc);
pause(8);

[envelopeSC] = envelopeDetector(modulatedSignalSCTime);
figure();
plot(tSC,envelopeSC);
title('DSB-SC DEMODULATION IN TIME DOMAIN USING ENVELOPE');
xlabel('time ');
ylabel('amplitude');
saveas(gcf,'figures\Exp1\DSB-SC Demodulated Signal Using ED - Time Domain.png')

l = length(envelopeSC);
f = linspace(-(5*fc)/2,(5*fc)/2,l);
figure();
subplot(2, 1, 1);
plot(f, abs(fftshift(fft(envelopeSC))));
title('DSB-SC DEMODULATION IN FREQUENCY DOMAIN USING ENVELOPE DETECTOR', 'SNR = 0');
xlabel('frequency(hz)');
ylabel('amplitude');
subplot(2, 1, 2);
plot(f, angle(fftshift(fft(envelopeSC))));
title('DSB-SC DEMODULATION IN Time DOMAIN USING ENVELOPE DETECTOR', 'SNR = 0');
xlabel('time');
ylabel('amplitude');
saveas(gcf,'figures\Exp1\DSB-SC Demodulated Signal USING ENVELOPE DETECTOR.png')


envelopeSC=resample(envelopeSC, fc,5*fc) ;
fprintf("DSBSC Recieved using ED sound is playing\n");
sound(envelopeSC, fc);
pause(8);

%% Reciever using Coherent Detection
%DSB-SC
[msgFreq, msgTime, f] = coherentDetection(modulatedSignalSCTime, "No noise", 5, fc, tSC, 0);
figure();
subplot(2, 1, 1);
plot(f, abs(msgFreq));
title('DSB-SC DEMODULATION IN FREQUENCY DOMAIN', 'No noise');
xlabel('frequency(hz)');
ylabel('amplitude');
subplot(2, 1, 2);
plot(tSC, msgTime);
title('DSB-SC DEMODULATION IN Time DOMAIN', 'No noise');
xlabel('time');
ylabel('amplitude');
saveas(gcf,'figures\Exp1\DSB-SC Demodulated Signal [No noise].png')
msgTime=resample(msgTime, fc,5*fc) ;
fprintf("DSBSC Recieved using CD [No noise] sound is playing\n");
sound(msgTime, fc);
pause(8);

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
saveas(gcf,'figures\Exp1\DSB-SC Demodulated Signal 0 SNR.png')
msgTime=resample(msgTime, fc,5*fc) ;
fprintf("DSBSC Recieved using CD [SNR = 0] sound is playing\n");
sound(msgTime, fc);
pause(8);


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
saveas(gcf,'figures\Exp1\DSB-SC Demodulated Signal 10 SNR.png')
fprintf("DSBSC Recieved using CD [SNR = 10] sound is playing\n");
sound(msgTime, fc);
pause(8);


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
saveas(gcf,'figures\Exp1\DSB-SC Demodulated Signal 30 SNR.png')
fprintf("DSBSC Recieved using CD [SNR = 30] sound is playing\n");
sound(msgTime, fc);
pause(8);

fe = 100;
[msgFreq, msgTime, f] = coherentDetection(modulatedSignalSCTime, 30, 5, fc + fe, tSC, 0);
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
saveas(gcf,'figures\Exp1\DSB-SC Demodulated Signal frequency error 100 Hz.png')
fprintf("DSBSC Recieved using CD [fe = 100 Hz] sound is playing\n");
sound(msgTime, fc);
pause(8);

phase = 20;
[msgFreq, msgTime, f] = coherentDetection(modulatedSignalSCTime, 30, 5, fc, tSC, phase);
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
saveas(gcf,'figures\Exp1\DSB-SC Demodulated Signal phase error 20 degree.png')
fprintf("DSBSC Recieved using CD [phase error = 20] sound is playing\n");
sound(msgTime, fc);
pause(8);

% DSB-TC
[msgFreq, msgTime, f] = coherentDetection(modulatedSignalTCTime, "No noise", 5, fc, tTC, 0);
figure();
subplot(2, 1, 1);
plot(f, abs(msgFreq));
title('DSB-TC DEMODULATION IN FREQUENCY DOMAIN', '[No noise]');
xlabel('frequency(hz)');
ylabel('amplitude');
subplot(2, 1, 2);
plot(tTC, msgTime);
title('DSB-TC DEMODULATION IN Time DOMAIN', '[No noise]');
xlabel('time');
ylabel('amplitude');
saveas(gcf,'figures\Exp1\DSB-TC Demodulated Signal 0 SNR.png')
fprintf("DSBTC Recieved using CD [No noise] sound is playing\n");
sound(msgTime, fc);
pause(8);

[msgFreq, msgTime, f] = coherentDetection(modulatedSignalTCTime, 0, 5, fc, tTC, 0);
figure();
subplot(2, 1, 1);
plot(f, abs(msgFreq));
title('DSB-TC DEMODULATION IN FREQUENCY DOMAIN', 'SNR = 0');
xlabel('frequency(hz)');
ylabel('amplitude');
subplot(2, 1, 2);
plot(tTC, msgTime);
title('DSB-TC DEMODULATION IN Time DOMAIN', 'SNR = 0');
xlabel('time');
ylabel('amplitude');
saveas(gcf,'figures\Exp1\DSB-TC Demodulated Signal 0 SNR.png')
fprintf("DSBTC Recieved using CD [SNR = 0] sound is playing\n");
sound(msgTime, fc);
pause(8);


[msgFreq, msgTime, f] = coherentDetection(modulatedSignalTCTime, 10, 5, fc, tTC, 0);
figure();
subplot(2, 1, 1);
plot(f, abs(msgFreq));
title('DSB-TC DEMODULATION IN FREQUENCY DOMAIN', 'SNR = 10');
xlabel('frequency(hz)');
ylabel('amplitude');
subplot(2, 1, 2);
plot(tTC, msgTime);
title('DSB-TC DEMODULATION IN Time DOMAIN', 'SNR = 10');
xlabel('time');
ylabel('amplitude');
saveas(gcf,'figures\Exp1\DSB-TC Demodulated Signal 10 SNR.png')
fprintf("DSBTC Recieved using CD [SNR = 10] sound is playing\n");
sound(msgTime, fc);
pause(8);


[msgFreq, msgTime, f] = coherentDetection(modulatedSignalTCTime, 30, 5, fc, tTC, 0);
figure();
subplot(2, 1, 1);
plot(f, abs(msgFreq));
title('DSB-TC DEMODULATION IN FREQUENCY DOMAIN', 'SNR = 30');
xlabel('frequency(hz)');
ylabel('amplitude');
subplot(2, 1, 2);
plot(tTC, msgTime);
title('DSB-TC DEMODULATION IN Time DOMAIN', 'SNR = 30');
xlabel('time');
ylabel('amplitude');
saveas(gcf,'figures\Exp1\DSB-TC Demodulated Signal 30 SNR.png')
fprintf("DSBTC Recieved using CD [SNR = 30] sound is playing\n");
sound(msgTime, fc);
pause(8);

fe = 100;
[msgFreq, msgTime, f] = coherentDetection(modulatedSignalTCTime, 30, 5, fc + fe, tTC, 0);
figure();
subplot(2, 1, 1);
plot(f, abs(msgFreq));
title('DSB-TC DEMODULATION IN FREQUENCY DOMAIN', 'frequency error = 100 Hz');
xlabel('frequency(hz)');
ylabel('amplitude');
subplot(2, 1, 2);
plot(tTC, msgTime);
title('DSB-TC DEMODULATION IN Time DOMAIN', 'frequency error = 100 Hz');
xlabel('time');
ylabel('amplitude');
saveas(gcf,'figures\Exp1\DSB-TC Demodulated Signal frequency error 100 Hz.png')
fprintf("DSBTC Recieved using CD [fe = 100 Hz] sound is playing\n");
sound(msgTime, fc);
pause(8);

phase = 20;
[msgFreq, msgTime, f] = coherentDetection(modulatedSignalTCTime, 30, 5, fc, tTC, phase);
figure();
subplot(2, 1, 1);
plot(f, abs(msgFreq));
title('DSB-TC DEMODULATION IN FREQUENCY DOMAIN', 'phase error = 20 degree');
xlabel('frequency(hz)');
ylabel('amplitude');
subplot(2, 1, 2);
plot(tTC, msgTime);
title('DSB-TC DEMODULATION IN Time DOMAIN', 'phase error = 20 degree');
xlabel('time');
ylabel('amplitude');
saveas(gcf,'figures\Exp1\DSB-TC Demodulated Signal phase error 20 degree.png')
fprintf("DSBTC Recieved using CD [phase error = 20] sound is playing\n");
sound(msgTime, fc);
pause(8);