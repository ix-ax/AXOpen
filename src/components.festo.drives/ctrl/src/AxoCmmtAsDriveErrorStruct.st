NAMESPACE AXOpen.Components.Festo.Drives
    TYPE AxoCmmtAsDriveErrorStruct :
        STRUCT
            Table       : AXOpen.Components.Festo.Drives.eAxoCmmtAsDriveErrorTable;          (* Additional diagnosis table           *)
            Additional1 : DWORD;                (* Additional diagnosis number1         *)
            Additional2 : DWORD;                (* Additional diagnosis number2         *)
        END_STRUCT;
    END_TYPE
END_NAMESPACE