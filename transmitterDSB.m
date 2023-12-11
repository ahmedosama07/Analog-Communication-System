function [signalFiltered, fs] = transmitterDSB(signal, fs)
%transmitterDSB Summary of this function goes here
%   This function represents the transmitter in an analog communication
%   system using DSB
[signal, fs, ~] = timeDomain(signal, fs);
[signalF ,~, ~] = frequencyDomain(signal, fs);
[signalFiltered, ~] = lowPassFilter(signal, signalF,fs);
end

