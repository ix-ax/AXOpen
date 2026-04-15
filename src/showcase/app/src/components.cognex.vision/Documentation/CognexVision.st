USING AXOpen.Components.Cognex.Vision;

NAMESPACE AXOpen.Components.Cognex.Vision

    {S7.extern=ReadWrite}
    CLASS CognexVision EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject :   AxoObject;
            axoInsight_v_6_0_0_0 : AxoInsight_v_6_0_0_Example;
            axoDataman_v_6_0_0_0 : AxoDataman_Example;
            axoDataman_v_6_0_0_0_2 : AxoDataman_Secondary_Example;
            axoInsight_v_24_0_0 : AxoInsight_v_24_0_0_Example;
            axoVisionPro : AxoVisionPro_Example;
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