function [signalFilteredFreq, signalFilteredTime, fs] = transmitterDSB(signal, fs)
%transmitterDSB Summary of this function goes here
%   This function represents the transmitter in an analog communication
%   system using DSB
[signal, fs, ~] = timeDomain(signal, fs);
[signalF ,~, ~] = frequencyDomain(signal, fs);
[signalFilteredFreq, signalFilteredTime] = lowPassFilter(signalF,fs);
end

