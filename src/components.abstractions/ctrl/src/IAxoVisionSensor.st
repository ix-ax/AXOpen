USING AXOpen.Core;
NAMESPACE AXOpen.Components.Abstractions
    INTERFACE PUBLIC IAxoVisionSensor
        METHOD ClearInspectionResults : IAxoTaskState END_METHOD                            
        METHOD Trigger : IAxoTaskState END_METHOD
        METHOD ChangeJob : IAxoTaskState  VAR_INPUT Job : UINT; END_VAR END_METHOD    
        METHOD ChangeJob : IAxoTaskState  VAR_INPUT Job : STRING; END_VAR END_METHOD    
    END_INTERFACE    
END_NAMESPACE
