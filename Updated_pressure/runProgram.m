addpath('./pressure_scripts/');
c2 = 1.54e3;
z1 = 1;
z2 = 3;
z3 = 9;
fc = 4;
d2 = 1.5;
Rf = 0.64; %Initial reflection and transmission based on declared cond.
Tf = 0.36;
model = appModel_pressure(c2,z1,z2,z3,fc,d2,Rf,Tf);
handle = appView_pressure(model);
