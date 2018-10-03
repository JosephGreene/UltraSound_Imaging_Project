classdef appController_pulsewave < handle 
   properties
       viewObj;
       modelObj;
   end
   methods
    %Generate object that has properties viewObj and modelObj for use with
    %the appModel_pulsewave and appViewpulsewave files
    function obj = appController_pulsewave(viewObj,modelObj)
        obj.viewObj = viewObj;
        obj.modelObj = modelObj;
    end
    
    %If the app registers that ANY slider has changed, it will update ALL
    %sliders info -> could optimize for individual sliders
    function SliderChanged(app, src, event, slider, editField)

        editField.Value = round(100*slider.Value)/100;
        c2 = app.viewObj.Medium2vSlider.Value;
        z1 = app.viewObj.Medium1zSlider.Value;
        z2 = app.viewObj.Medium2zSlider.Value;
        z3 = app.viewObj.Medium3zSlider.Value;
        d2 = app.viewObj.ThickSlider.Value;
        app.modelObj.applySettings(z1, z2, z3, c2, d2);
    end
    
    %Same deal with edit fields, if you change ANY field, ALL variables are
    %updated in the app.
    function EditChanged(app, src, event, slider, editField)
        slider.Value = editField.Value;
        c2 = app.viewObj.Medium2vSlider.Value;
        z1 = app.viewObj.Medium1zSlider.Value;
        z2 = app.viewObj.Medium2zSlider.Value;
        z3 = app.viewObj.Medium3zSlider.Value;
        d2 = app.viewObj.ThickSlider.Value;
        app.modelObj.applySettings(z1, z2, z3, c2, d2);
    end
    
    %Obvious -> calls the function that causes the white strip to move
    %along the lines when pushed
    function playBtnPushed(app, src, event)
       app.modelObj.playMovie(); 
    end
    
    %Pulls up .mlx file when push view code button
    function codeViewPushed(app, src, event)
        edit('code.mlx');
    end
   end 
end