%  layer2.m                   T.L.Szabo    Version 3 February 2018          
% calculates pressure levels in and on boundaries  of  a layer 
% two semi-infinite media with impedances  z1 and z3 bound a layer with
%  an impedance z3 ata  frequency fc (Hz)
% T. L. Szabo February 2018  tlszabo@bu.edu
close all;
clear all;
iskip=0;
%   layer parameters
fc=4.e6;  % enter maximum frequency
nt=256;               %  number of time points
c2=1540;    % line sound speed  (m/s)
%d2=9.0e-4;  % line length  (m)
d2=7.8e-4;  % line length  (m)
z2=3.e6;     % line impedance
f0=c2/(2*d2);           % resonance frequency (MHz)
%  loading conditions
z1=1.e6;     % line impedance
z3=9e6;     % load impedance
% input variables
pi2=2*pi;
pid2=pi/2;
del=d2/(nt-1);
dd=del*(0:nt-1);
k2d=pi2*fc*dd/c2;     % distance from end to front (medium 3 to medium 1)
k2d2=pi2*fc*(d2*ones(size(dd))-dd)/c2; % distance from front to end: 1 to 3
k1d=pi2*fc*d2/c2;
rf3=(z3-z2)/(z3+z2);
tf3=2*z3/(z3+z2);
p2=exp(-i*k1d)*(exp(i*k2d)+rf3.*exp(-i*k2d));   % pressure in layer
%p2=exp(i*k2d)+rf3.*exp(-1i*k2d);   % pressure in layer   error corrected
u2=exp(-i*k1d)*((exp(i*k2d)-rf3.*exp(-i*k2d)))/z2;   %  particle  velocity in layer
zin2=p2./u2;
p1r=(zin2-z1*ones(size(dd)))./(zin2+z1*ones(size(dd)));  % reflected in 1
p2t=2*zin2./(zin2+z1*ones(size(dd)));  % transmitted into 2 
p1r0=p1r(nt);           % reflected in 1 at z=0 at first boundary
p2t0=p2t(nt);           % transmitted into 2 at z=0
p3td=p2(1)*tf3;         % transmitted into 3 at z=d
p2a=p2t0*p2;   %  corrected pressure in layer  use this one
u2a=p2t0*u2;   %  corrected displacement  in layer
% power into z3
p2in=p2t0*(exp(i*k1d)+rf3.*exp(-1i*k1d));   % pressure in layer
u2in=p2t0*(exp(i*k1d)-rf3.*exp(-i*k1d))/z2;   %  particle  velocity in layer
z2in=p2in./u2in   % input impedance looking into first boundary
% power transmitted into Z3 at second boundary
t2f3=2/((1+z1/z3)*cos(k1d)+i*(z2/z3+z1/z2)*sin(k1d));
tp23=abs(t2f3)*abs(t2f3)*(z1/z3)   % transmit into 3  use this one
%t2f3=4*(real(z3)*z2)./((real(z3)+z2).*(real(z3)+z2)+imag(z3).*imag(z3))
% power reflected at first boundary into z1 use ths one
rf1=((real(z2in)-z1).*(real(z2in)-z1)+imag(z2in)).*(imag(z2in))...
    ./((real(z2in)+z2).*(real(z2in)+z2)+imag(z2in).*imag(z2in))
dlambda=d2*fc/c2        %  layer thickness in wavelengths
%nn=nt/2+1;
figure;               %  plot results
plot(k2d2,abs(p2a),'r',0,abs(p1r0),'g',0,abs(p2t0),'b',k2d2(1),abs(p3td)...
    ,'m');
title('pressure p2 plus  boundary  values ');
xlabel('kd');
figure;               %  plot results
plot(k2d2,abs(p2a),'r');
title('pressure p2');
xlabel('kd');
