addpath('./scripts/');
c2 = 1.54;
z1 = 1;
z2 = 3;
z3 = 9;
d2 = 1.5;
model = appModel_pulsewave(z1,z2,z3,c2,d2);
handle = appView_pulsewave(model);