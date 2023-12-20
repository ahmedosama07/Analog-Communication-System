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

%sound(real(abs(signalFiltered)),fs);
%pause(8);
fc = 100000;

[modulatedSignalBP, modulatedSignalBPTime, tBP, fBP] = modulatorSSB(signalFilteredTime, fc, 5, fs, "bandpass", "SC");
[modulatedSignalButter, modulatedSignalButterTime, tButter, fButter] = modulatorSSB(signalFilteredTime, fc, 5, fs, "butterworth", "SC");

figure();
plot(tBP, modulatedSignalBPTime);
xlabel('time');
ylabel('amplitude'); 
title('Modulated SSB-SC signal in time domain', '[Ideal BPF]');
saveas(gcf,'figures\Exp2\SSB-SC Modulated Signal - Time [Ideal BPF].png')

figure();
subplot(2, 1, 1);
plot(fBP,abs(modulatedSignalBP));
title('SSB-SC MODULATION MAGNITUDE IN FREQUENCY DOMAIN', '[Ideal BPF]');
xlabel('frequency(hz)');
ylabel('magnitude');
subplot(2, 1, 2);
plot(fBP,angle(modulatedSignalBP));
title('SSB-SC MODULATION PHASE IN FREQUENCY DOMAIN', '[Ideal BPF]');
xlabel('frequency(hz)');
ylabel('phase');
saveas(gcf,'figures\Exp2\SSB-SC Modulated Signal - Frequency [Ideal BPF].png')


figure();
plot(tButter, modulatedSignalButterTime);
xlabel('time');
ylabel('amplitude'); 
title('Modulated SSB-SC signal in time domain', '[Fourth order Butterworth BPF]');
saveas(gcf,'figures\Exp2\SSB-SC Modulated Signal - Time [Fourth order Butterworth BPF].png')

figure();
subplot(2, 1, 1);
plot(fButter,abs(modulatedSignalButter));
title('SSB-SC MODULATION MAGNITUDE IN FREQUENCY DOMAIN', '[Fourth order Butterworth BPF]');
xlabel('frequency(hz)');
ylabel('magnitude');
subplot(2, 1, 2);
plot(fButter,angle(modulatedSignalButter));
title('SSB-SC MODULATION PHASE IN FREQUENCY DOMAIN', '[Fourth order Butterworth BPF]');
xlabel('frequency(hz)');
ylabel('phase');
saveas(gcf,'figures\Exp2\SSB-SC Modulated Signal - Frequency [Fourth order Butterworth BPF].png')

%% Reciever using Coherent Detection Ideal
[msgFreq, msgTime, f] = coherentDetection(modulatedSignalBPTime, "No noise", 5, fc, tBP, 0, 'ideal');
figure();
subplot(2, 1, 1);
plot(f, abs(msgFreq));
title('SSB-SC DEMODULATION IN FREQUENCY DOMAIN', '[Ideal BPF]');
xlabel('frequency(hz)');
ylabel('amplitude');
subplot(2, 1, 2);
plot(tBP, msgTime);
title('SSB-SC DEMODULATION IN Time DOMAIN', '[Ideal BPF]');
xlabel('time');
ylabel('amplitude');
saveas(gcf,'figures\Exp2\SSB-SC Demodulated Signal [No nise] [Ideal LPF].png')
msgTime=resample(msgTime, fc,5*fc) ;
sound(msgTime, fc);
pause(8)

[msgFreq, msgTime, f] = coherentDetection(modulatedSignalBPTime, 0, 5, fc, tBP, 0, 'ideal');
figure();
subplot(2, 1, 1);
plot(f, abs(msgFreq));
title('DSB-SC DEMODULATION IN FREQUENCY DOMAIN', '[Ideal LPF] - [SNR = 0]');
xlabel('frequency(hz)');
ylabel('amplitude');
subplot(2, 1, 2);
plot(tBP, msgTime);
title('DSB-SC DEMODULATION IN Time DOMAIN', '[Ideal LPF] - [SNR = 0]');
xlabel('time');
ylabel('amplitude');
saveas(gcf,'figures\Exp2\SSB-SC Demodulated Signal [SNR = 0] [Ideal LPF].png')
msgTime=resample(msgTime, fc,5*fc) ;
sound(msgTime, fc);
pause(8)

[msgFreq, msgTime, f] = coherentDetection(modulatedSignalBPTime, 10, 5, fc, tBP, 0, 'ideal');
figure();
subplot(2, 1, 1);
plot(f, abs(msgFreq));
title('DSB-SC DEMODULATION IN FREQUENCY DOMAIN', '[Ideal LPF] - [SNR = 10]');
xlabel('frequency(hz)');
ylabel('amplitude');
subplot(2, 1, 2);
plot(tBP, msgTime);
title('DSB-SC DEMODULATION IN Time DOMAIN', '[Ideal LPF] - [SNR = 10]');
xlabel('time');
ylabel('amplitude');
saveas(gcf,'figures\Exp2\SSB-SC Demodulated Signal [SNR = 10] [Ideal LPF].png')
msgTime=resample(msgTime, fc,5*fc) ;
sound(msgTime, fc);
pause(8)

[msgFreq, msgTime, f] = coherentDetection(modulatedSignalBPTime, 30, 5, fc, tBP, 0, 'ideal');
figure();
subplot(2, 1, 1);
plot(f, abs(msgFreq));
title('DSB-SC DEMODULATION IN FREQUENCY DOMAIN', '[Ideal LPF] - [SNR = 30]');
xlabel('frequency(hz)');
ylabel('amplitude');
subplot(2, 1, 2);
plot(tBP, msgTime);
title('DSB-SC DEMODULATION IN Time DOMAIN', '[Ideal LPF] - [SNR = 30]');
xlabel('time');
ylabel('amplitude');
saveas(gcf,'figures\Exp2\SSB-SC Demodulated Signal [SNR = 30] [Ideal LPF].png')
msgTime=resample(msgTime, fc,5*fc) ;
sound(msgTime, fc);
pause(8)
%% Reciever using Coherent Detection Butter
[msgFreq, msgTime, f] = coherentDetection(modulatedSignalButterTime, "No noise", 5, fc, tBP, 0, 'butter');
figure();
subplot(2, 1, 1);
plot(f, abs(msgFreq));
title('SSB-SC DEMODULATION IN FREQUENCY DOMAIN', '[Butterworth BPF]');
xlabel('frequency(hz)');
ylabel('amplitude');
subplot(2, 1, 2);
plot(tBP, msgTime);
title('SSB-SC DEMODULATION IN Time DOMAIN', '[Butterworth BPF]');
xlabel('time');
ylabel('amplitude');
saveas(gcf,'figures\Exp2\SSB-SC Demodulated Signal [No nise] [Butterworth LPF].png')

msgTime=resample(msgTime, fc,5*fc) ;
sound(msgTime, fc);
pause(8)
%% SSB - TC modulation
[modulatedSignalBP, modulatedSignalBPTime, tBP, fBP] = modulatorSSB(signalFilteredTime, fc, 5, fs, "bandpass", "TC");
figure();
plot(tBP, modulatedSignalBPTime);
xlabel('time');
ylabel('amplitude'); 
title('Modulated SSB-TC signal in time domain', '[Ideal BPF]');
saveas(gcf,'figures\Exp2\SSB-TC Modulated Signal - Time [Ideal BPF].png')

figure();
subplot(2, 1, 1);
plot(fBP,abs(modulatedSignalBP));
title('SSB-TC MODULATION MAGNITUDE IN FREQUENCY DOMAIN', '[Ideal BPF]');
xlabel('frequency(hz)');
ylabel('magnitude');
subplot(2, 1, 2);
plot(fBP,angle(modulatedSignalBP));
title('SSB-TC MODULATION PHASE IN FREQUENCY DOMAIN', '[Ideal BPF]');
xlabel('frequency(hz)');
ylabel('phase');
saveas(gcf,'figures\Exp2\SSB-TC Modulated Signal - Frequency [Ideal BPF].png')

%% Reciever using ED
[envelopeTC] = envelopeDetector(modulatedSignalBPTime);
figure()
plot(tBP,envelopeTC);
title('SSB-TC DEMODULATION IN THE TIME DOMAIN USING ENVELOPE');
xlabel('time');
ylabel('amplitude');
saveas(gcf,'figures\Exp2\SSB-TC Demodulated Signal - Frequency [Ideal LPF].png')

envelopeTC=resample(envelopeTC, fc, 5*fc) ;
sound(envelopeTC, fc);
pause(8);