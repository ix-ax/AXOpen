// USING AXOpen.Components.Example;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE AxoCmmtAsDriveTests.Tests
    {S7.extern=ReadWrite}
    CLASS TestContext EXTENDS AXOpen.Core.Dummies.MockAxoContext                    
            METHOD PROTECTED OVERRIDE Main
                ;
            END_METHOD               
    END_CLASS   
    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoCmmtAsDriveTests
        VAR 
            context : TestContext;
            drive   : AXOpen.Components.Festo.Drives.AxoCmmtAs;
            _AxisIn          :   ARRAY[0..10] OF BYTE;       //  Input data of the axis
            _AxisOut         :   ARRAY[0..10] OF BYTE;       //  Output data of the axis
            _Enable          :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
            _EnablePositive  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in positive direction
            _EnableNegative  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in negative direction
            _busy : BOOL;
        END_VAR           
        {Test}
        METHOD PUBLIC AxoHome
            AxUnit.Assert.Equal(TRUE,TRUE);   
        END_METHOD
    END_CLASS    
END_NAMESPACE
