function [signalFilteredFreq, signalFilteredTime] = butterworthFilter(signalT, fc, Fs)
%butterworthFilter Summary of this function goes here
%   The function applies fourth degree Butterworth BPF to the signal and 
%   returns output filtered signal in both time and frequency domains
[b, a] = butter(4, [(fc - 4000)/(Fs/2) fc/(Fs / 2)], 'banddpass');
signalFilteredTime = filter(b, a, signalT);
signalFilteredFreq = fftshift(fft(signalFilteredTime));
end