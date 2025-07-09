USING AXOpen.Core;
USING AXOpen.Data;

NAMESPACE Tests_L1.Distributed  
   
    {S7.extern=ReadWrite}
    CLASS PUBLIC ExchangesWrappedInAxoObject EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC   

            Header      : Tests_L1.SharedEntityHeaderManager;   

            Station_1   : Tests_L1.StationDataManager;

            Station_2   : Tests_L1.StationDataManager;

        END_VAR

        
        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR
    
            SUPER.Run(inParent := inParent);
            Header.Run(inParent);
            Station_1.Run(inParent);
            Station_2.Run(inParent);
        END_METHOD

    END_CLASS

END_NAMESPACE
