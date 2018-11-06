%% Parameters
clc, clf, clear, close

QPSK = [(1 + 1i) (1 - 1i) ...          
    (-1 -1i) (-1 + 1i)]/sqrt(2);

N = 999;                            % Length payload 
fc = 2.4e9;                          % Carrier frequency 

BWmax = 100e6;                       % Max bandwidth
Rb = BWmax*log2(length(QPSK));       % bit/s
Tsy = 1/BWmax;                       % s/symbol

fs = 2*BWmax;                         % Samples/s. fs > 2*BW
Ts = 1/fs;                          % s/samples
fsfsy = floor(fs/BWmax);             % samples/symbols


preamble = [1 1 1 1 1 0 0 1 1 0 1 0 1];     % Barker code

rollOff = 0.3;  % Roll-off factor 
span = 4;       % Truncation
pulse = rtrcpuls(rollOff,Tsy,fs,span);  


% Impairments - Use preamble to recover!
phi = 0;            % Phase error
f_e = 0;            % Frequency error






%% 
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         TRANSMITTER                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Generate data and symbol-map
frame = [preamble randi([0 1], 1, N)];
tmp = buffer(frame, 2);
frameIdx = bi2de(tmp', 'left-msb') + 1;
symbols = QPSK(frameIdx); 


% Upsample and pulse-shape
symbolsUP = upsample(symbols, fsfsy); 
signalBB = conv(pulse, symbolsUP); 
signalBB = signalBB/max(abs(signalBB)); 

% Mix to passband
t = (0:length(signalBB)-1)*Ts;                                % Signal contains samples
signalPB = (signalBB.*exp(-1i*2*pi*fc.*t));             % Baseband to passband


% Plots
NFFT=1024;      
L=length(signalBB);         
X= fftshift(fft(signalBB,NFFT));         
Px=X.*conj(X)/(NFFT*L);      
fVals=fs*(-NFFT/2:NFFT/2-1)/NFFT;        


% subplot(1,2,1)
% plot(fVals,10*log10(Px/max(Px)));    
% axis tight
% title('Power Spectral Density');         
% xlabel('Frequency (Hz)')         
% ylabel('Power (dB)');
% 
% 
% subplot(1,2,2)
% plot(t, signalPB)
% axis tight
% title('Passband signal')
% xlabel('Time (s)')
% ylabel('Amplitude')


%%
clc, clf, close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         RECEIVER                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add Additive White Gaussian Noise
RxSigPB = awgn(signalPB, 20, 'measured');        % 20 dB SNR

% Demodulate signal

RxSigBB = RxSigPB.*exp(1i*2*pi*fc.*t);



% Matched filter data and down-sample
MF = fliplr(conj(pulse));                             % Matched filter
MF_output = conv(pulse, RxSigBB)/fsfsy;               % Run through matched filter
MF_output = MF_output(length(MF):end-length(MF)+1);   % Remove transients
RxSymb = downsample(MF_output, fsfsy);                % Downsample


scatterplot(RxSymb)

% figure
% subplot(2,1,1)
% plot(real(RxSigPB(length(MF):end)));
% axis tight
% subplot(2,1,2);
% plot(real(MF_output));
% hold on; 
% stem(fsfsy*(0:length(rx_vec)-1),real(rx_vec));
% axis tight







