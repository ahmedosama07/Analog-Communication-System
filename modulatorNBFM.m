function [modulatedSignalFreq, modulatedSignalTime, f, t, scale] = modulatorNBFM(signalFiltered, fc, resamplingFactor, fs, Kf, A)
%modulatorNBFM Summary of this function goes here
%   This function modulates the signal according to NBFM modulation type 
%   given and returns the modulated signal
Fs = resamplingFactor * fc;
resampled_signal = resample(signalFiltered,Fs,fs) ;
t = linspace(0,length(resampled_signal)/Fs,length(resampled_signal));
xc1 = A .* cos(2*pi*fc*t);
xc1 = transpose(xc1);
xc2 = A .* sin(2*pi*fc*t);
xc2 = transpose(xc2);

scale = Kf * max(resampled_signal);

xm = cumsum(resampled_signal);

modulatedSignalTime = xc1 - (Kf .* xm .* xc2);

modulatedSignalFreq = fftshift(fft(real(modulatedSignalTime)));

f = linspace(-Fs/2, Fs/2, length(modulatedSignalFreq));

end

