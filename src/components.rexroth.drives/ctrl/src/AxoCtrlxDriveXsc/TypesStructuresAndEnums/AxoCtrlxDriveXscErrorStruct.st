NAMESPACE AXOpen.Components.Rexroth.Drives    
    TYPE
        {S7.extern=ReadWrite} 
        AxoCtrlxDriveXscErrorStruct :
        STRUCT
            Table       : AXOpen.Components.Rexroth.Drives.eAxoCtrlxDriveXscErrorTable;          (* Additional diagnosis table           *)
            Additional1 : DWORD;                (* Additional diagnosis number1         *)
            Additional2 : DWORD;                (* Additional diagnosis number2         *)
        END_STRUCT;
    END_TYPE
END_NAMESPACE
