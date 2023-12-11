function [signalFiltered, signalFilteredFreq] = lowPassFilter(signal, signalF,fs)
%lowPassFilter Summary of this function goes here
%   The function applies LPF to the signal and returns output filtered
%   signal in both time and frequency domains
NoO = ceil(length(signalF)*(8000)/(fs)) ;
NoZ = floor((length(signalF)-NoO)/2) ;
LPF = [zeros(NoZ,1); ones(NoO,1); zeros(length(signal)-NoO-NoZ,1)] ;
signalFiltered=signalF.*LPF;
signalFilteredFreq=real(ifft(ifftshift(signalFiltered)));
t=linspace(0,length(signalFilteredFreq)/fs,length(signalFilteredFreq));

figure(3);
plot(t,signalFilteredFreq);
xlabel('time');
ylabel('amplitude'); 
title('Filtered signal in time domain');

magnitudeFiltered = abs(signalFiltered) ;
phaseFiltered = angle(signalFiltered) ;
f_received = linspace(-fs/2,fs/2,length(signalFilteredFreq)) ;

figure(4);
subplot(1,2,1);
plot(f_received,magnitudeFiltered);
xlabel('Frequency');
ylabel('Magnitude'); 
title('magnitude of filtered signal');

subplot(1,2,2);
plot(f_received,phaseFiltered);
xlabel('Frequency');
ylabel('Phase'); 
title('Phase of filtered signal ');
end

