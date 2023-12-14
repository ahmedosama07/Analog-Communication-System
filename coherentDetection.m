function [freqDomain, timeDomain, f] = coherentDetection(modulatedSignal, SNR, resamplingFactor, fc, fs, t)
%coherentDetection Summary of this function goes here
%   Function implements coherent detection
Fs = resamplingFactor * fc;
xc1 = cos(2*pi*fc*t);
xc = transpose(xc1);

noise = awgn(modulatedSignal, SNR);
size(t)
size(xc)
size(noise)
xm = 2 * noise .* xc;
Xm = fftshift(fft(xm));
l = length(Xm);

[Xm, xm] = lowPassFilter(Xm, Fs);

f = linspace(-Fs/2, Fs/2, l);
freqDomain = Xm;
timeDomain = xm;
end

