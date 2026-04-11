NAMESPACE AXOpen.Components.Desoutter.Tightening
    {S7.extern=ReadWrite}
    CLASS DesoutterTightening EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject :AxoObject;
            axoCVIC_II : AxoCVIC_II_Showcase;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            axoCVIC_II.Run(_rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE