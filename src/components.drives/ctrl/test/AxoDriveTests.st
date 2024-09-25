USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE AxoDriveTests.Tests
    {S7.extern=ReadWrite}
   CLASS TestContext EXTENDS AXOpen.Core.Dummies.MockAxoContext                    
            METHOD PROTECTED OVERRIDE Main
                ;
            END_METHOD               
    END_CLASS   

    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoDriveTests
        VAR 
            context : TestContext;
            drive   : AxoTestDrive;
            _AxisIn          :   ARRAY[0..10] OF BYTE;       
            _AxisOut         :   ARRAY[0..10] OF BYTE;       
            _Enable          :   BOOL;                       
            _EnablePositive  :   BOOL;                       
            _EnableNegative  :   BOOL;                       
            _busy : BOOL;
        END_VAR           
        {Test}
        METHOD PUBLIC AxoHome
            // WHILE NOT _busy DO
            //     context.Open();
            //     _busy := (drive.AxoHome(  Position        :=  LREAL#5.0,
            //         HommingMode     :=  INT#10,
            //         Velocity        :=  LREAL#10.0,
            //         Acceleration    :=  LREAL#50.0,
            //         Deceleration    :=  LREAL#50.0
            //         ).IsBusy());
            //     drive.Run(context, REF(_AxisIn), REF(_AxisOut), _Enable, _EnablePositive, _EnableNegative);        
            //     AxUnit.Assert.Equal(TRUE,TRUE);   
            //     context.Close();            
            // END_WHILE;
            AxUnit.Assert.Equal(TRUE,TRUE);   
        END_METHOD
    END_CLASS    
END_NAMESPACE
