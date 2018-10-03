classdef appController_pressure < handle 
   properties
       viewObj;
       modelObj;
   end
   methods
    function obj = appController_pressure(viewObj,modelObj)
    obj.viewObj = viewObj;
    obj.modelObj = modelObj;
    end
    
    %Updates all sliders when one changes
    function SliderChanged(app, src, event, slider, editField)

        editField.Value = round(100*slider.Value)/100;
        c2 = 1540;
        z1 = app.viewObj.Medium1zSlider.Value;
        z2 = app.viewObj.Medium2zSlider.Value;
        z3 = app.viewObj.Medium3zSlider.Value;
        fc = app.viewObj.FreqSlider.Value;
        temp = app.viewObj.ThickSlider.Value;
        d2 = floor(temp) + ceil( (temp-floor(temp))/0.25) * 0.25;
        app.modelObj.updateSettings(c2, z1, z2, z3, fc, d2);
    end

    %Updates editfeidls
    function EditChanged(app, src, event, slider, editField)
        slider.Value = editField.Value;
        c2 = 1540;
        z1 = app.viewObj.Medium1zSlider.Value;
        z2 = app.viewObj.Medium2zSlider.Value;
        z3 = app.viewObj.Medium3zSlider.Value;
        fc = app.viewObj.FreqSlider.Value;
        %The GUI breaks down if thickness is not in multiples of 0.25, so I
        %round up to the closest one.
        temp = app.viewObj.ThickSlider.Value;
        d2 = floor(temp) + ceil( (temp-floor(temp))/0.25) * 0.25;
        app.modelObj.updateSettings(c2, z1, z2, z3, fc, d2);
    end

    function codeViewPushed(app, src, event)
        edit('code.mlx');
    end
   end 
end