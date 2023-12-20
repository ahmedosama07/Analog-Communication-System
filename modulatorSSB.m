function [modulatedSignalFreq, modulatedSignalTime, t, f] = modulatorSSB(signalFiltered, fc, resamplingFactor, fs, filterType)
%modulatorSSB Summary of this function goes here
%   This function modulates the signal according to SSB modulation type 
%   given and returns the modulated signal
Fs = resamplingFactor * fc;
[DSBSC_Freq, DSBSC_Time, t] = modulatorDSB(signalFiltered, fc, resamplingFactor, fs, "SC");
l = length(DSBSC_Time);
f = linspace(-Fs/2,Fs/2,l);

figure()
plot(t, DSBSC_Time);
title('DSB-SC MODULATION IN TIME DOMAIN');
xlabel('time');
ylabel('magnitude');
saveas(gcf,'figures\Exp2\DSB-SC Modulated Signal - Time.png')

figure()
subplot(2, 1, 1);
plot(f,abs(DSBSC_Freq));
title('DSB-SC MODULATION MAGNITUDE IN FREQUENCY DOMAIN');
xlabel('frequency(hz)');
ylabel('magnitude');
subplot(2, 1, 2);
plot(f,angle(DSBSC_Freq));
title('DSB-SC MODULATION PHASE IN FREQUENCY DOMAIN');
xlabel('frequency(hz)');
ylabel('phase');
saveas(gcf,'figures\Exp2\DSB-SC Modulated Signal - Frequency.png')


if filterType == "bandpass"
    [modulatedSignalFreq, modulatedSignalTime] = bandPassFilter(DSBSC_Freq, f, fc);
elseif filterType == "butterworth"
    [modulatedSignalFreq, modulatedSignalTime] = butterworthFilter(DSBSC_Time, fc, Fs);

end

