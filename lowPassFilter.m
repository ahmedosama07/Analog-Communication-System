function [signalFilteredFreq, signalFilteredTime] = lowPassFilter(signalF,fs)
%lowPassFilter Summary of this function goes here
%   The function applies LPF to the signal and returns output filtered
%   signal in both time and frequency domains
NoO = ceil(length(signalF)*(8000)/(fs)) ;
NoZ = floor((length(signalF)-NoO)/2) ;
LPF = [zeros(NoZ,1); ones(NoO,1); zeros(length(signalF)-NoO-NoZ,1)] ;
signalFilteredFreq=signalF.*LPF;
signalFilteredTime=real(ifft(ifftshift(signalFilteredFreq)));
end

