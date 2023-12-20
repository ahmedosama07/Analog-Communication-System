function [signalFilteredFreq, signalFilteredTime] = bandPassFilter(signalF, f, fc)
%bandPassFilter Summary of this function goes here
%   The function applies BPF to the signal and returns output filtered
%   signal in both time and frequency domains
N1 = floor((-1*fc-4000-min(f))/(max(f)-min(f))*length(signalF)); 
N2 = ceil(4000/(max(f)-min(f))*length(signalF)); 
N3 = N2; 
N4 = floor((2*fc-8000)/(max(f)-min(f))*length(signalF)); 
N5 = N2; 
N6 = N2; 
N7 = length(signalF) - N1 - N2 - N3 - N4 - N5 - N6; 
BPF = [zeros(N1,1);zeros(N3,1);ones(N2,1);zeros(N4,1);ones(N5,1);zeros(N6,1) ;zeros(N7,1)]; 
signalFilteredFreq=signalF.*BPF;
signalFilteredTime=real(ifft(ifftshift(signalFilteredFreq)));
end

