function [modulatedSignalFreq, modulatedSignalTime] = DSBSC(xm, xc, Fs)
%DSBC Summary of this function goes here
%   This function performs DSBTC modulation for the signal
S_DSB_SC = xc.*xm ;
modulatedSignalTime = S_DSB_SC;

figure()
l = length(S_DSB_SC);
f = linspace(-Fs/2,Fs/2,l) ;
modulatedSignalFreq = fftshift(fft(S_DSB_SC,l)); 
end

