NAMESPACE AXOpen.Components.Zebra.Vision
    {S7.extern=ReadWrite}
    CLASS ZebraVision EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            rootObject      : AxoObject;
            axoEA3600    : AXOpen.Components.Zebra.Vision.AxoEA3600_Showcase;
            axoEA3600_2    : AXOpen.Components.Zebra.Vision.AxoEA3600_Showcase2;
        END_VAR

        METHOD PUBLIC Execute
            rootObject.Run(THIS);
            axoEA3600.Run(rootObject);
            axoEA3600_2.Run(rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE