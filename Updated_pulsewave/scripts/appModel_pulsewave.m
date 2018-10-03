classdef appModel_pulsewave < handle
    properties
        % material properties
        z1
        z2
        z3
        
        % simulation settings
        c2
        d2
        
        %Reflection and transmission coefficients
        tf12
        rf21
        tf23
        rf23
        
        % results
        xS
        yS
        zS
        cS
        
        % extra
        waves
        nSampleTot
        timeVec
        maxTime
    end
    events
       reset
    end % end of events
    methods
    
    %Assign properties and create object
	function obj = appModel_pulsewave(z1,z2,z3,c2,d2)
        obj.c2 = c2;
 
        obj.z1 = z1;
        obj.z2 = z2;
        obj.z3 = z3;
        
        obj.d2 = d2;
        
        obj.applySettings(z1, z2, z3, c2, d2);    
    end
    
    %Update previously defined object parameters
    function applySettings(obj, z1, z2, z3, c2, d2)
        % Update the media properties of 1, 2 and 3, sound speed and layer thickness
        
        obj.c2 = c2;

        obj.z1 = z1;
        obj.z2 = z2;
        obj.z3 = z3;
        
        obj.d2 = d2;
        
        % Set the color matrix's coordinates, xS, yS and zS
        list12 = [-.2 0 .2 .4 .6 .8 1]'; % x coordinates, y coordinates is fixed on .55
        list23 = [-.1 .1 .3 .5 .7 .9]'; % x coordiantes for face 2-3 , y coordinates i fixed on -.55
        
        nBase = 10;
        nSamplePerPath = round(nBase * (7/obj.c2));
        nSamplePerPath = 30;
        nPath = 12;
        nSampleInitial = round(nSamplePerPath*0.5/1.1);
        nSampleTot = nPath*nSamplePerPath + nSampleInitial;
        
        % Wave from layer 1 to 2 -> Note, only longitudinal waves used! 
        obj.tf12 = 2*z2/(z1+z2); %Transmission 
        % Wave from layer 2 to 1
        obj.rf21 = (z1-z2)/(z1+z2); %reflection
        
        % Wave from layer 2 to 3 -> Longitudinal, no shear wave
        % calculations
        obj.rf23 = (z3-z2)/(z3+z2); %Second boundary reflection
        obj.tf23 = 2*z3/(z3+z2); %Second boundary transmission
        
        waves = zeros(nSampleTot+1,nSampleTot);
        
        vecPath = ones(1,nSamplePerPath);
        diagVec = ones(1,nSampleInitial);
        for k = 0:5
%             diagVec = [diagVec, ...
%                 tf12 * rf21.^k * rf23.^k *vecPath, ...
%                 tf12 * rf21.^k * rf23.^(k+1) *vecPath];
            diagVec = [diagVec, vecPath, vecPath];
        end
        timeVec = zeros(1,nSampleInitial);
        timePath = zeros(1,2*nSamplePerPath-1);
        for k = 0:5
            timeVec = [timeVec, timePath, obj.tf12 * obj.tf23 * obj.rf21.^k * obj.rf23.^k];
        end
        
        waves(2:end,:) = diag(diagVec);
        
        obj.xS = zeros(2,nSampleTot,7);
        obj.yS = obj.xS;
        
        xdata = linspace(-.2,-.2,nSampleInitial);
        ydata = linspace(1,.55,nSampleInitial);

        for k = 1:6
            xdata = [xdata,linspace(list12(k),list23(k),nSamplePerPath),linspace(list23(k),list12(k+1),nSamplePerPath )];
            ydata = [ydata,linspace(.55,-.55,nSamplePerPath ),          linspace(-.55,.55,nSamplePerPath)];
        end

        obj.xS(:,:,1) = [xdata; xdata];
        obj.yS(:,:,1) = [ydata; ydata];
        obj.zS = zeros(2, nSampleTot);

        for k = 1:6
            xdata = linspace(list23(k),list23(k),nSampleTot);
            ydata = [ linspace(-.55,-.55,nSampleInitial+(2*k-1)*nSamplePerPath), ...
                            linspace(-.55,-1.3,nSamplePerPath), ...
                            linspace(-1.3,-1.3,nSampleTot - nSampleInitial - 2*k*nSamplePerPath)];
            obj.xS(:,:,k+1) = [xdata; xdata];
            obj.yS(:,:,k+1) = [ydata; ydata];
        end
        
        obj.cS = [waves(1,:); waves(1,:)];
        obj.waves = waves;
        obj.nSampleTot = nSampleTot;
        obj.timeVec = timeVec;
        obj.maxTime = 12.6*d2/c2/1e6;
        obj.notify('reset');
    end
    
    function updateCData(obj, sample)
        
        if sample<obj.nSampleTot  
            obj.cS = [obj.waves(sample+1,:); obj.waves(sample+1,:)];
        end
        
    end
    
    end % end of methods
end