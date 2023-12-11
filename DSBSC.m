function [modulatedSignal, f] = DSBSC(xm, xc, Fs)
%DSBC Summary of this function goes here
%   This function performs DSBTC modulation for the signal
S_DSB_SC = xc.*xm ;

figure(6)
l1l = length(S_DSB_SC);

% DSB-SC Signal in the frequency domain
f = linspace(-Fs/2,Fs/2,l1) ;
modulatedSignal = fftshift(fft(S_DSB_SC,l1)); 

plot(f,abs(modulatedSignal)) ;
title('DSB-SC MODULATION IN FREQUENCY DOMAIN');
xlabel('frequency(hz)'); ylabel('magnitude');
end

