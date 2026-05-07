NAMESPACE AXOpen.Components.Rexroth.Press.v_4_x_x

    {S7.extern=ReadWrite}
    CLASS RexrothPress EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject : AxoObject;
            axoSmartFunctionKit_v_4_x_x : AxoSmartFunctionKit_v_4_x_x_Showcase;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            axoSmartFunctionKit_v_4_x_x.Run(_rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE