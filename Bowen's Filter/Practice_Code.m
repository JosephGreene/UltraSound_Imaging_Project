%Practice Code for Filter Code
Fs = 128;
t = 5;
L = Fs*t;
dx = 1/Fs;
T = (0:L-1)*dx;
F = Fs*(0:L/2-1)/L; %Recall we are only looking at POSITIVE frequencies
Filter = ones(size(F)); %Original Filter: Allpass

%Inputs
Cutoff = 2; %MHz
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

%Signal = G(v,10);
Signal = S(1);
%Signal = SG(v,4,f);
%Signal = MT(f);

%FFT and crop
Ft = @(x) fftshift(fft(x))./max(fft(x));
iF = @(x) (ifft(ifftshift(x)));
Transform = (Ft(Signal));
t2 = Transform;
Transform = Transform(round(L/2)+1:end); %Take positive frequencies

%Generate Some Filters
%Lowpass
lp = zeros(1,length(F));
lp(F<=Cutoff) = 1;
lp(F>Cutoff) = 10.^(-Steepness*(F(F>Cutoff)-Cutoff)/20);

%Highpass
h = zeros(1,length(F));
hp(F>=Cutoff) = 1;
hp(F<Cutoff) = 10.^(Steepness*(F(F<Cutoff)-Cutoff)/20);

%Bandpass
bp = ones(1,length(F));
bp(F < Centerfreq-Width/2|F > Centerfreq+Width/2) = 0; %Zero outside width
bp(F>Centerfreq+Width/2) = 10.^(-Steepness*(F(F>Centerfreq+Width/2)-Centerfreq-Width/2)/20); %Right decay
bp(F<Centerfreq-Width/2) = 10.^(Steepness*(F(F<Centerfreq-Width/2)-Centerfreq+Width/2)/20); %Left Decay
%bp(F<= Centerfreq+Width/2) = 10.^(Steepness*(F(F<=Centerfreq+Width/2)-Centerfreq+Width/2)/20);

%BandStop
bs = ones(1,length(F));
bs(F > Centerfreq-Width/2&F < Centerfreq+Width/2) = 0; %Zero Inside band
bs(F < Centerfreq+Width/2&F > Centerfreq) = 10.^(Steepness*(F(F < Centerfreq+Width/2&F > Centerfreq)-Centerfreq-Width/2)/20); %Right decay
bs(F >= Centerfreq-Width/2&F < Centerfreq) = 10.^(-Steepness*(F(F >= Centerfreq-Width/2&F < Centerfreq)-Centerfreq+Width/2)/20);%Left Decay

%Gaussian
gf = G(Cutoff,Width);

%Look at Filters
figure
subplot(2,2,1)
plot(mag2db(lp))
title('Lowpass')
subplot(2,2,2)
plot(mag2db(hp))
title('Highpass')
subplot(2,2,3)
plot(mag2db(bp))
title('Bandpass')
subplot(2,2,4)
plot(mag2db(bs))
title('Bandstop')

% Attempt Filtering
figure
plot(Signal)
title('signal')

figure
hold on
plot(lp)
plot(abs(Transform))
hold off
title('overlay: fft & filter')
figure
plot(lp.*abs(Transform))
title('Filtering')

figure
plot(iF(Transform))
title('Output')
axis([0 F(end) 0 1])