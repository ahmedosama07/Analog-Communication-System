function [modulatedSignal, t] = modulator(signalFiltered, fc, resamplingFactor, fs, samplingType)
%modulator Summary of this function goes here
%   This function modulates the signal according to modulation type given
%   and returns the modulated signal
Fs = resamplingFactor * fc;
resampled_signal = resample(signalFiltered,Fs,fs) ;
t = linspace(0,length(resampled_signal)/Fs,length(resampled_signal));
xc1 = cos(2*pi*fc*t);
xc = transpose(xc1);

xm = resampled_signal ;

if samplingType == "TC"
    [modulatedSignal, t] = DSBTC(xm, xc, Fs);
elseif samplingType == "SC"
    [modulatedSignal, t] = DSBSC(xm, xc, Fs);
end

