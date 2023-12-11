function [modulatedSignal, f] = DSBTC(xm, xc, Fs)
%DSBTC Summary of this function goes here
%   This function performs DSBTC modulation for the signal
A = 2*max(xm) ; 
S_DSB_TC = xc.*(A+xm) ;
 
figure(5)
l1 = length(S_DSB_TC);
f = linspace(-Fs/2,Fs/2,l1) ;
modulatedSignal = fftshift(fft(S_DSB_TC,l1)) ;

plot(f,abs(modulatedSignal)) ;
title('DSB-TC MODULATION IN FREQUENCY DOMAIN');
xlabel('frequency(hz)'); ylabel('amplitude');
end

