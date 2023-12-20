function [modulatedSignalFreq, modulatedSignalTime] = DSBTC(xm, xc, Fs)
%DSBTC Summary of this function goes here
%   This function performs DSBC modulation for the signal
A = 2*max(xm) ; 
S_DSB_TC = xc.*(A+xm) ;
modulatedSignalTime = S_DSB_TC;
figure()
l = length(S_DSB_TC);
f = linspace(-Fs/2, Fs/2, l);
modulatedSignalFreq = fftshift(fft(S_DSB_TC,l));

plot(f,abs(modulatedSignalFreq));
end

