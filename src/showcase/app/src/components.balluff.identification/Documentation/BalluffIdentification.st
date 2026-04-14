NAMESPACE AXOpen.Components.Balluff.Identification
    {S7.extern=ReadWrite}
    CLASS BalluffIdentification EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject : AxoObject;
            axo_BIS_M_4XX_045               : Axo_BIS_M_4XX_045_Example;
            axo_BIS_M_4XX_045_ManualControl : Axo_BIS_M_4XX_045_ManualControl_Example;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            axo_BIS_M_4XX_045.Run(_rootObject);
            axo_BIS_M_4XX_045_ManualControl.Run(_rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE
