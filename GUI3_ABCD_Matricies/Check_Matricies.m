%% Validation test for ABCD_Matrix_Solver mlapp program
%% First set, Basic Elements
clear all;
clc;

%Test 1: Series resistor
Zout = 100; %Output resistor
output = zeros(1,100);
for w = 1:100
    matin = [1 100; 0 1]; %Input resistor
    mat1 = [1 200; 0 1]; %Series resistor
    matmul = matin*mat1; %Multiply
    output(w) = (Zout)/((abs(matmul(1,1)*(Zout))+abs(matmul(1,2)))); %V2/V1
end
figure
plot(1:100,output)
title('test: Series R')

%Test 2: RC circuit
Zout = 100; %Output resistor
output = zeros(1,100);
for w = 1:100
    matin = [1 100; 0 1]; %Input resistor
    mat1 = [1 200; 0 1]; %Series resistor
    mat2 = [1 -1i/(w*100*10^-6);0 1]; %Series capacitor
    matmul = matin*mat1*mat2; %Multiply
    output(w) = (Zout)/((abs(matmul(1,1)*(Zout))+abs(matmul(1,2)))); %V2/V1
end
figure
plot(1:100,output)
title('test: Series RC')

for w = 1:100
    matin = [1 100; 0 1]; %Input resistor
    mat1 = [1 200; 0 1]; %Series resistor
    mat2 = [1 0;1/(-1i/(w*100*10^-6)) 1]; %Parallel capacitor
    matmul = matin*mat1*mat2; %Multiply
    output(w) = (Zout)/((abs(matmul(1,1)*(Zout))+abs(matmul(1,2)))); %V2/V1
end
figure
plot(1:100,output)
title('test: Series R, Parallel C')

%Test 3: Series RLC (longer range to see behavior)
Zout = 100; %Output resistor
output = zeros(1,100);
for w = 1:10000
    matin = [1 100; 0 1]; %Input resistor
    mat1 = [1 200; 0 1]; %Series resistor
    mat2 = [1 -1i/(w*100*10^-6);0 1]; %Series capacitor
    mat3 = [1 1i*100*10^-3*w;0 1]; %Series Inductor
    matmul = matin*mat1*mat2*mat3; %Multiply
    output(w) = (Zout)/((abs(matmul(1,1)*(Zout))+abs(matmul(1,2)))); %V2/V1
end
figure
plot(1:10000,output)
title('test: Series RLC')

%% Second set, More complicated elements
clear all;
clc;

%Test 1: Capacitor and Transformer
Zout = 100; %Output resistor
output = zeros(1,100);
n = 10;
for w = 1:100
    matin = [1 100; 0 1]; %Input resistor
    mat1 = [1 -1i/(w*100*10^-6);0 1]; %Series Capacitor
    mat2 = [n 0; 0 1/n]; %Transformer
    matmul = matin*mat1*mat2; %Multiply
    output(w) = (Zout)/((abs(matmul(1,1)*(Zout))+abs(matmul(1,2)))); %V2/V1
end
figure
plot(1:100,output)
title('test: Series C, Transformer n = 10')

%Test 2: Capacitor and Transmission Line
Zout = 100; %Output resistor
output = zeros(1,100);
dm = 5;
km = dm;
for w = 1:100
    matin = [1 100; 0 1]; %Input resistor
    mat1 = [1 -1i/(w*100*10^-6);0 1]; %Series Capacitor
    mat2 = [cos(km*dm) 1i*100*sin(km*dm); 1i*sin(km*dm)/100 cos(km*dm)]; %Transmission Line
    matmul = matin*mat1*mat2; %Multiply
    output(w) = (Zout)/((abs(matmul(1,1)*(Zout))+abs(matmul(1,2)))); %V2/V1
end
figure
plot(1:100,output)
title('test: Series C, Transmission Line dm=km=5')