function [freqDomain, timeDomain, f] = coherentDetection(modulatedSignal, SNR, resamplingFactor, fc, t, phase, filterType)
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


if filterType == "ideal"
    [Xm, xm] = lowPassFilter(Xm, Fs);
elseif filterType == "butter"
    [b, a] = butter(4, 2*fc/Fs);
    xm = filter(b, a, xm);
    Xm = fftshift(fft(xm));
end
    
f = linspace(-Fs/2, Fs/2, l);
freqDomain = Xm;
timeDomain = xm;
end

