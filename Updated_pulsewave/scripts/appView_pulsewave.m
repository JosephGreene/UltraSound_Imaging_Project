classdef appView_pulsewave < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure  matlab.ui.Figure
        ChangeMediumAnglesPanel  matlab.ui.container.Panel
        Layer1Panel              matlab.ui.container.Panel
        Layer2Panel              matlab.ui.container.Panel
        Layer3Panel              matlab.ui.container.Panel
        
        Medium1zLabel            matlab.ui.control.Label
        Medium1zSlider           matlab.ui.control.Slider
        Medium1zEdit             matlab.ui.control.NumericEditField

        Medium2zLabel            matlab.ui.control.Label
        Medium2zSlider           matlab.ui.control.Slider
        Medium2zEdit             matlab.ui.control.NumericEditField

        Medium3zLabel            matlab.ui.control.Label
        Medium3zSlider           matlab.ui.control.Slider
        Medium3zEdit             matlab.ui.control.NumericEditField

        Medium2vLabel            matlab.ui.control.Label
        Medium2vSlider           matlab.ui.control.Slider
        Medium2vEdit             matlab.ui.control.NumericEditField
        
        %{
        FreqLabel                matlab.ui.control.Label
        FreqSlider               matlab.ui.control.Slider
        FreqEdit                 matlab.ui.control.NumericEditField
        %}
        
        ThickLabel                matlab.ui.control.Label
        ThickSlider               matlab.ui.control.Slider
        ThickEdit                 matlab.ui.control.NumericEditField
    
        PlayBtn                  matlab.ui.control.Button
        ViewCodeBtn              matlab.ui.control.Button
        unit1Label               matlab.ui.control.Label
        unit2Label               matlab.ui.control.Label
        
        Layer1Label              matlab.ui.control.Label
        Layer2Label              matlab.ui.control.Label
        Layer3Label              matlab.ui.control.Label
        
        ImAxe                    matlab.ui.control.UIAxes
        
        LineAxe                 matlab.ui.control.UIAxes
        
        % Handles to the plot
        hS1
        hS2
        hS3
        hS4
        hS5
        hS6
        hS7
        
        modelObj
        controlObj
        
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create ObliqueWavesatABoundaryUIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 720 450];
            app.UIFigure.Name = 'Pulsed Pressure Wave Reverberation';

            % Create ChangeMediumAnglesPanel
            app.ChangeMediumAnglesPanel = uipanel(app.UIFigure);
            app.ChangeMediumAnglesPanel.TitlePosition = 'centertop';
            app.ChangeMediumAnglesPanel.Title = 'User Inputs';
            app.ChangeMediumAnglesPanel.FontSize = 14;
            app.ChangeMediumAnglesPanel.Position = [20 20 270 410];
            
            %%  -------------Medium1zSlider------------------------
            % Create Medium1z Label
            app.Medium1zLabel = uilabel(app.ChangeMediumAnglesPanel);
            app.Medium1zLabel.HorizontalAlignment = 'left';
            app.Medium1zLabel.FontSize = 12;
            app.Medium1zLabel.FontColor = 'k';
            app.Medium1zLabel.Position = [10 330 85 45];
            app.Medium1zLabel.Text = {'Impedance','of Layer 1','(MRayls)'};
            % Create Medium1z Slider
            app.Medium1zSlider = uislider(app.ChangeMediumAnglesPanel);
            app.Medium1zSlider.Limits = [1 10];
            app.Medium1zSlider.FontSize = 14;
            app.Medium1zSlider.Position = [90 363 115 3];
            app.Medium1zSlider.Value = app.modelObj.z1;
            app.Medium1zSlider.MajorTickLabelsMode = 'manual';
            app.Medium1zSlider.MajorTickLabels= {'1' '4' '7' '10'};
            app.Medium1zSlider.MajorTicks = [1 4 7 10];
            app.Medium1zSlider.MinorTicks = 1:10;
            % Create Medium1z Edit Field
            app.Medium1zEdit = uieditfield(app.UIFigure, 'numeric');
            app.Medium1zEdit.Position = [240 363 40 22];
            app.Medium1zEdit.Value = app.Medium1zSlider.Value;
 
            %% -------------Medium2zSlider------------------------
            % Create Medium2z Label
            app.Medium2zLabel = uilabel(app.ChangeMediumAnglesPanel);
            app.Medium2zLabel.HorizontalAlignment = 'left';
            app.Medium2zLabel.FontSize = 12;
            app.Medium2zLabel.FontColor = 'k';
            app.Medium2zLabel.Position = [10 280 85 45]; %<-230
            app.Medium2zLabel.Text = {'Impedance','of Layer 2','(MRayls)'};
            % Create Medium2z Slider
            app.Medium2zSlider = uislider(app.ChangeMediumAnglesPanel);
            app.Medium2zSlider.Limits = [1 10];
            app.Medium2zSlider.FontSize = 14;
            app.Medium2zSlider.Position = [90 313 115 3];%<-263
            app.Medium2zSlider.Value = app.modelObj.z2;
            app.Medium2zSlider.MajorTickLabelsMode = 'manual';
            app.Medium2zSlider.MajorTickLabels= {'1' '4' '7' '10'};
            app.Medium2zSlider.MajorTicks= [1 4 7 10];
            app.Medium2zSlider.MinorTicks = 1:10;
            % Create Medium2z Edit Field
            app.Medium2zEdit = uieditfield(app.UIFigure, 'numeric');
            app.Medium2zEdit.Position = [240 313 40 22];%<-263
            app.Medium2zEdit.Value = app.Medium2zSlider.Value;
            
            %% -------------Medium3zSlider------------------------
            % Create Medium3z Label
            app.Medium3zLabel = uilabel(app.ChangeMediumAnglesPanel);
            app.Medium3zLabel.HorizontalAlignment = 'left';
            app.Medium3zLabel.FontSize = 12;
            app.Medium3zLabel.FontColor = 'k';
            app.Medium3zLabel.Position = [10 230 85 45]; %<-280
            app.Medium3zLabel.Text = {'Impedance','of Layer 3','(MRayls)'};
            % Create Medium3z Slider
            app.Medium3zSlider = uislider(app.ChangeMediumAnglesPanel);
            app.Medium3zSlider.Limits = [1 10];
            app.Medium3zSlider.FontSize = 14;
            app.Medium3zSlider.Position = [90 263 115 3]; %<-313
            app.Medium3zSlider.Value = app.modelObj.z3;
            app.Medium3zSlider.MajorTickLabelsMode = 'manual';
            app.Medium3zSlider.MajorTickLabels= {'1' '4' '7' '10'};
            app.Medium3zSlider.MajorTicks= [1 4 7 10];
            app.Medium3zSlider.MinorTicks= 1:10;
            % Create Medium3z Edit Field
            app.Medium3zEdit = uieditfield(app.UIFigure, 'numeric');
            app.Medium3zEdit.Position = [240 263 40 22]; %<-313
            app.Medium3zEdit.Value = app.Medium3zSlider.Value;          

            %% -------------Medium2 Velocity Slider------------------------
            % Create Medium2v Label
            app.Medium2vLabel = uilabel(app.ChangeMediumAnglesPanel);
            app.Medium2vLabel.HorizontalAlignment = 'left';
            app.Medium2vLabel.FontSize = 11;
            app.Medium2vLabel.FontColor = 'k';
            app.Medium2vLabel.Position = [10 160 85 45];
            app.Medium2vLabel.Text = {'Speed of','Sound in','Layer 2 (km/s)'};
            % Create Medium2v Slider
            app.Medium2vSlider = uislider(app.ChangeMediumAnglesPanel);
            app.Medium2vSlider.Limits = [0.5 7];
            app.Medium2vSlider.FontSize = 12;
            app.Medium2vSlider.Position = [90 193 115 3];
            app.Medium2vSlider.Value = app.modelObj.c2;
            app.Medium2vSlider.MajorTickLabelsMode = 'manual';
            app.Medium2vSlider.MajorTickLabels= {'0.5','2','3','4','5','6','7' };
            app.Medium2vSlider.MajorTicks= [0.5,2,3,4,5,6,7];
            app.Medium2vSlider.MinorTicks= [0.5:0.25:7];
            % Create Medium2v Edit Field
            app.Medium2vEdit = uieditfield(app.UIFigure, 'numeric');
            app.Medium2vEdit.Position = [240 193 40 22];
            app.Medium2vEdit.Value = app.Medium2vSlider.Value;
            
            %% -------------Frequency Slider--------------------------
            
            %{
            % Create FreqLabel
            app.FreqLabel = uilabel(app.ChangeMediumAnglesPanel);
            app.FreqLabel.HorizontalAlignment = 'left';
            app.FreqLabel.FontSize = 14;
            app.FreqLabel.FontColor = 'k';
            app.FreqLabel.Position = [10 119 80 34];
            app.FreqLabel.Text = {'Frequency','(MHz)'};
            % Create FreqSlider
            app.FreqSlider = uislider(app.ChangeMediumAnglesPanel);
            app.FreqSlider.Limits = [0.1 20];
            app.FreqSlider.FontSize = 14;
            app.FreqSlider.Position = [90 143 115 3];
            app.FreqSlider.Value = app.modelObj.fc;
            app.FreqSlider.MajorTickLabelsMode = 'manual';
            app.FreqSlider.MajorTickLabels= {'0.1' '5' '10' '15' '20'};
            app.FreqSlider.MajorTicks= [0.1 5 10 15 20];
            % Create FreqEdit
            app.FreqEdit = uieditfield(app.UIFigure, 'numeric');
            app.FreqEdit.Position = [240 143 40 22];
            app.FreqEdit.Value = app.FreqSlider.Value;
            %}
            
            %% -----------Thickness Slider--------------------------
            % Create ThickLabel
            app.ThickLabel = uilabel(app.ChangeMediumAnglesPanel);
            app.ThickLabel.HorizontalAlignment = 'left';
            app.ThickLabel.FontSize = 12;
            app.ThickLabel.FontColor = 'k';
            app.ThickLabel.Position = [10 65 80 45];
            app.ThickLabel.Text = {'Thickness','of Layer 2', '(mm)'};
            % Create FreqSlider
            app.ThickSlider = uislider(app.ChangeMediumAnglesPanel);
            app.ThickSlider.Limits = [0.05 5];
            app.ThickSlider.FontSize = 14;
            app.ThickSlider.Position = [90 93 115 3];
            app.ThickSlider.Value = app.modelObj.d2;
            app.ThickSlider.MajorTickLabelsMode = 'manual';
            app.ThickSlider.MajorTickLabels= {'0.05' '1' '2' '3' '4' '5'};
            app.ThickSlider.MajorTicks= [0.05 1 2 3 4 5];
            app.ThickSlider.MinorTicks = [0.05 0.2:0.2:5];
            % Create FreqEdit
            app.ThickEdit = uieditfield(app.UIFigure, 'numeric');
            app.ThickEdit.Position = [240 93 40 22];            
            app.ThickEdit.Value = app.ThickSlider.Value;
            
            %% ---------------------------
            % Create playBtn
            app.PlayBtn = uibutton(app.ChangeMediumAnglesPanel, 'push');
            app.PlayBtn.Position = [18 5 100 22];
            app.PlayBtn.Text = 'Play';
            
            % Create ViewCodeBtn
            app.ViewCodeBtn = uibutton(app.ChangeMediumAnglesPanel, 'push');
            app.ViewCodeBtn.Position = [138 5 100 22];
            app.ViewCodeBtn.Text = 'View Code';

            % Create ImAxe
            app.ImAxe = uiaxes(app.UIFigure);
            app.ImAxe.Position = [300 180 400 250];
            
            app.LineAxe = uiaxes(app.UIFigure);
            app.LineAxe.Position = [330 10 360 160];
            axis(app.LineAxe,'on');
            
            %% ------Layer Labels------
                
            %First Layer Label
            app.Layer1Label = uilabel(app.UIFigure);
            app.Layer1Label.HorizontalAlignment = 'left';
            app.Layer1Label.FontSize = 14;
            app.Layer1Label.FontColor = 'b';
            app.Layer1Label.Position = [300 375 65 25]; %<-280
            app.Layer1Label.Text = {'Layer1'};
            
            %Second Layer Label
            app.Layer2Label = uilabel(app.UIFigure);
            app.Layer2Label.HorizontalAlignment = 'left';
            app.Layer2Label.FontSize = 14;
            app.Layer2Label.FontColor = 'r';
            app.Layer2Label.Position = [300 295 65 25]; %<-280
            app.Layer2Label.Text = {'Layer2'};
            
            %Third Layer Label
            app.Layer1Label = uilabel(app.UIFigure);
            app.Layer1Label.HorizontalAlignment = 'left';
            app.Layer1Label.FontSize = 14;
            app.Layer1Label.FontColor = 'k';
            app.Layer1Label.Position = [300 215 65 25]; %<-280
            app.Layer1Label.Text = {'Layer3'};
        end
        
        function startupFcn(app)
            
            % Creat App Controller Model
            app.controlObj = appController_pulsewave(app, app.modelObj);
            app.attacheToController(app.controlObj);          
            % Signals
            app.modelObj.addlistener('reset',@app.drawBackground);
        end
        
        %Links all sliders and edit fields together to check if any change
        %in a simplier fashion.
        function attacheToController(app, controller)
            
            slider = {  app.Medium1zSlider, app.Medium2zSlider, ...
                        app.Medium3zSlider, app.Medium2vSlider, ...
                        app.ThickSlider};
                    
            editField = {   app.Medium1zEdit, app.Medium2zEdit, ...
                            app.Medium3zEdit, app.Medium2vEdit, ...
                            app.ThickEdit};
                        
            %Assign individual slider values and edit fields using a loop and declares
            %change events for each
            for k = 1:5
                set(slider{k}, 'ValueChangedFcn', ...
                    @(src,eventdata)controller.SliderChanged(src,eventdata,slider{k},editField{k}));
                set(editField{k}, 'ValueChangedFcn', ...
                    @(src,eventdata)controller.EditChanged(src,eventdata,slider{k},editField{k}));
            end
            %sets parameters for pushing a button to call a function
            set(app.ViewCodeBtn,'ButtonPushedFcn',@controller.codeViewPushed);
            set(app.PlayBtn,'ButtonPushedFcn',@app.playMovie);
        end

        function drawBackground(app, src, data)

            % Draw Lines on ImAxe
            plot(app.ImAxe,1,1);
            axis(app.ImAxe,'off');
            axis(app.ImAxe,[-0.4 1 -1.3 1.3]);
            line(app.ImAxe,[-.4 1], [0.55 0.55],'LineWidth',4,'Color','k');
            line(app.ImAxe,[-.4 1], [-0.55 -0.55],'LineWidth',4,'Color','k');
            hold(app.ImAxe,'on');

            %Draws red arrow showing incident beam
            quiver(app.ImAxe, -0.2, 1.5, 0, -.5, ...
                'Color',[0.5 0 0], ...
                'LineWidth',6, ...
                'MaxHeadSize',2);
            
            xS = app.modelObj.xS;
            yS = app.modelObj.yS;
            zS = app.modelObj.zS;
            cS = app.modelObj.cS;
            
            lw = 4; %Line width used to drawn lines on app
            
            %Surface commands draws the lines showing the reflection and
            %transmission between layers. app.hS1 is ALL the reflection
            %lines between the boundaries. The rest are the incident beam
            %and transmission tines. Please look at the matlb surface
            %object for additional info.
            
            app.hS1 = surface(app.ImAxe,xS(:,:,1),yS(:,:,1),zS,cS,'FaceColor','none','LineWidth',lw,'EdgeColor','interp');
            app.hS2 = surface(app.ImAxe,xS(:,:,2),yS(:,:,2),zS,cS,'FaceColor','none','LineWidth',lw,'EdgeColor','interp');
            app.hS3 = surface(app.ImAxe,xS(:,:,3),yS(:,:,3),zS,cS,'FaceColor','none','LineWidth',lw,'EdgeColor','interp');
            app.hS4 = surface(app.ImAxe,xS(:,:,4),yS(:,:,4),zS,cS,'FaceColor','none','LineWidth',lw,'EdgeColor','interp');
            app.hS5 = surface(app.ImAxe,xS(:,:,5),yS(:,:,5),zS,cS,'FaceColor','none','LineWidth',lw,'EdgeColor','interp');
            app.hS6 = surface(app.ImAxe,xS(:,:,6),yS(:,:,6),zS,cS,'FaceColor','none','LineWidth',lw,'EdgeColor','interp');
            app.hS7 = surface(app.ImAxe,xS(:,:,7),yS(:,:,7),zS,cS,'FaceColor','none','LineWidth',lw,'EdgeColor','interp');
            colormap(app.ImAxe,'gray');
            app.ImAxe.CLimMode = 'manual';
            app.ImAxe.CLim = [0 1];
            
            plot(app.LineAxe,1,1);
                        nSampleTot = app.modelObj.nSampleTot;
            nSampleInitial = round(30*0.5/1.1)+30; %Time delay caused by initial propegation of wave
            ratio = (nSampleInitial/nSampleTot); %Ratio compared to all time points so that wave is 'ontime' (assume no outside propegation)
            axis(app.LineAxe, [0, app.modelObj.maxTime*1e6-ratio*app.modelObj.maxTime*1e6, ...
                min(app.modelObj.timeVec), max(app.modelObj.timeVec)]);
            xlabel(app.LineAxe,'Time (\mus)');
            ylabel(app.LineAxe,'Exit Pulse Amplitude');
        end
        
        %Checks calculated values to see if the wave is tranmitted or
        %reflected to ~ 0 while propegated.
        function kend = checkCoefficients(app)
            newVec = app.modelObj.timeVec;
            rf21 = app.modelObj.rf21;
            tf23 = app.modelObj.tf23;
            
            %Check if any reflection or transmission is 0 or 1 respectively
            %This means the wave is not reflected or is fully transmitted,
            %so the movie should end.
            %Notice I give each a range of values where I approximate total
            %tranmission or null reflection
            if tf23 >= 0.95 && tf23 <= 1
               kend = 75;
               
            elseif abs(rf21) >= 0 && abs(rf21) <= 0.05
               kend = 75;
            
            else
                %If the first tranmissive or reflective boundaries do not end
                %the animation, see if the wave decays to ~0 throughout its
                %bounces. First we determine all bounces that have a small
                %intensity value
                val = newVec(abs(newVec)<0.05 & newVec~=0);
                %Check if only one value in val
                if length(val) == 1 
                    kend = find(newVec==val);
                %If nonempty vector, just use first value
                elseif ~isempty(val)
                    kend = find(newVec==val(1));
                else
                    %Else, let run to the end
                    kend = length(newVec);
                end
            end
        end
        
        function playMovie(app, src, data)
            %turn off play button
            app.PlayBtn.Enable = 'off';
            % scaling factors
            %Time delay is how fast the wave moves through given thickness
            timeDelay = 18e-3*(app.modelObj.d2/app.modelObj.c2)+0.005;
            %nSampleTot is the total number of steps the drawing animation
            %will have. In this case, it takes 374 steps to represent the
            %wave propegating from the beginning to end.
                        nSampleTot = app.modelObj.nSampleTot;
            nSampleInitial = round(30*0.5/1.1)+30; %Time delay caused by initial propegation of wave
            ratio = (nSampleInitial/nSampleTot); %Ratio compared to all time points so that wave is 'ontime' (assume no outside propegation)
            tRx = linspace((0-ratio*app.modelObj.maxTime*1e6), app.modelObj.maxTime*1e6-ratio*app.modelObj.maxTime*1e6, nSampleTot);
            %kend = app.checkCoefficients() %uncomment to stop movie when
            %wave dissipates
            for k = 1:app.modelObj.nSampleTot
                %Update surfaces so white line representing propegation
                %keeps moving ('where's k?!?')
                app.modelObj.updateCData(k);
                app.hS1.CData = app.modelObj.cS;
                app.hS1.CData = app.modelObj.cS;
                app.hS2.CData = app.modelObj.cS;
                app.hS3.CData = app.modelObj.cS;
                app.hS4.CData = app.modelObj.cS;
                app.hS5.CData = app.modelObj.cS;
                app.hS6.CData = app.modelObj.cS;
                app.hS7.CData = app.modelObj.cS;
                
                %Rx is created weirdly. timeVec has all the right
                %coefficients for transmission and when they should be
                %plotted. That vector is multiplied by a vector of an
                %increasing amount of ones so that when it is plotted in
                %successent cycles, it retains more generated data. 
                Rx = app.modelObj.timeVec.* [ones(1,k), zeros(1,nSampleTot-k)];
                plot(app.LineAxe,tRx,Rx);
                pause(timeDelay);
                %if k == kend %Uncomment to stop movie when wave dissapates
                   % break

            
            end 
            app.PlayBtn.Enable = 'on';
        end
    end

    methods (Access = public)

        % Construct app
        function app = appView_pulsewave(modelObj)

            app.modelObj = modelObj;
            
            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)
            
            % Run Startup Functions
            runStartupFcn(app, @startupFcn)
            
            % adrawLines
            app.drawBackground();
            
            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end