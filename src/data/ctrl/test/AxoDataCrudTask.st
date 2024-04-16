USING AXOpen.Core;
USING AXOpen.Rtc;
USING AxUnit;

NAMESPACE DummyNmspc   
        {TestFixture}
        {S7.extern=ReadWrite}
        CLASS DummyClass
           
            {Test}
            METHOD PUBLIC Create_sets_identifier                
                AxUnit.Assert.Equal(TRUE, TRUE);
            END_METHOD
                      
        END_CLASS
END_NAMESPACE    
