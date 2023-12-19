function [freqDomain, timeDomain, f] = coherentDetection(modulatedSignal, SNR, resamplingFactor, fc, t, phase)
%coherentDetection Summary of this function goes here
%   Function implements coherent detection
Fs = resamplingFactor * fc;
phase = phase * pi / 180;
xc1 = cos(2*pi*fc*t + phase);
xc = transpose(xc1);

if isstring(SNR) && SNR == "No noise"
    xm = 2 * modulatedSignal .* xc;
else
    noise = awgn(modulatedSignal, SNR);
    xm = 2 * noise .* xc;
end

Xm = fftshift(fft(xm));
l = length(Xm);

[Xm, xm] = lowPassFilter(Xm, Fs);

f = linspace(-Fs/2, Fs/2, l);
freqDomain = Xm;
timeDomain = xm;
end

