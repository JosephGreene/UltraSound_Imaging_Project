%% Original Equations
c1 = 1498; %Water
c2Long = 6320; %Aluminum
c2Shear = 3130;

z1Long = 0.1498;
z2Long = 1.706;
z2Shear = 0.8451;
Rf = zeros(1,90);
Tf_l = zeros(1,90);
Tf_s = zeros(1,90);
degIn = [0:89];

for i = 1:90   
        transLong = sind(degIn(i))/c1*c2Long;
        transShear = sind(degIn(i))/c1*c2Shear;
        %First Critical Angle
        if transLong >= 1 && transShear < 1
           degOutLong = 90; %No Longitudinal Wave Transmitted
           degOutShear = asind(transShear); %Still a Shear Wave
           nShear = 2*(1/c2Long)^2/(1/c2Shear)^2; %2*pi*f factor in each cancels
           nLong = 1-nShear;
           z1LongTheta = z1Long/cosd(degIn(i));
           z2LongTheta = 0; %No Longitudinal Impedance
           z2ShearTheta = z2Shear/cosd(degOutShear);
           zIn = nLong^2*z2LongTheta+nShear^2*z2ShearTheta;

           %Reflection and Transmission
           Rf_i = (zIn-z1LongTheta)^2/(zIn+z1LongTheta)^2;
           Tf_li = 0;
           Tf_si = 4*z1LongTheta*nShear^2*z2ShearTheta/(z1LongTheta+zIn)^2; 

        %Second Critical Angle -> Total Reflection Occurs
        elseif transShear >= 1
            Rf_i = 1;
            Tf_li = 0;
            Tf_si = 0;
            degOutLong = 90;
            degOutShear = 90;

        %No Critical Angle
        else 
            %Calculate new angles and Theta dependant impedances
            degOutLong = asind(transLong);
            degOutShear = asind(transShear);
            nShear = 2*(1/c2Long)^2/(1/c2Shear)^2; %2*pi*f factor in each cancels
            nLong = 1-nShear;
            z1LongTheta = z1Long/cosd(degIn(i));
            z2LongTheta = z2Long/cosd(degOutLong);
            z2ShearTheta = z2Shear/cosd(degOutShear);
            zIn = nLong^2*z2LongTheta+nShear^2*z2ShearTheta;
            %Reflection and Transmission
            Rf_i = (zIn-z1LongTheta)^2/(zIn+z1LongTheta)^2;
            Tf_li = 4*z1LongTheta*nLong^2*z2LongTheta/(z1LongTheta+zIn)^2;
            Tf_si = 4*z1LongTheta*nShear^2*z2ShearTheta/(z1LongTheta+zIn)^2;
        end
        
        %Update Appropriate Fields
        Rf(i) = Rf_i;
        Tf_l(i) = Tf_li;
        Tf_s(i) = Tf_si;
end

figure
hold on
plot(degIn,Rf,'r')
plot(degIn,Tf_l,'b')
plot(degIn,Tf_s,'k--')
hold off

%% Updated Equations
c1 = 1498; %Water
c2Long = 6320; %Aluminum
c2Shear = 3130;

z1Long = 0.1498;
z2Long = 1.706;
z2Shear = 0.8451;
Rf = zeros(1,90);
Tf_l = zeros(1,90);
Tf_s = zeros(1,90);
degIn = [0:89];

for i = 1:90   
        transLong = sind(degIn(i))/c1*c2Long;
        transShear = sind(degIn(i))/c1*c2Shear;
        %First Critical Angle
        if transLong >= 1 && transShear < 1
           degOutLong = 90; %No Longitudinal Wave Transmitted
           degOutShear = asind(transShear); %Still a Shear Wave
           nShear = sind(degOutShear); %2*pi*f factor in each cancels
           nLong = sind(degOutLong);
           z1LongTheta = z1Long/cosd(degIn(i));
           z2LongTheta = 0; %No Longitudinal Impedance
           z2ShearTheta = z2Shear/cosd(degOutShear);
           zIn = nLong^2*z2LongTheta+nShear^2*z2ShearTheta;

           %Reflection and Transmission
           Rf_i = (zIn-z1LongTheta)^2/(zIn+z1LongTheta)^2;
           Tf_li = 0;
           Tf_si = 4*z1LongTheta*nShear^4*z2ShearTheta^2/(z1LongTheta+zIn)^2; 

        %Second Critical Angle -> Total Reflection Occurs
        elseif transShear >= 1
            Rf_i = 1;
            Tf_li = 0;
            Tf_si = 0;
            degOutLong = 90;
            degOutShear = 90;

        %No Critical Angle
        else 
            %Calculate new angles and Theta dependant impedances
            degOutLong = asind(transLong);
            degOutShear = asind(transShear);
            nShear = sind(degOutShear); %2*pi*f factor in each cancels
            nLong = sind(degOutLong);
            z1LongTheta = z1Long/cosd(degIn(i));
            z2LongTheta = z2Long/cosd(degOutLong);
            z2ShearTheta = z2Shear/cosd(degOutShear);
            zIn = nLong^2*z2LongTheta+nShear^2*z2ShearTheta;
            %Reflection and Transmission
            Rf_i = (zIn-z1LongTheta)^2/(zIn+z1LongTheta)^2;
            Tf_li = 4*z1LongTheta*nLong^4*z2LongTheta^2/(z1LongTheta+zIn)^2;
            Tf_si = 4*z1LongTheta*nShear^4*z2ShearTheta^2/(z1LongTheta+zIn)^2;
        end
        
        %Update Appropriate Fields
        Rf(i) = Rf_i;
        Tf_l(i) = Tf_li;
        Tf_s(i) = Tf_si;
end

figure
hold on
plot(degIn,Rf,'r')
plot(degIn,Tf_l,'b')
plot(degIn,Tf_s,'k--')
hold off

%% Paper Coefficients
c1 = 1498; %Water
c2Long = 6320; %Aluminum
c2Shear = 3130;

z1Long = 0.1498;
z2Long = 1.706;
z2Shear = 0.8451;
Rf = zeros(1,n);
Tf_l = zeros(1,n);
Tf_s = zeros(1,n);
degIn = [0:1:n];

for i = 1:90   
        transLong = sind(degIn(i))/c1*c2Long;
        transShear = sind(degIn(i))/c1*c2Shear;
        %First Critical Angle
        if transLong >= 1 && transShear < 1
           degOutLong = 90; %No Longitudinal Wave Transmitted
           degOutShear = asind(transShear); %Still a Shear Wave
           nShear = sind(degOutShear); %2*pi*f factor in each cancels
           nLong = sind(degOutLong);
           z1LongTheta = z1Long/cosd(degIn(i));
           z2LongTheta = 0; %No Longitudinal Impedance
           z2ShearTheta = z2Shear/cosd(degOutShear);

           %Reflection and Transmission
            Tl = 0;
            Ts = -(z1Long/c1)/(z2Shear/c2Shear)*2*z2ShearTheta*sind(2*degOutShear)/(z2LongTheta*cosd(2*degOutShear)^2+z2ShearTheta*sind(2*degOutShear)^2+z1LongTheta);
            
            Tf_li = 0;
            Tf_si = z1Long*sind(degOutShear)*tand(degIn)*abs(Ts)^2/(z2Shear*sind(degIn)*tand(degOutShear));
            Rf_i = 1-Tf_li-Tf_si;

        %Second Critical Angle -> Total Reflection Occurs
        elseif transShear >= 1
            Rf_i = 1;
            Tf_li = 0;
            Tf_si = 0;
            degOutLong = 90;
            degOutShear = 90;

        %No Critical Angle
        else 
            %Calculate new angles and Theta dependant impedances
            degOutLong = asind(transLong);
            degOutShear = asind(transShear);
            nShear = sind(degOutShear); %2*pi*f factor in each cancels
            nLong = sind(degOutLong);
            z1LongTheta = z1Long/cosd(degIn(i));
            z2LongTheta = z2Long/cosd(degOutLong);
            z2ShearTheta = z2Shear/cosd(degOutShear);

            %Reflection and Transmission
            Tl = (z1Long/c1)/(z2Shear/c2Shear)*2*z2LongTheta*cosd(2*degOutShear)/(z2LongTheta*cosd(2*degOutShear)^2+z2ShearTheta*sind(2*degOutShear)^2+z1LongTheta);
            Ts = -(z1Long/c1)/(z2Shear/c2Shear)*2*z2ShearTheta*sind(2*degOutShear)/(z2LongTheta*cosd(2*degOutShear)^2+z2ShearTheta*sind(2*degOutShear)^2+z1LongTheta);
            
            Tf_li = z1Long*sind(degOutLong)*tand(degIn)*abs(Tl)^2/(z2Long*sind(degIn)*tand(degOutLong));
            Tf_si = z1Long*sind(degOutShear)*tand(degIn)*abs(Ts)^2/(z2Shear*sind(degIn)*tand(degOutShear));
            Rf_i = 1-Tf_li-Tf_si;
        end
        
        %Update Appropriate Fields
        Rf(i) = Rf_i;
        Tf_l(i) = Tf_li;
        Tf_s(i) = Tf_si;
end

figure
hold on
plot(degIn,Rf,'r')
plot(degIn,Tf_l,'b')
plot(degIn,Tf_s,'k--')
hold off
