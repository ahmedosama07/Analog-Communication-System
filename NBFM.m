clear;
clc;

% Importing the sound and playing it

fs = 48000 ;

[y,fs]= audioread('eric.wav') ;

sound(y,fs); % to play sound

pause(8) % to wait untill music finsh
 
% plotting the signal in time domain

t = [(1:length(y))/fs] ;

figure;

subplot(1,2,1);

plot(t,y); grid on ;

title('The Signal in Time Domain');

% converting the signal to frequency domain

Y=fftshift(fft(y));

Y_magnitude=abs(Y);

% Plotting the signal in frequency domain

fvec=linspace(-fs/2,fs/2,length(y));

subplot(1,2,2);

plot(fvec,Y_magnitude); grid on ; 

title('The Magnitude of Signal in Frequency Domain');

% low pass filter with 4KHZ ( Design a Butterworth filter:)

NoO = ceil(length(Y)*(8000)/(fs));%number of ones for frequency under 4k

NoZ = floor((length(Y)-NoO)/2);%number of zeros for frequency above 4k

LPF = [ zeros(NoZ,1) ; ones(NoO,1) ; 

zeros(length(y)-NoO-NoZ,1)];

signal_res_freq=Y.*LPF;    %pass the sound over the ideal filter

y3=real(ifft(ifftshift(signal_res_freq)));

sound(y3,fs); % Play the sound file after the filter

fprintf('the sound which received is play\n');

%Plot the output sound file in time domain 

t=linspace(0,length(y3)/fs,length(y3));

figure(3)

plot(t,y3);

xlabel('time'); ylabel('amplitude'); 

title('signal resived in time domain');

%Plot the output sound file in freq domain 

signal_res_freq_amp=abs(signal_res_freq);

signal_res_freq_phase=angle(signal_res_freq);

f_res=linspace(-fs/2,fs/2,length(y3));

figure(4)

subplot(1,2,1) 

plot(f_res,signal_res_freq_amp);

xlabel('frequency'); ylabel('amplitude'); 

title('magnitude spectrum');

subplot(1,2,2)

plot(f_res,signal_res_freq_phase);

xlabel('frequency'); ylabel('phase'); 

title('phase spectrum');

pause(8);

% Generating NBFM

fc=100000;%carrier frequency

Fs_new=500000; %sampling frequency

A=15;  %amplitude

kf=0.1;

signal_res_new= resample(y3,500,48);

t_new= 0:1/Fs_new:(1/Fs_new*length(signal_res_new)-1/Fs_new);

exact_s = A*cos((2*pi*fc*t_new)+kf.*cumsum(signal_res_new')); %as cumsum(signal_res_new') is the integerated signal

exact_f = fftshift(fft(exact_s));

exact_f_re = linspace(-Fs_new/2,Fs_new/2,length(exact_f));

figure(5);

subplot(2,1,1); 

plot(t_new,exact_s); 

title('exact NBFM signal in time domain');

subplot(2,1,2); 

plot(exact_f_re,abs(exact_f));

title('exact NBFM signal in frequency domain');

%Demodulation the signal

d= diff(exact_s);

envelop = abs(hilbert(d));

t_DM= linspace(0,(length(envelop)/Fs_new),length(envelop));

R = fftshift(fft(envelop))./length(envelop);

R_mag = abs(R);

n = length(R)/Fs_new;

f_dc = (Fs_new/2)- 1;

R((floor(f_dc*n):end-floor(f_dc*n))) = 0;

f = linspace(-Fs_new/2,Fs_new/2,length(R));

r = real(ifft(ifftshift(R))).*length(R);

figure(6)

subplot(2,1,1)

plot(t_DM,r)

title('Received signal in time domain')

subplot(2,1,2)

plot(f,R_mag)

title('Received signal in frequency domain')

out = resample(r,48,500);

sound(out,fs);

pause(8);