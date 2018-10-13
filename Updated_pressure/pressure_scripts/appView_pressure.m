classdef appView_pressure < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure  matlab.ui.Figure
        ChangeMediumAnglesPanel  matlab.ui.container.Panel
        OutputPanel             matlab.ui.container.Panel
        
        Medium1zLabel            matlab.ui.control.Label
        Medium1zSlider           matlab.ui.control.Slider
        Medium1zEdit             matlab.ui.control.NumericEditField

        Medium2zLabel            matlab.ui.control.Label
        Medium2zSlider           matlab.ui.control.Slider
        Medium2zEdit             matlab.ui.control.NumericEditField

        Medium3zLabel            matlab.ui.control.Label
        Medium3zSlider           matlab.ui.control.Slider
        Medium3zEdit             matlab.ui.control.NumericEditField

%         Medium2vLabel            matlab.ui.control.Label
%         Medium2vSlider           matlab.ui.control.Slider
%         Medium2vEdit             matlab.ui.control.NumericEditField
% 
        FreqLabel                matlab.ui.control.Label
        FreqSlider               matlab.ui.control.Slider
        FreqEdit                 matlab.ui.control.NumericEditField
        
        ThickLabel                matlab.ui.control.Label
        ThickSlider               matlab.ui.control.Slider
        ThickEdit                 matlab.ui.control.NumericEditField

        ViewCodeBtn              matlab.ui.control.Button
        unit1Label               matlab.ui.control.Label
        unit2Label               matlab.ui.control.Label
        
        ReflectionLabel          matlab.ui.control.Label
        ReflectionEdit           matlab.ui.control.NumericEditField
        TransmissionLabel        matlab.ui.control.Label
        TransmissionEdit         matlab.ui.control.NumericEditField
        
        ImAxe                    matlab.ui.control.UIAxes
        CMapAxeL                 matlab.ui.control.UIAxes
        CMapAxeR                 matlab.ui.control.UIAxes
        
        modelObj
        controlObj
        
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create ObliqueWavesatABoundaryUIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 740 450];
            app.UIFigure.Name = 'Continuous Pressure Wave Reverberation';

            % Create ChangeMediumAnglesPanel
            app.ChangeMediumAnglesPanel = uipanel(app.UIFigure);
            app.ChangeMediumAnglesPanel.TitlePosition = 'centertop';
            app.ChangeMediumAnglesPanel.Title = 'User Inputs';
            app.ChangeMediumAnglesPanel.FontSize = 14;
            app.ChangeMediumAnglesPanel.Position = [20 180 270 260];
            
            % Create OutputPanel
            app.OutputPanel = uipanel(app.UIFigure);
            app.OutputPanel.TitlePosition = 'centertop';
            app.OutputPanel.Title = 'Outputs';
            app.OutputPanel.FontSize = 14;
            app.OutputPanel.Position = [20 10 270 180];
            
            %%  -------------Medium1zSlider------------------------
            % Create Medium1z Label
            app.Medium1zLabel = uilabel(app.ChangeMediumAnglesPanel);
            app.Medium1zLabel.HorizontalAlignment = 'left';
            app.Medium1zLabel.FontSize = 12;
            app.Medium1zLabel.FontColor = 'k';
            app.Medium1zLabel.Position = [10 178 85 45];
            app.Medium1zLabel.Text = {'Impedance','of Layer 1','(MRayls)'};
            % Create Medium1z Slider
            app.Medium1zSlider = uislider(app.ChangeMediumAnglesPanel);
            app.Medium1zSlider.Limits = [1 10];
            app.Medium1zSlider.FontSize = 14;
            app.Medium1zSlider.Position = [90 213 115 3];
            app.Medium1zSlider.Value = app.modelObj.z1;
            app.Medium1zSlider.MajorTickLabelsMode = 'manual';
            app.Medium1zSlider.MajorTickLabels= {'1' '4' '7' '10'};
            app.Medium1zSlider.MajorTicks = [1 4 7 10];
            app.Medium1zSlider.MinorTicks = 1:10;
            % Create Medium1z Edit Field
            app.Medium1zEdit = uieditfield(app.UIFigure, 'numeric');
            app.Medium1zEdit.Position = [240 378 40 22];
            app.Medium1zEdit.Value = app.Medium1zSlider.Value;
 
            %% -------------Medium2zSlider------------------------
            % Create Medium2z Label
            app.Medium2zLabel = uilabel(app.ChangeMediumAnglesPanel);
            app.Medium2zLabel.HorizontalAlignment = 'left';
            app.Medium2zLabel.FontSize = 12;
            app.Medium2zLabel.FontColor = 'k';
            app.Medium2zLabel.Position = [10 123 85 45]; %<-230
            app.Medium2zLabel.Text = {'Impedance','of Layer 2','(MRayls)'};
            % Create Medium2z Slider
            app.Medium2zSlider = uislider(app.ChangeMediumAnglesPanel);
            app.Medium2zSlider.Limits = [1 10];
            app.Medium2zSlider.FontSize = 14;
            app.Medium2zSlider.Position = [90 158 115 3];%<-263
            app.Medium2zSlider.Value = app.modelObj.z2;
            app.Medium2zSlider.MajorTickLabelsMode = 'manual';
            app.Medium2zSlider.MajorTickLabels= {'1' '4' '7' '10'};
            app.Medium2zSlider.MajorTicks= [1 4 7 10];
            app.Medium2zSlider.MinorTicks = 1:10;
            % Create Medium2z Edit Field
            app.Medium2zEdit = uieditfield(app.UIFigure, 'numeric');
            app.Medium2zEdit.Position = [240 323 40 22];%<-263
            app.Medium2zEdit.Value = app.Medium2zSlider.Value;
            
            %% -------------Medium3zSlider------------------------
            % Create Medium3z Label
            app.Medium3zLabel = uilabel(app.ChangeMediumAnglesPanel);
            app.Medium3zLabel.HorizontalAlignment = 'left';
            app.Medium3zLabel.FontSize = 12;
            app.Medium3zLabel.FontColor = 'k';
            app.Medium3zLabel.Position = [10 68 85 45]; %<-280
            app.Medium3zLabel.Text = {'Impedance','of Layer 3','(MRayls)'};
            % Create Medium3z Slider
            app.Medium3zSlider = uislider(app.ChangeMediumAnglesPanel);
            app.Medium3zSlider.Limits = [1 10];
            app.Medium3zSlider.FontSize = 14;
            app.Medium3zSlider.Position = [90 102 115 3]; %<-313
            app.Medium3zSlider.Value = app.modelObj.z3;
            app.Medium3zSlider.MajorTickLabelsMode = 'manual';
            app.Medium3zSlider.MajorTickLabels= {'1' '4' '7' '10'};
            app.Medium3zSlider.MajorTicks= [1 4 7 10];
            app.Medium3zSlider.MinorTicks= 1:10;
            % Create Medium3z Edit Field
            app.Medium3zEdit = uieditfield(app.UIFigure, 'numeric');
            app.Medium3zEdit.Position = [240 268 40 22]; %<-313
            app.Medium3zEdit.Value = app.Medium3zSlider.Value;          

            %% -------------Medium2 Velocity Slider------------------------
%             % Create Medium2v Label
%             app.Medium2vLabel = uilabel(app.ChangeMediumAnglesPanel);
%             app.Medium2vLabel.HorizontalAlignment = 'left';
%             app.Medium2vLabel.FontSize = 11;
%             app.Medium2vLabel.FontColor = 'k';
%             app.Medium2vLabel.Position = [10 160 85 45];
%             app.Medium2vLabel.Text = {'Speed of','Sound in','Layer 2 (m/s)'};
%             % Create Medium2v Slider
%             app.Medium2vSlider = uislider(app.ChangeMediumAnglesPanel);
%             app.Medium2vSlider.Limits = [1000 3000];
%             app.Medium2vSlider.FontSize = 12;
%             app.Medium2vSlider.Position = [90 193 115 3];
%             app.Medium2vSlider.Value = app.modelObj.c2;
%             app.Medium2vSlider.MajorTickLabelsMode = 'manual';
%             app.Medium2vSlider.MajorTickLabels= {'1000'  '2000' '3000' };
%             app.Medium2vSlider.MajorTicks= [1000:1000:3000];
%             app.Medium2vSlider.MinorTicks= [1000:100:3000];
%             % Create Medium2v Edit Field
%             app.Medium2vEdit = uieditfield(app.UIFigure, 'numeric');
%             app.Medium2vEdit.Position = [240 193 40 22];
%             app.Medium2vEdit.Value = app.Medium2vSlider.Value;
            
             %% -------------Frequency Slider--------------------------
% Unneeded -> overdetermines GUI functions so I define as constant
%             % Create FreqLabel
%             app.FreqLabel = uilabel(app.ChangeMediumAnglesPanel);
%             app.FreqLabel.HorizontalAlignment = 'left';
%             app.FreqLabel.FontSize = 14;
%             app.FreqLabel.FontColor = 'k';
%             app.FreqLabel.Position = [10 119 80 34];
%             app.FreqLabel.Text = {'Frequency','(MHz)'};
%             % Create FreqSlider
%             app.FreqSlider = uislider(app.ChangeMediumAnglesPanel);
%             app.FreqSlider.Limits = [0.1 20];
%             app.FreqSlider.FontSize = 14;
%             app.FreqSlider.Position = [90 143 115 3];
%             app.FreqSlider.Value = app.modelObj.fc;
%             app.FreqSlider.MajorTickLabelsMode = 'manual';
%             app.FreqSlider.MajorTickLabels= {'0.1' '5' '10' '15' '20'};
%             app.FreqSlider.MajorTicks= [0.1 5 10 15 20];
%             % Create FreqEdit
%             app.FreqEdit = uieditfield(app.UIFigure, 'numeric');
%             app.FreqEdit.Position = [240 143 40 22];
%             app.FreqEdit.Value = app.FreqSlider.Value;

            %% -----------Thickness Slider--------------------------
            % Create ThickLabel
            app.ThickLabel = uilabel(app.ChangeMediumAnglesPanel);
            app.ThickLabel.HorizontalAlignment = 'left';
            app.ThickLabel.FontSize = 12;
            app.ThickLabel.FontColor = 'k';
            app.ThickLabel.Position = [10 13 80 45];
            app.ThickLabel.Text = {'Thickness','of Layer 2', 'wavelength'};
            % Create ThickSlider
            app.ThickSlider = uislider(app.ChangeMediumAnglesPanel);
            app.ThickSlider.Limits = [0.05 2];
            app.ThickSlider.FontSize = 14;
            app.ThickSlider.Position = [90 48 115 3];
            app.ThickSlider.Value = app.modelObj.d2;
            app.ThickSlider.MajorTickLabelsMode = 'manual';
            app.ThickSlider.MajorTickLabels= {'0.05' '0.5' '1' '1.5' '2'};
            app.ThickSlider.MajorTicks= [0.05 0.5 1 1.5 2];
            app.ThickSlider.MinorTicks = [0.05 0.25:0.25:25];
            % Create ThickEdit
            app.ThickEdit = uieditfield(app.UIFigure, 'numeric');
            app.ThickEdit.Position = [240 213 40 22];            
            app.ThickEdit.Value = app.ThickSlider.Value;
            
            %% ---------------------------
            % Create ViewCodeBtn
            app.ViewCodeBtn = uibutton(app.OutputPanel, 'push');
            app.ViewCodeBtn.Position = [83 5 100 22];
            app.ViewCodeBtn.Text = 'View Code';

            % Create ImAxe
            app.ImAxe = uiaxes(app.UIFigure);
            app.ImAxe.Position = [340 20 310 410];
            
            % 2 ColorMaps (L/R)
            app.CMapAxeL = uiaxes(app.UIFigure);
            app.CMapAxeL.Position = [290 20 50 410];
            axis(app.CMapAxeL,'off');
            
            app.CMapAxeR = uiaxes(app.UIFigure);
            app.CMapAxeR.Position = [660 20 50 410];
            axis(app.CMapAxeR,'off');
            
            % Create Reflection Label
            app.ReflectionLabel = uilabel(app.UIFigure);
            app.ReflectionLabel.HorizontalAlignment = 'left';
            app.ReflectionLabel.FontSize = 12;
            app.ReflectionLabel.FontColor = 'k';
            app.ReflectionLabel.Position = [55 115 60 28];
            app.ReflectionLabel.Text = {'Reflection','of Layer 1'};
            
            % Create Reflection Edit Field
            app.ReflectionEdit = uieditfield(app.UIFigure, 'numeric');
            app.ReflectionEdit.Position = [60 90 41 22];
            app.ReflectionEdit.Value = app.modelObj.Rf;
            
            % Create Transmission Label
            app.TransmissionLabel = uilabel(app.UIFigure);
            app.TransmissionLabel.HorizontalAlignment = 'left';
            app.TransmissionLabel.FontSize = 12;
            app.TransmissionLabel.FontColor = 'k';
            app.TransmissionLabel.Position = [200 115 80 28];
            app.TransmissionLabel.Text = {'Transmission','of Layer 3'};
            
            % Create Trasnmission Edit Field
            app.TransmissionEdit = uieditfield(app.UIFigure, 'numeric');
            app.TransmissionEdit.Position = [205 90 41 22];
            app.TransmissionEdit.Value = app.modelObj.Tf;
        end
        
        function startupFcn(app)
            
            % Creat App Controller Model
            app.controlObj = appController_pressure(app, app.modelObj);
            app.attacheToController(app.controlObj);          
            % Signals
            app.modelObj.addlistener('mediumUpdated',@app.drawBackground);
        end
        
        function attacheToController(app, controller)
            
            slider = {  app.Medium1zSlider, app.Medium2zSlider, ...
                        app.Medium3zSlider...
                        app.ThickSlider};
                    
            editField = {   app.Medium1zEdit, app.Medium2zEdit, ...
                            app.Medium3zEdit...
                            app.ThickEdit,app.ReflectionEdit,app.TransmissionEdit};
            for k = 1:4
                set(slider{k}, 'ValueChangedFcn', ...
                    @(src,eventdata)controller.SliderChanged(src,eventdata,slider{k},editField{k}));
            end
            
            for k = 1:6
                set(editField{k}, 'ValueChangedFcn', ...
                    @(src,eventdata)controller.EditChanged(src,eventdata,slider{k},editField{k}));
            end
                
            
            set(app.ViewCodeBtn,'ButtonPushedFcn',@controller.codeViewPushed);
            
        end

        function drawBackground(app, src, data)
             
            % Draw Lines on ImAxe
            plot(app.ImAxe,1,1);
            axis(app.ImAxe,'off');
            axis(app.ImAxe,[-1 1 -1.5 1.5]);
            line(app.ImAxe,[-.4 1], [0.55 0.55],'LineWidth',4,'Color','k','LineStyle','--');
            line(app.ImAxe,[-.4 1], [-0.55 -0.55],'LineWidth',4,'Color','k','LineStyle','--');

            
            hold(app.ImAxe,'on');
            %This line imposes an image onto the axes already defined. I.E
            %This line is what draws the wave in layer 2!
            image(app.ImAxe,'XData',linspace(-.4,1,256),'YData',linspace(-.53,.53,256),'CData',app.modelObj.colorMat);
            
            % Draw Arrows 
            quiver(app.ImAxe, -0.2, 1.5, 0, -1, ...
                'Color',[0.5 0 0], ...
                'LineWidth',12, ...
                'MaxHeadSize',2);
            
            quiver(app.ImAxe, 0, .55, 0, 1, ...
                'Color',app.modelObj.rfColor, ...
                'LineWidth',12, ...
                'MaxHeadSize',2); 

            quiver(app.ImAxe, -0.1, -.55, 0, -1, ...
                'Color',app.modelObj.tfColor, ...
                'LineWidth',12, ...
                'MaxHeadSize',2); 
            
            % Add Explanation Texts to ImAxe
            text(app.ImAxe,-1,1.2,'\bf Layer 1','Color','b','FontSize',16);
            %No longer using a variable input frequency so this isn't
            %needed
%             text(app.ImAxe,-.9,1.05,'Incident Beam','Color','b','FontSize',12);
%             text(app.ImAxe,-.9,0.95,'Frequency:','Color','b','FontSize',12);
%             text(app.ImAxe,-.9,0.85,[num2str(app.modelObj.fc,'%.2f'),' MHz'],'Color','b','FontSize',14);
            
            lambda = app.modelObj.c2/(1e6*app.modelObj.fc); % unit: m
            thickness=app.modelObj.d2*lambda;  % line length  (m)
        
            text(app.ImAxe,-1,0.2,'\bf Layer 2','Color','r','FontSize',16);
            text(app.ImAxe,-.9,.05,'Thickness:','Color','r','FontSize',12);
            text(app.ImAxe,-.9,-.05,'d= n\times\lambda','Color','r','FontSize',14);
            text(app.ImAxe,-.9,-.15,' = n\timesc/f_c','Color','r','FontSize',14);
            text(app.ImAxe,-.9,-.25,[' =',num2str(thickness*1e3,'%.2f'),' mm'],'Color','r','FontSize',14);
            
            text(app.ImAxe,-1,-1.2,'\bf Layer 3','Color','b','FontSize',16);
            
            
            hold(app.ImAxe,'off');
            
            % Draw ColorMaps in CMap Axes L/R
            colormap(app.CMapAxeL,'jet');
            h2 = colorbar(app.CMapAxeL);
            h2.Limits = [0 1];  
            colormap(app.CMapAxeR,'hot');
            h2 = colorbar(app.CMapAxeR);
            h2.Limits = [0 max(app.modelObj.p2)];          
            
        end

    end

    methods (Access = public)

        % Construct app
        function app = appView_pressure(modelObj)

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