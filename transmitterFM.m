function [signalFilteredFreq, signalFilteredTime, fs] = transmitterFM(signal, fs)
%transmitterFM Summary of this function goes here
%   This function represents the transmitter in an analog communication
%   system using FM
[signal, fs, ~] = timeDomain(signal, fs);
[signalF ,~, ~] = frequencyDomain(signal, fs);
[signalFilteredFreq, signalFilteredTime] = lowPassFilter(signalF,fs);
end

