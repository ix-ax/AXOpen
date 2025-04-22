NAMESPACE AXOpen.Components.Cognex.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC AxoVisionPro_Status
        VAR PUBLIC 
            SoftEvent                  : AxoVisionProSoftEventStatus;
            SetUserDataAck             : BOOL;
            Online                     : BOOL;
            SystemBusy                 : BOOL;
            SystemReady                : BOOL;
            JobLoadComplete            : BOOL;
            InspectionOnline           : BOOL;   // Error ID bit z errorID int premennej
            ResultValid                : BOOL;
            ID_Inspection              : INT;   // rezerva CurentJobID, mozno na kontrolu. 
            CurentJobID                : UINT;
            UserDataJobID              : UINT;
            ReadedDataVariantSize      : INT;   // velkost VARIANT dat ktore chceme vycitat
            WrittenDataVariantSize     : INT;   // velkost VARIANT dat ktore chceme vycitat
            UserDataLockerJobID        : UINT;   // camera*10 + job
            UserDataLockerIdOperation  : BYTE;
            ReadDataLockerJobID        : UINT;   // camera*10 + job
        END_VAR 
    END_CLASS    
END_NAMESPACE