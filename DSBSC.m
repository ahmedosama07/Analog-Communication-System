function [modulatedSignal, f] = DSBSC(xm, xc, Fs)
%DSBC Summary of this function goes here
%   This function performs DSBTC modulation for the signal
S_DSB_SC = xc.*xm ;

figure(6)
l = length(S_DSB_SC);
f = linspace(-Fs/2,Fs/2,l) ;
modulatedSignal = fftshift(fft(S_DSB_SC,l)); 

plot(f,abs(modulatedSignal));
title('DSB-SC MODULATION IN FREQUENCY DOMAIN');
xlabel('frequency(hz)');
ylabel('magnitude');
end
