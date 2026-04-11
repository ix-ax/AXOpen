NAMESPACE AXOpen.Components.Festo.Drives
    {S7.extern=ReadWrite}
    CLASS FestoDrives EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject:    AxoObject;
            axoCmmtAs    : AxoCmmtAs_Showcase;
            axoCmmtAs_2    : AxoCmmtAs_Showcase2;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            axoCmmtAs.Run(_rootObject);
            // axoCmmtAs_2.Run(_rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE