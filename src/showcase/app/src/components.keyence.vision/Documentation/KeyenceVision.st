NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    CLASS KeyenceVision EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            rootObject      : AxoObject;
            axo_SR_750    : AXOpen.Components.Keyence.Vision.Axo_SR_750_Showcase;
            axo_SR_1000    : AXOpen.Components.Keyence.Vision.Axo_SR_1000_Showcase;
            axo_IV3  : AXOpen.Components.Keyence.Vision.Axo_IV3_Showcase;
        END_VAR

        METHOD PUBLIC Execute
            rootObject.Run(THIS);
            axo_SR_750.Run(rootObject);
            axo_SR_1000.Run(rootObject);
            axo_IV3.Run(rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE