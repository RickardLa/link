clc, clf, clear all, close all


M = 4;
k = log2(M); 
bits = randi([0 1],10*k,1);


% x = (0:M-1)';
% symbols = qammod(x, M, 'UnitAveragePower', 1);

txSig = qammod(bits,M,'InputType','bit','UnitAveragePower',true);

% scatterplot(txSig)


figure();
subplot(3,1,1)
plot(real(txSig),'-*')
title('Real part of QPSK symbols')
ylabel('Amplitude'), xlabel('Samples')

subplot(3,1,2)
plot(imag(txSig),'-*')
title('Imaginary part of QPSK symbols')
ylabel('Amplitude'), xlabel('Samples')

subplot(3,1,3)
plot(imag(txSig)+real(txSig),'-*')
