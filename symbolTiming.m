clear all; clc;
n=10; %Number of data symbols
Tsym=8; %Symbol time interms of sample time or oversampling rate equivalently
%data=2*(rand(n,1)&lt;0.5)-1;
data=[1 -1 1 -1 1 -1 1 -1 1 -1]'; %BPSK data
bpsk=reshape(repmat(data,1,Tsym)',n*Tsym,1); %BPSK signal

figure('Color',[1 1 1]);
subplot(3,1,1);
plot(bpsk);
title('Ideal BPSK symbols');
xlabel('Sample index [n]');
ylabel('Amplitude')
set(gca,'XTick',0:8:80);
axis([1 80 -2 2]); grid on;


noise=0.25*randn(size(bpsk)); %Adding some amount of noise
received=bpsk+noise; %Received signal with noise

subplot(3,1,2);
plot(received);
title('Transmitted BPSK symbols (with noise)');
xlabel('Sample index [n]');
ylabel('Amplitude')
set(gca,'XTick',0:8:80);
axis([1 80 -2 2]); grid on;


impRes=[0.5 ones(1,6) 0.5]; %Averaging Filter -&gt; u[n]-u[n-Tsamp]
yy=conv(received,impRes,'full');
subplot(3,1,3);
plot(yy);
title('Matched Filter (Averaging Filter) output');
xlabel('Sample index [n]');
ylabel('Amplitude');

set(gca,'XTick',0:8:80);
axis([1 80 -10 10]); grid on;