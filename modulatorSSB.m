function [modulatedSignalFreq, modulatedSignalTime, t] = modulatorSSB(signalFiltered, fc, resamplingFactor, fs, filterType)
%modulatorSSB Summary of this function goes here
%   This function modulates the signal according to SSB modulation type 
%   given and returns the modulated signal
Fs = resamplingFactor * fc;
[DSBSC_Freq, DSBSC_Time, t] = modulatorDSB(signalFiltered, fc, resamplingFactor, fs, "SC");
l = length(DSBSC_Time);
f = linspace(-Fs/2,Fs/2,l);

if filterType == "bandpass"
    [modulatedSignalFreq, modulatedSignalTime] = bandPassFilter(DSBSC_Freq, f, fc);
elseif filterType == "butterworth"
    [modulatedSignalFreq, modulatedSignalTime] = butterworthFilter(DSBSC_T, fc, Fs);

end

