NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    CLASS DukaneWelders EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            rootObject      : AxoObject;
            axo_IQ_SeriesWelder : AXOpen.Components.Dukane.Welders.Axo_IQ_SeriesWelder_Showcase;
            axo_IQ_SeriesWelder_2 : AXOpen.Components.Dukane.Welders.Axo_IQ_SeriesWelder_Showcase2;
        END_VAR

        METHOD PUBLIC Execute
            rootObject.Run(THIS);
            axo_IQ_SeriesWelder.Run(rootObject);
            axo_IQ_SeriesWelder_2.Run(rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE