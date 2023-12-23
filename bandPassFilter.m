function [signalFilteredFreq, signalFilteredTime] = bandPassFilter(signalF, fc, Fs)
%bandPassFilter Summary of this function goes here
%   The function applies BPF to the signal and returns output filtered
%   signal in both time and frequency domains
f = linspace(-Fs/2, Fs/2, length(signalF));
index = f>=fc+1;
signalFilteredFreq = signalF;
signalFilteredFreq(index) = 0;

index2 = f<=(-fc);
signalFilteredFreq(index2) = 0;
signalFilteredTime=real(ifft(ifftshift(signalFilteredFreq)));
end

