NAMESPACE AXOpen.Components.Rexroth.Tightening
    {S7.extern=ReadWrite}
    CLASS RexrothTightening EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            rootObject      : AxoObject;
            axo_CS351_compact    : AXOpen.Components.Rexroth.Tightening.Axo_CS351_compact_Showcase;
            axo_CS351_compact_2    : AXOpen.Components.Rexroth.Tightening.Axo_CS351_compact_Showcase2;
        END_VAR

        METHOD PUBLIC Execute
            rootObject.Run(THIS);
            axo_CS351_compact.Run(rootObject);
            axo_CS351_compact_2.Run(rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE