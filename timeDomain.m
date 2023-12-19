function [signal, fs, t] = timeDomain(signal, fs)
%timeDomain Summary of this function goes here
%   This function used to plot the signal in time domain, it returns the
%   signal, sampling frequency and time
t = linspace( 0 , length(signal)/fs , length(signal) );
figure();
plot(t,signal);
xlabel('Time');
ylabel('Amplitude'); 
title('The signal in time domain');
end

