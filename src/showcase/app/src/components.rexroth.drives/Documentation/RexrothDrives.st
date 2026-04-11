NAMESPACE AXOpen.Components.Rexroth.Drives
    {S7.extern=ReadWrite}
    CLASS RexrothDrives EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject :    AxoObject;
            axoIndraDrive : AxoIndraDrive_Showcase;
            axoCtrlxDriveXsc : AxoCtrlxDriveXsc_Showcase;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            axoIndraDrive.Run(_rootObject);
            axoCtrlxDriveXsc.Run(_rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE