%step1
[a,fs] = audioread('eric.wav');
A=fftshift(fft(a));
A_mag=abs(A);
f_vec=linspace(-24000,24000,length(A)); %the fs=48khz is represented from -24khz to 24khz

figure;
plot(f_vec,A_mag);
title('original signal in freq domain');
%..........................................................................................
                                       %step2

Ns=length(A); %where Ns is the number of samples which is duration of the sound file * sampling freq 
A([1:171353  (length(A)-171353+1):length(A)])=0
%where we divided (the length of A)
%which is (the number of samples of A) which equals (duration of sound file*sampling freq)
%which equals (411248) by 48000 which is the sampling freq and the result
%was 8.567 so we multiplied this number by 20000(20khz)(to filter anything above 4khz)
%and the result was approximately 171353

A_mag=abs(A);                                                
figure;
plot(f_vec,A_mag);
title('filtered signal in freq domain')
%.........................................................................................
                                        %step3
a=real(ifft(ifftshift(A))); %time domain signal
N=length(a);
t=linspace(0,N/fs,N);
figure;
plot(t,a);
title('THE FILTERED SIGNAL IN TIME DOMAIN');
%........................................................................................

                                        %step4
sound(a,48000);
clear sound;
%..........................................................................................
                                        %step5                                                          
fc=100000;
newfs=5*fc;
a=resample(a,newfs,fs);
newNS=length(a);

t_new=linspace(0,newNS/newfs,newNS);

amp=max(abs(a));
carrier=cos(2*pi*fc*t_new); %THE COSINE is a row matrix since t_new is a row matrix
s=a.*transpose(carrier);      %dsb-sc  in time domain
ampC=2*amp;     % this represents the alue of A which is added in the DSB-TC

s2=ampC.*transpose(carrier)+ a.*transpose(carrier); %dsb-tc in time domain


S=fftshift(fft(s));      %dsb-sc  in freq domain
S2=fftshift(fft(s2));    %dsb-tc  in freq domain
f_vec_new=linspace(-newfs/2,newfs/2,length(S));

s_mag=abs(S);
figure;
plot(f_vec_new,s_mag);
title('DSB-SC in freq domain'); 

s_mag2=abs(S2);
figure;
plot(f_vec_new,s_mag2);
title('DSB-TC in freq domain');

%.............................................................................................
                                           %step6
                                           
envelope=abs(hilbert(s)); %dsb-sc

envelope2=abs(hilbert(s2)); %dsb-tc
%..............................................................................
                                     %step7
%figure;
%plot(t_new,envelope);
%title('message in time domain after evelope detecting DSB-SC');

%figure;
%subplot(2,1,1);
%plot(t_new,envelope2);
%title('message in time domain after evelope detecting DSB-TC');

%subplot(2,1,2);
%envelope2_dcblock=envelope2-0.405; %DC blocking
%plot(t_new,envelope2_dcblock);
%title('message in time domain after evelope detecting DSB-TC AFTER DC BLOCKING');



envelope=resample(envelope,fs,newfs);
envelope2=resample(envelope2,fs,newfs);

newN=length(envelope);
t=linspace(0,newN/fs,newN);

figure;
plot(t,envelope);
title('message in time domain after envelope detecting DSB-SC');

figure;
subplot(2,1,1);
plot(t,envelope2);
title('message in time domain after envelope detecting DSB-TC');

subplot(2,1,2);
envelope2_dcblock=envelope2-0.405; %DC blocking
plot(t,envelope2_dcblock);
title('message in time domain after envelope detecting DSB-TC AFTER DC BLOCKING');


sound(envelope,48000); %mummed voice with strange tone
clear sound;
sound(envelope2,48000);%clear regular voice as expected
clear sound;

sound(envelope2_dcblock,48000);% sound of vibrations (not the usual sound of the original file)
clear sound;
%...........................................................................................
                                  %step8

m=s.*transpose(2*carrier);

m_freq=fftshift(fft(m)); %message in freq 
m_freq([1:2107646  (length(m_freq)-2107646+1):length(m_freq)])=0; %lpf
m_time=real(ifft(ifftshift(m_freq)));%message in time

m_after_downsampling_t=resample(m_time,fs,newfs);             %downsampling signal in time
m_after_downsampling_f=fftshift(fft(m_after_downsampling_t)); %downsampling signal in freq
m_after_downsampling_f_mag=abs(m_after_downsampling_f);

N_new_m=length(m_after_downsampling_t); %it is the same as newN which was in the envelope detection section
new_t_m=linspace(0,N_new_m/fs,N_new_m);

figure;
subplot(2,1,1);
plot(new_t_m,m_after_downsampling_t);
title('received message after demodulation by coherent dsb-sc(time domain)');

NEW_f_vec=linspace(-24000,24000,length(m_after_downsampling_f_mag)); %the fs=48khz is represented from -24khz to 24khz

subplot(2,1,2);
plot(NEW_f_vec,m_after_downsampling_f_mag);
title('received message after demodulation by coherent dsb-sc(freq domain)');


mT=s2.*transpose(2*carrier)- mean(s2.*transpose(2*carrier));

mT_freq=fftshift(fft(mT)); %message in freq 
mT_freq([1:2107646  (length(mT_freq)-2107646+1):length(mT_freq)])=0; %lpf
mT_time=real(ifft(ifftshift(mT_freq)));%message in time

mT_after_downsampling_t=resample(mT_time,fs,newfs);             %downsampling signal in time
mT_after_downsampling_f=fftshift(fft(mT_after_downsampling_t)); %downsampling signal in freq
mT_after_downsampling_f_mag=abs(mT_after_downsampling_f);

N_new_mT=length(mT_after_downsampling_t); %it is the same as newN which was in the envelope detection section
new_t_mT=linspace(0,N_new_mT/fs,N_new_mT);

figure;
subplot(2,1,1);
plot(new_t_mT,mT_after_downsampling_t);
title('received message after demodulation by coherent dsb-TC(time domain)');

NEW_f_vecT=linspace(-24000,24000,length(mT_after_downsampling_f_mag)); %the fs=48khz is represented from -24khz to 24khz

subplot(2,1,2);
plot(NEW_f_vecT,mT_after_downsampling_f_mag);
title('received message after demodulation by coherent dsb-TC(freq domain)');



%*****************************************************************
x1=awgn(s,0);
x2=awgn(s,10);
x3=awgn(s,30);

x1c=x1.*transpose(2*carrier);
x2c=x2.*transpose(2*carrier);
x3c=x3.*transpose(2*carrier);

x1c_freq=fftshift(fft(x1c));
x2c_freq=fftshift(fft(x2c));
x3c_freq=fftshift(fft(x3c));


x1c_freq([1:2107646  (length(x1c_freq)-2107646+1):length(x1c_freq)])=0; %lpf
x2c_freq([1:2107646  (length(x2c_freq)-2107646+1):length(x2c_freq)])=0; %lpf
x3c_freq([1:2107646  (length(x3c_freq)-2107646+1):length(x3c_freq)])=0; %lpf

x1c_time=real(ifft(ifftshift(x1c_freq)));
x2c_time=real(ifft(ifftshift(x2c_freq)));
x3c_time=real(ifft(ifftshift(x3c_freq)));


x1c_after_downsampling_t=resample(x1c_time,fs,newfs);
x2c_after_downsampling_t=resample(x2c_time,fs,newfs);
x3c_after_downsampling_t=resample(x3c_time,fs,newfs);

x1c_after_downsampling_f=fftshift(fft(x1c_after_downsampling_t));
x2c_after_downsampling_f=fftshift(fft(x2c_after_downsampling_t));
x3c_after_downsampling_f=fftshift(fft(x3c_after_downsampling_t));

x1c_after_downsampling_f_mag=abs(x1c_after_downsampling_f);
x2c_after_downsampling_f_mag=abs(x2c_after_downsampling_f);
x3c_after_downsampling_f_mag=abs(x3c_after_downsampling_f);


N_new=length(x1c_after_downsampling_t);
new_t=linspace(0,N_new/fs,N_new);


figure;
subplot(3,1,1);
plot(new_t,x1c_after_downsampling_t);
title('DSB-SC case: SNR=0 (time domain) ');

subplot(3,1,2);
plot(new_t,x2c_after_downsampling_t);
title('DSB-SC case: SNR=10 (time domain)');

subplot(3,1,3);
plot(new_t,x3c_after_downsampling_t);
title('DSB-SC case: SNR=30 (time domain)');

%*****************************************************************************

NEW_f_vec=linspace(-24000,24000,length(x1c_after_downsampling_f_mag)); %the fs=48khz is represented from -24khz to 24khz

figure;
subplot(3,1,1);
plot(NEW_f_vec,x1c_after_downsampling_f_mag);
title('DSB-SC case: SNR=0 (freq domain) ');
subplot(3,1,2);
plot(NEW_f_vec,x2c_after_downsampling_f_mag);
title('DSB-SC case: SNR=10 (freq domain) ');
subplot(3,1,3);
plot(NEW_f_vec,x3c_after_downsampling_f_mag);
title('DSB-SC case: SNR=30 (freq domain) ');

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   DSB-TC   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

x1T=awgn(s2,0);
x2T=awgn(s2,10);
x3T=awgn(s2,30);

x1cT=x1T.*transpose(2*carrier)- mean(x1T.*transpose(2*carrier));
x2cT=x2T.*transpose(2*carrier)- mean(x2T.*transpose(2*carrier));
x3cT=x3T.*transpose(2*carrier)- mean(x3T.*transpose(2*carrier));

x1c_freqT=fftshift(fft(x1cT));
x2c_freqT=fftshift(fft(x2cT));
x3c_freqT=fftshift(fft(x3cT));


x1c_freqT([1:2107646  (length(x1c_freqT)-2107646+1):length(x1c_freqT)])=0; %lpf
x2c_freqT([1:2107646  (length(x2c_freqT)-2107646+1):length(x2c_freqT)])=0; %lpf
x3c_freqT([1:2107646  (length(x3c_freqT)-2107646+1):length(x3c_freqT)])=0; %lpf

x1c_timeT=real(ifft(ifftshift(x1c_freqT)));
x2c_timeT=real(ifft(ifftshift(x2c_freqT)));
x3c_timeT=real(ifft(ifftshift(x3c_freqT)));


x1c_after_downsampling_tT=resample(x1c_timeT,fs,newfs);
x2c_after_downsampling_tT=resample(x2c_timeT,fs,newfs);
x3c_after_downsampling_tT=resample(x3c_timeT,fs,newfs);

x1c_after_downsampling_fT=fftshift(fft(x1c_after_downsampling_tT));
x2c_after_downsampling_fT=fftshift(fft(x2c_after_downsampling_tT));
x3c_after_downsampling_fT=fftshift(fft(x3c_after_downsampling_tT));

x1c_after_downsampling_f_magT=abs(x1c_after_downsampling_fT);
x2c_after_downsampling_f_magT=abs(x2c_after_downsampling_fT);
x3c_after_downsampling_f_magT=abs(x3c_after_downsampling_fT);


N_newT=length(x1c_after_downsampling_tT);
new_tT=linspace(0,N_newT/fs,N_newT);


figure;
subplot(3,1,1);
plot(new_tT,x1c_after_downsampling_tT);
title('DSB-TC case: SNR=0 (time domain) ');

subplot(3,1,2);
plot(new_tT,x2c_after_downsampling_tT);
title('DSB-TC case: SNR=10 (time domain)');

subplot(3,1,3);
plot(new_tT,x3c_after_downsampling_tT);
title('DSB-TC case: SNR=30 (time domain)');

%*****************************************************************************

NEW_f_vecT=linspace(-24000,24000,length(x1c_after_downsampling_f_magT)); %the fs=48khz is represented from -24khz to 24khz

figure;
subplot(3,1,1);
plot(NEW_f_vecT,x1c_after_downsampling_f_magT);
title('DSB-TC case: SNR=0 (freq domain) ');
subplot(3,1,2);
plot(NEW_f_vecT,x2c_after_downsampling_f_magT);
title('DSB-TC case: SNR=10 (freq domain) ');
subplot(3,1,3);
plot(NEW_f_vecT,x3c_after_downsampling_f_magT);
title('DSB-TC case: SNR=30 (freq domain) ');



%.......................................................................................
                                    %step 9
carrier=cos(2*pi*100100*t_new);

x3=awgn(s,30);

x3c=x3.*transpose(2*carrier);

x3c_freq=fftshift(fft(x3c));

x3c_freq([1:2107646  (length(x3c_freq)-2107646+1):length(x3c_freq)])=0; %lpf

x3c_time=real(ifft(ifftshift(x3c_freq)));

x3c_after_downsampling_t=resample(x3c_time,fs,newfs);
x3c_after_downsampling_f=fftshift(fft(x3c_after_downsampling_t));
x3c_after_downsampling_f_mag=abs(x3c_after_downsampling_f);

N_new=length(x3c_after_downsampling_t);
new_t=linspace(0,N_new/fs,N_new);

NEW_f_vec=linspace(-24000,24000,length(x3c_after_downsampling_f_mag)); %the fs=48khz is represented from -24khz to 24khz

figure;

subplot(2,1,1);
plot(new_t,x3c_after_downsampling_t);
title('DSB-SC case: SNR=30 and F=100.1khz (time domain)');

subplot(2,1,2);
plot(NEW_f_vec,x3c_after_downsampling_f_mag);
title('DSB-SC case: SNR=30 and F=100.1khz(freq domain) ');


%.......................................................................................
                                    %step 10
                                    
carrier=cos(2*pi*fc*t_new+pi/9);

x3=awgn(s,30);

x3c=x3.*transpose(2*carrier);

x3c_freq=fftshift(fft(x3c));

x3c_freq([1:2107646  (length(x3c_freq)-2107646+1):length(x3c_freq)])=0; %lpf

x3c_time=real(ifft(ifftshift(x3c_freq)));

x3c_after_downsampling_t=resample(x3c_time,fs,newfs);
x3c_after_downsampling_f=fftshift(fft(x3c_after_downsampling_t));
x3c_after_downsampling_f_mag=abs(x3c_after_downsampling_f);

N_new=length(x3c_after_downsampling_t);
new_t=linspace(0,N_new/fs,N_new);

NEW_f_vec=linspace(-24000,24000,length(x3c_after_downsampling_f_mag)); %the fs=48khz is represented from -24khz to 24khz

figure;

subplot(2,1,1);
plot(new_t,x3c_after_downsampling_t);
title('DSB-SC case: SNR=30 and phase error=20 (time domain)');

subplot(2,1,2);
plot(NEW_f_vec,x3c_after_downsampling_f_mag);
title('DSB-SC case: SNR=30 and phase error=20 (freq domain) ');

                                  

