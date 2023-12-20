function [modulatedSignalFreq, modulatedSignalTime, t, f] = modulatorSSB(signalFiltered, fc, resamplingFactor, fs, filterType, modulationType)
%modulatorSSB Summary of this function goes here
%   This function modulates the signal according to SSB modulation type 
%   given and returns the modulated signal
Fs = resamplingFactor * fc;
DSBTime = 0;
DSBFreq = 0;
if modulationType == "SC"
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
    DSBFreq = DSBSC_Freq;
    DSBTime = DSBSC_Time;
elseif modulationType == "TC"
    [DSBTC_Freq, DSBTC_Time, t] = modulatorDSB(signalFiltered, fc, resamplingFactor, fs, "TC");
    l = length(DSBTC_Time);
    f = linspace(-Fs/2,Fs/2,l);

    figure()
    plot(t, DSBTC_Time);
    title('DSB-TC MODULATION IN TIME DOMAIN');
    xlabel('time');
    ylabel('magnitude');
    saveas(gcf,'figures\Exp2\DSB-TC Modulated Signal - Time.png')

    figure()
    subplot(2, 1, 1);
    plot(f,abs(DSBTC_Freq));
    title('DSB-TC MODULATION MAGNITUDE IN FREQUENCY DOMAIN');
    xlabel('frequency(hz)');
    ylabel('magnitude');
    subplot(2, 1, 2);
    plot(f,angle(DSBTC_Freq));
    title('DSB-TC MODULATION PHASE IN FREQUENCY DOMAIN');
    xlabel('frequency(hz)');
    ylabel('phase');
    saveas(gcf,'figures\Exp2\DSB-TC Modulated Signal - Frequency.png')
    DSBFreq = DSBTC_Freq;
    DSBTime = DSBTC_Time;
end

if filterType == "bandpass"
    [modulatedSignalFreq, modulatedSignalTime] = bandPassFilter(DSBFreq, f, fc);
elseif filterType == "butterworth"
    [modulatedSignalFreq, modulatedSignalTime] = butterworthFilter(DSBTime, fc, Fs);
end
end

