%Check program, calculates Zin, Rf, Tf for given values of impedence over 1
%wavelength of distance
z1 = 1;
z2 = 3;
z3 = 9;

for i = 1:101
    k1d = 2*pi*((i-1)/100); %Calculates k1d based on normalized wavelength d
    r(i) = ((1-(z1/z3))*cos(k1d)+1i*((z2/z3-z1/z2)*sin(k1d)))...
                /((1+(z1/z3))*cos(k1d)+1i*((z2/z3+z1/z2)*sin(k1d)));
    zin(i) = z2*(z3*cos(k1d)+1i*z2*sin(k1d))/(z2*cos(k1d)+1i*z3*sin(k1d));
end

figure
hold on
plot(0:0.01:1,abs(r).^2)
plot(0:0.01:1,1-abs(r).^2, 'Color','k')
hold off
title('reflectance curve')
legend('Reflected','Transmitted')

figure
hold on
plot(0:0.01:1,zin)
hold off
title('Input Impedence')