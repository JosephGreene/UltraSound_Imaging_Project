classdef appModel_pressure < handle
    properties
        % material properties
        c2 = 1540;
   
        z1
        z2
        z3
        % simulation settings
        fc % center frequency of incident wave
        d2
        
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
        
	function obj = appModel_pressure(c2,z1,z2,z3,fc,d2)
        obj.c2 = c2;
 
        obj.z1 = z1;
        obj.z2 = z2;
        obj.z3 = z3;
        
        obj.fc = fc;
        obj.d2 = d2;
        
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
        
        nt=256;             %  number of time points
        % input variables
        pi2=2*pi;
        pid2=pi/2;
        del=d2/(nt-1);
        dd=del*(0:nt-1);
        k2d=pi2*fc*dd/c2;     % distance from end to front (medium 3 to medium 1)
        k2d2=pi2*fc*(d2*ones(size(dd))-dd)/c2; % distance from front to end: 1 to 3
        k1d=pi2*fc*d2/c2;
        rf3=(z3-z2)/(z3+z2); %Reflectance 
        tf3=2*z3/(z3+z2); %Transmission
        p2=exp(-i*k1d)*(exp(i*k2d)+rf3.*exp(-i*k2d));   % pressure in layer
        %p2=exp(i*k2d)+rf3.*exp(-1i*k2d);   % pressure in layer   error corrected
        u2=exp(-i*k1d)*((exp(i*k2d)-rf3.*exp(-i*k2d)))/z2;   %  particle  velocity in layer
        zin2=p2./u2; %Input impedance of pressure wave
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
        z2in=p2in./u2in;   % input impedance looking into first boundary
        % power transmitted into Z3 at second boundary
        t2f3=2/((1+z1/z3)*cos(k1d)+i*(z2/z3+z1/z2)*sin(k1d));
        tp23=abs(t2f3)*abs(t2f3)*(z1/z3);   % transmit into 3  use this one
        %t2f3=4*(real(z3)*z2)./((real(z3)+z2).*(real(z3)+z2)+imag(z3).*imag(z3))
        % power reflected at first boundary into z1 use ths one
        %rf1=((real(z2in)-z1).*(real(z2in)-z1)+imag(z2in)).*(imag(z2in))...
        %./((real(z2in)+z1).*(real(z2in)+z1)+imag(z2in).*imag(z2in))
        
        %Using the above equations, I modelled the first interface
        %transmission assuming that the distance from the transducer to the
        %interface is a multiple of n*pi (or 0 cause skin contact) then
        %reflection is 1-transmission
        t1f2=2/((1+z1/z2));
        rf1 = 1 - abs(t1f2)*abs(t1f2)*(z1/z2)
    
        p2 = abs(p2);
        obj.p2 = p2;
        
        %mapping values to hot map.
        CMap = jet(64);
        hotColor = hot;
        coeff = [0 0]; % [slope intercept]

        % coeff(1) = 49/(max(p2)-min(p2));
        coeff(1) = 49/(max(p2));
        coeff(2) = 1;
        val = round(coeff(1) * p2 + coeff(2));

        for m = 256:-1:1
            for n = 1:256
                obj.colorMat(m,n,:) = hotColor(val(m),:);
            end
        end
        
        % refractions

        obj.rfColor = CMap(round(abs(rf1)*63+1),:);
        obj.tfColor = CMap(round(tp23*63+1),:);
        
        obj.notify('mediumUpdated');
    end
    
    end % end of methods
end