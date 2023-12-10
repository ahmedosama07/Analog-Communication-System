function [signal, fs, t] = loadSignal(fileName)
%loadSignal Summary of this function goes here
%   This function used to load and plot the signal in time domain, it
%   returns the signal, sampling frequency and time

[signal, fs] = audioread(fileName);
t = linspace( 0 , length(signal)/fs , length(signal) );

figure(1);
plot(t,signal);
xlabel('Time');
ylabel('Amplitude'); 
title('The signal in time domain');
end

