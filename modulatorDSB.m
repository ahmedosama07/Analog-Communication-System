function [modulatedSignalFreq, modulatedSignalTime, t, f] = modulatorDSB(signalFiltered, fc, resamplingFactor, fs, samplingType)
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
elseif samplingType == "SC"
    [modulatedSignalFreq, modulatedSignalTime] = DSBSC(xm, xc, Fs);
end

l = length(modulatedSignalTime);
f = linspace(-Fs/2,Fs/2,l);
end

