USING AxUnit;
USING AXOpen.Components.Elements;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;
USING AXOpen.Components.Elements;

NAMESPACE AXOpen.Components.Elements.Tests
   
    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoButtonWithIndicatorTests 
        VAR 
            context : TestContext;
            _testButtonWithIndicator : AxoBacklitButton;
            _inputSignal : BOOL;
            _ledOutput : BOOL;
        END_VAR   
       
        {Test}
        METHOD PUBLIC Test_Run_all_on
            VAR
                signal : BOOL := TRUE;
            END_VAR
            
            context.Open();
            _inputSignal := TRUE;
            _testButtonWithIndicator.Run(context.SignalParent, _inputSignal, _ledOutput);
            
            // Assert that the button component processes the signal correctly
            AxUnit.Assert.Equal(TRUE, _testButtonWithIndicator.Button.IsTrue());
            _testButtonWithIndicator.Led.Set();
            AxUnit.Assert.Equal(TRUE, _testButtonWithIndicator.Led.IsTrue());
            context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC Test_Run_all_off
            VAR
                signal : BOOL := TRUE;
            END_VAR
            
            context.Open();
            _inputSignal := FALSE;
            _testButtonWithIndicator.Run(context.SignalParent, _inputSignal, _ledOutput);
            
            // Assert that the button component processes the signal correctly
            AxUnit.Assert.Equal(TRUE, _testButtonWithIndicator.Button.IsFalse());
            _testButtonWithIndicator.Led.Reset();
            AxUnit.Assert.Equal(TRUE, _testButtonWithIndicator.Led.IsFalse());
            context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC Test_Run_NullParent_DoesNotRun
            VAR
                signal : BOOL := TRUE;
            END_VAR
            
            _inputSignal := TRUE;
            _testButtonWithIndicator.Run(NULL, _inputSignal, _ledOutput);
            
            // Assert that nothing happens when parent is null
            // The component should not process anything
            
        END_METHOD

        {Test}
        METHOD PUBLIC Test_Restore_CallsRestoreOnChildren
            context.Open();
            _testButtonWithIndicator.Restore();
            context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC Test_ManualControl_CallsManualControlOnChildren
            context.Open();
            _testButtonWithIndicator.ActivateManualControl();
            context.Close();
        END_METHOD
    END_CLASS
END_NAMESPACE
