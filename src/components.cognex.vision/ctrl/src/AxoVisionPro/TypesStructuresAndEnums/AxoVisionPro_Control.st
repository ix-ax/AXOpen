NAMESPACE AXOpen.Components.Cognex.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC AxoVisionPro_Control
        VAR PUBLIC 
            SoftEvent               : AxoVisionProSoftEventControl;
            SetUserdata             : BOOL;
            InitiateJobLoad         : BOOL;
            InspectionResultsAck    : BOOL;
            ID_Inspection           : INT;   // rezerva
            JobLoadID               : UINT;
            WriteDataID             : INT;
        END_VAR 
    END_CLASS    
END_NAMESPACE