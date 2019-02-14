%% Input Parameters
Fs = 128;
t = 5;
L = Fs*t;
dx = 1/Fs;
T = (0:L-1)*dx;
F = Fs*(-L/2:L/2-1)/L; %Recall we are only looking at POSITIVE frequencies
Fplot = Fs*(0:L/2-1)/L;
Filter = ones(size(F)); %Original Filter: Allpass

%Inputs
Cutoff = 5; %MHz
Centerfreq = 10; %Cutoff will turn to center frequenct when band filters selected
Width = 5; %Width of Bandpass/Bandstop in MHz
Steepness = 10; %DB/MHz
v = 0.25;
f = 3;
o = 4;

%Signals and neccesary envelops
S = @(f) cos(f*2*pi*T); %Tone Burst
%MT = cos(f*2*pi*T)+cos(f*2.2*pi*T);
G = @(v,f) 1*exp(-((T-2.5)./sqrt(v)).^2).*cos(f*2*pi*T);
eG = @(v,f) 1*exp(-((T-2.5)./sqrt(v)).^2); %Envelope
SG = @(v,o,f) (1*exp(-((T-2.5)./sqrt(v)).^(o))).*cos(f*2*pi*T);
eSG =  @(v,o,f) (1*exp(-((T-2.5)./sqrt(v)).^(o)));

%FFT and crop
Ft = @(x) fftshift(fft(x))./L;
iF = @(x) ifft(ifftshift(x))*L;

%Generate Some Filters
%Lowpass
lp = zeros(1,length(Fplot));
lp(Fplot<=Cutoff) = 1;
lp(Fplot>Cutoff) = 10.^(-Steepness*(Fplot(Fplot>Cutoff)-Cutoff)/20);

%Highpass
h = zeros(1,length(Fplot));
hp(Fplot>=Cutoff) = 1;
hp(Fplot<Cutoff) = 10.^(Steepness*(Fplot(Fplot<Cutoff)-Cutoff)/20);

%Bandpass
bp = ones(1,length(Fplot));
bp(Fplot < Centerfreq-Width/2|Fplot > Centerfreq+Width/2) = 0; %Zero outside width
bp(Fplot>Centerfreq+Width/2) = 10.^(-Steepness*(Fplot(Fplot>Centerfreq+Width/2)-Centerfreq-Width/2)/20); %Right decay
bp(Fplot<Centerfreq-Width/2) = 10.^(Steepness*(Fplot(Fplot<Centerfreq-Width/2)-Centerfreq+Width/2)/20); %Left Decay
%bp(F<= Centerfreq+Width/2) = 10.^(Steepness*(F(F<=Centerfreq+Width/2)-Centerfreq+Width/2)/20);

%BandStop
bs = ones(1,length(Fplot));
bs(Fplot > Centerfreq-Width/2&Fplot < Centerfreq+Width/2) = 0; %Zero Inside band
bs(Fplot < Centerfreq+Width/2&Fplot> Centerfreq) = 10.^(Steepness*(Fplot(Fplot < Centerfreq+Width/2&Fplot > Centerfreq)-Centerfreq-Width/2)/20); %Right decay
bs(Fplot >= Centerfreq-Width/2&Fplot < Centerfreq) = 10.^(-Steepness*(Fplot(Fplot >= Centerfreq-Width/2&Fplot < Centerfreq)-Centerfreq+Width/2)/20);%Left Decay

%Gaussian
gf = G(Cutoff,Width);

%% Plot Filters
%Look at Filters
figure
subplot(2,2,1)
plot(Fplot,mag2db(lp))
title('Lowpass')
subplot(2,2,2)
plot(Fplot,mag2db(hp))
title('Highpass')
subplot(2,2,3)
plot(Fplot,mag2db(bp))
title('Bandpass')
subplot(2,2,4)
plot(Fplot,mag2db(bs))
title('Bandstop')

%% Plot Signal, Transform, and Filtered Output
S = SG(0.25,10,4);
Transform = Ft(S);
filt = hp;
flip = fliplr(filt);
full = [flip filt];

%Plot signal and transform
figure
subplot(1,3,1)
plot(T,S)
subplot(1,3,2)
plot(F,abs(Transform));
subplot(1,3,3)
plot(T,iF(Ft(S)))

%Filter 
figure
subplot(1,3,1)
hold on
plot(F,full)
plot(F,abs(Transform))
hold off
subplot(1,3,2)
plot(abs(full.*Transform))
subplot(1,3,3)
plot(real(iF((full.*Transform))))
