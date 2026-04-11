USING AXOpen.Components.Cognex.Vision;

NAMESPACE AXOpen.Components.Cognex.Vision

    {S7.extern=ReadWrite}
    CLASS CognexVision EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject :   AxoObject;
            axoInsight_v_6_0_0_0 : AxoInsight_v_6_0_0_0_Showcase;
            axoDataman_v_6_0_0_0 : AxoDataman_v_6_0_0_0_Showcase;
            axoDataman_v_6_0_0_0_2 : AxoDataman_v_6_0_0_0_Showcase2;
            axoInsight_v_24_0_0 : AxoInsight_v_24_0_0_Showcase;
            axoVisionPro : AxoVisionPro_Showcase;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            axoInsight_v_6_0_0_0.Run(_rootObject);
            axoDataman_v_6_0_0_0.Run(_rootObject);
            axoDataman_v_6_0_0_0_2.Run(_rootObject);
            axoInsight_v_24_0_0.Run(_rootObject);
            axoVisionPro.Run(_rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE