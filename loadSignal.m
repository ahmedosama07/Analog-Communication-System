function [signal, fs] = loadSignal(fileName)
%loadSignal Summary of this function goes here
%   This function used to load and plot the signal in time domain, it
%   returns the signal, sampling frequency and time

[signal, fs] = audioread(fileName);
end

