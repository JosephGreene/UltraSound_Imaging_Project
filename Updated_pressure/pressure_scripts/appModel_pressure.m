classdef appModel_pressure < handle
    properties
        % material properties
        c2 = 1540; %I define this to remove a redundant slider
   
        z1
        z2
        z3
        % simulation settings
        fc = 4; %I define this to remove a redundant slider
        d2
        
        %First layer reflection, last layer transmission
        Rf
        Tf
        
        % refraction
        rfColor
        tfColor
        
        % colorMat to show
        colorMat
        
        % pressure signal 
        p2

    end
    events
       ready
       mediumUpdated
    end % end of events
    methods
        
	function obj = appModel_pressure(c2,z1,z2,z3,fc,d2,Rf,Tf)
        obj.c2 = c2;
 
        obj.z1 = z1;
        obj.z2 = z2;
        obj.z3 = z3;
        
        obj.fc = fc;
        obj.d2 = d2;
        obj.Rf = Rf;
        obj.Tf = Tf;
        
        obj.updateSettings(c2, z1, z2, z3, fc, d2);    
    end
    
    function updateSettings(obj, c2, z1, z2, z3, fc, d2)
        % Update the object properties for debug.
        obj.c2 = c2;

        obj.z1 = z1;
        obj.z2 = z2;
        obj.z3 = z3;
        
        obj.fc = fc;
        % maximum frequency, convert unit from MHz to Hz
        fc=fc*1e6; 
        
        % layer 2 thickness, convert unit from mm to m
        obj.d2 = d2;
        
        % Wavelength
        lambda = c2/fc; % unit: m
        d2=d2*lambda;  % line length  (m)
        
        
        % loading conditions / acoustic impedance, convert unit from 
        % MegaRayls to Rayls
        z1=z1*1e6;     % line impedance (Rayls) of 1st layer
        z2=z2*1e6;     % line impedance (Rayls) of 2nd layer
        z3=z3*1e6;     % load impedance (Rayls) of 3rd layer 
        
        nt=258;             %  number of time points
        % input variables
        pi2=2*pi;
        del=d2/(nt-1);
        dd=del*(0:1:nt-1);
        k2d= 2*pi*dd/lambda;     % distance from end to front (medium 3 to medium 1)
        k1d= 2*pi*d2/lambda;
        rf3=(z3-z2)/(z3+z2); %Reflectance 

        %p2=exp(1i*k1d)*(exp(1i*k2d)+rf3.*exp(-1i*k2d));   % pressure in layer
        p2=exp(i*k2d)+rf3.*exp(-1i*k2d);  % pressure in layer   error corrected
        %check = [p2(1) p2(end)];
        u2=exp(-1i*k1d)*((exp(1i*k2d)-rf3.*exp(-1i*k2d)))/z2;   %  particle  velocity in layer
        
        % power transmitted into Z3 at second boundary
        t2f3=2/((1+z1/z3)*cos(k1d)+1i*(z2/z3+z1/z2)*sin(k1d));

        
        %Szabo's equations, second try. Rechecked in book chp3.
        %First way to find reflection from both media
        r = ((1-(z1/z3))*cos(k1d)+1i*((z2/z3-z1/z2)*sin(k1d)))...
            /((1+(z1/z3))*cos(k1d)+1i*((z2/z3+z1/z2)*sin(k1d)));
        
        %Second way by first determining input impedence
        zin = z2*(z3*cos(k1d)+1i*z2*sin(k1d))/(z2*cos(k1d)+1i*z3*sin(k1d));
        rr = (zin-z1)/(z1+zin);
        
        %Matlab gets real hangry if r a complex number with miniscule value
        %Which happens in the formula if r -> 0
        if abs(rr) < 0.001
            rr = 0;
        end
        
        Rf = abs(rr)^2; %Notice these are equal, so correct.
        
        %Transmission out of the stacked media
        Tf = 1-Rf;
        
        obj.Rf = Rf;
        obj.Tf = Tf;
        
        newp2 = real(p2); %To see wave nature, look just at real part of p2
        newnewp2 = newp2-min(newp2(:));
        obj.p2 = newp2;
        
        %mapping values to hot map.
        CMap = jet(64);
        hotColor = hot;
        coeff = [0 0]; % [slope intercept]

        coeff(1) = 49/(3); %Normalized value to choose color to reflect both pos and neg values of p2. This function assumes values are positive so I relabel the colorbar as postiitve and negative in the appview
        %coeff(1) = 49/(max(p2));
        coeff(2) = 1;
        val = round(coeff(1) * newnewp2 + coeff(2));

        for m = 1:256
            for n = 1:256
                obj.colorMat(m,n,:) = hotColor(val(257-m),:);
            end
        end
        % refractions

        obj.rfColor = CMap(round(abs(obj.Rf)*63+1),:);
        obj.tfColor = CMap(round(obj.Tf*63+1),:);
        
        obj.notify('mediumUpdated');
    end
    
    end % end of methods
end