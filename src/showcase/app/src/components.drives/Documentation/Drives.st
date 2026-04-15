NAMESPACE AXOpen.Components.Drives
    {S7.extern=ReadWrite}
    CLASS DrivesShowcase EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject :   AxoObject;
            axoDriveExample : AxoDriveExample_Showcase;
            axoDriveExample_2 : AxoDriveExample_Showcase2;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            axoDriveExample.Run(_rootObject);
            axoDriveExample_2.Run(_rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE