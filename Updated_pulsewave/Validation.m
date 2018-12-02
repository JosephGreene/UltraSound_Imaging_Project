%% 1,3,9 layers
z1 = 1;
z2 = 3;
z3 = 9;

rf21 = (z1-z2)/(z1+z2);
tf12 = 2*z2/(z1+z2);
rf23 = (z3-z2)/(z3+z2);
tf23 = 2*z3/(z2+z3);

%First Wave
w1 = tf12*tf23
%Second Wave
w2 = tf12*rf23*rf21*tf23
%Third Wave
w3 = tf12*rf23^2*rf21^2*tf23

%% 3,3,9 layers
z1 = 3;
z2 = 3;
z3 = 9;

rf21 = (z1-z2)/(z1+z2);
tf12 = 2*z2/(z1+z2);
rf23 = (z3-z2)/(z3+z2);
tf23 = 2*z3/(z2+z3);

%First Wave
w1 = tf12*tf23
%Second Wave
w2 = tf12*rf23*rf21*tf23
%Third Wave
w3 = tf12*rf23^2*rf21^2*tf23