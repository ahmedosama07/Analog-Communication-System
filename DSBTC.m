function [modulatedSignal, f] = DSBTC(xm, xc, Fs)
%DSBTC Summary of this function goes here
%   This function performs DSBC modulation for the signal
A = 2*max(xm) ; 
S_DSB_TC = xc.*(A+xm) ;
 
figure(5)
l = length(S_DSB_TC);
f = linspace(-Fs/2,Fs/2,l) ;
modulatedSignal = fftshift(fft(S_DSB_TC,l)) ;

plot(f,abs(modulatedSignal)) ;
title('DSB-TC MODULATION IN FREQUENCY DOMAIN');
xlabel('frequency(hz)'); ylabel('amplitude');
end

