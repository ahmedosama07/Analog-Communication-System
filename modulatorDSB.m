function [modulatedSignalFreq, modulatedSignalTime, t] = modulatorDSB(signalFiltered, fc, resamplingFactor, fs, samplingType)
%modulatorDSB Summary of this function goes here
%   This function modulates the signal according to DSB modulation type 
%   given and returns the modulated signal
Fs = resamplingFactor * fc;
resampled_signal = resample(signalFiltered,Fs,fs) ;
t = linspace(0,length(resampled_signal)/Fs,length(resampled_signal));
xc1 = cos(2*pi*fc*t);
xc = transpose(xc1);

xm = resampled_signal ;

if samplingType == "TC"
    [modulatedSignalFreq, modulatedSignalTime] = DSBTC(xm, xc, Fs);
    figure()
    plot(t, modulatedSignalTime);
    title('DSB-TC MODULATION IN TIME DOMAIN');
    xlabel('time');
    ylabel('magnitude');
    saveas(gcf,'figures\Exp1\DSB-TC Modulated Signal - Time.png')

    figure()
    subplot(2, 1, 1);
    plot(f,abs(modulatedSignalFreq));
    title('DSB-TC MODULATION MAGNITUDE IN FREQUENCY DOMAIN');
    xlabel('frequency(hz)');
    ylabel('magnitude');
    subplot(2, 1, 2);
    plot(f,angle(modulatedSignalFreq));
    title('DSB-TC MODULATION PHASE IN FREQUENCY DOMAIN');
    xlabel('frequency(hz)');
    ylabel('phase');
    saveas(gcf,'figures\Exp1\DSB-TC Modulated Signal - Frequency.png')
elseif samplingType == "SC"
    [modulatedSignalFreq, modulatedSignalTime] = DSBSC(xm, xc, Fs);
    figure()
    plot(t, modulatedSignalTime);
    title('DSB-SC MODULATION IN TIME DOMAIN');
    xlabel('time');
    ylabel('magnitude');
    saveas(gcf,'figures\Exp1\DSB-SC Modulated Signal - Time.png')

    figure()
    subplot(2, 1, 1);
    plot(f,abs(modulatedSignalFreq));
    title('DSB-SC MODULATION MAGNITUDE IN FREQUENCY DOMAIN');
    xlabel('frequency(hz)');
    ylabel('magnitude');
    subplot(2, 1, 2);
    plot(f,angle(modulatedSignalFreq));
    title('DSB-SC MODULATION PHASE IN FREQUENCY DOMAIN');
    xlabel('frequency(hz)');
    ylabel('phase');
    saveas(gcf,'figures\Exp1\DSB-SC Modulated Signal - Frequency.png')
    
end

