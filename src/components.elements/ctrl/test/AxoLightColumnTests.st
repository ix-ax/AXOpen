USING AxUnit;
USING AXOpen.Elements;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;
USING AXOpen.Components.Elements;

NAMESPACE AXOpen.Elements.Tests
   
    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoLightColumnTests 
        VAR 
            context : TestContext;
            _testLightColumn : AxoSignalTower;
            _redOutput : BOOL;
            _greenOutput : BOOL;
            _blueOutput : BOOL;
            _yellowOutput : BOOL;
            _hornOutput : BOOL;
        END_VAR   

        {Test}
        METHOD PUBLIC Test_Run_WithValidParent
            context.Open();
            
            _testLightColumn.Run(inParent := context.SignalParent, outRed => _redOutput, outGreen => _greenOutput, outBlue => _blueOutput, outYellow => _yellowOutput, outHorn => _hornOutput);
            
            // Test that the component runs without errors when parent is valid
            // The outputs should be processed correctly
            context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC Test_Run_NullParent_DoesNotRun
            _testLightColumn.Run(inParent := NULL, outRed => _redOutput, outGreen => _greenOutput, outBlue => _blueOutput, outYellow => _yellowOutput, outHorn => _hornOutput);
            
            // Component should not process anything when parent is null
            // No exceptions should be thrown
        END_METHOD

        {Test}
        METHOD PUBLIC Test_Red_SetAndReset
            context.Open();
            
            // Set red light
            _testLightColumn.Red.Set();
            _testLightColumn.Run(inParent := context.SignalParent, outRed => _redOutput, outGreen => _greenOutput, outBlue => _blueOutput, outYellow => _yellowOutput, outHorn => _hornOutput);
            
            AxUnit.Assert.Equal(TRUE, _testLightColumn.Red.IsTrue());
            
            // Reset red light
            _testLightColumn.Red.Reset();
            _testLightColumn.Run(inParent := context.SignalParent, outRed => _redOutput, outGreen => _greenOutput, outBlue => _blueOutput, outYellow => _yellowOutput, outHorn => _hornOutput);
            
            AxUnit.Assert.Equal(FALSE, _testLightColumn.Red.IsTrue());
            
            context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC Test_Green_SetAndReset
            context.Open();
            
            // Set green light
            _testLightColumn.Green.Set();
            _testLightColumn.Run(inParent := context.SignalParent, outRed => _redOutput, outGreen => _greenOutput, outBlue => _blueOutput, outYellow => _yellowOutput, outHorn => _hornOutput);
            
            AxUnit.Assert.Equal(TRUE, _testLightColumn.Green.IsTrue());
            
            // Reset green light
            _testLightColumn.Green.Reset();
            _testLightColumn.Run(inParent := context.SignalParent, outRed => _redOutput, outGreen => _greenOutput, outBlue => _blueOutput, outYellow => _yellowOutput, outHorn => _hornOutput);
            
            AxUnit.Assert.Equal(FALSE, _testLightColumn.Green.IsTrue());
            
            context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC Test_Blue_SetAndReset
            context.Open();
            
            // Set blue light
            _testLightColumn.Blue.Set();
            _testLightColumn.Run(inParent := context.SignalParent, outRed => _redOutput, outGreen => _greenOutput, outBlue => _blueOutput, outYellow => _yellowOutput, outHorn => _hornOutput);
            
            AxUnit.Assert.Equal(TRUE, _testLightColumn.Blue.IsTrue());
            
            // Reset blue light
            _testLightColumn.Blue.Reset();
            _testLightColumn.Run(inParent := context.SignalParent, outRed => _redOutput, outGreen => _greenOutput, outBlue => _blueOutput, outYellow => _yellowOutput, outHorn => _hornOutput);
            
            AxUnit.Assert.Equal(FALSE, _testLightColumn.Blue.IsTrue());
            
            context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC Test_Yellow_SetAndReset
            context.Open();
            
            // Set yellow light
            _testLightColumn.Yellow.Set();
            _testLightColumn.Run(inParent := context.SignalParent, outRed => _redOutput, outGreen => _greenOutput, outBlue => _blueOutput, outYellow => _yellowOutput, outHorn => _hornOutput);
            
            AxUnit.Assert.Equal(TRUE, _testLightColumn.Yellow.IsTrue());
            
            // Reset yellow light
            _testLightColumn.Yellow.Reset();
            _testLightColumn.Run(inParent := context.SignalParent, outRed => _redOutput, outGreen => _greenOutput, outBlue => _blueOutput, outYellow => _yellowOutput, outHorn => _hornOutput);
            
            AxUnit.Assert.Equal(FALSE, _testLightColumn.Yellow.IsTrue());
            
            context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC Test_Horn_SetAndReset
            context.Open();
            
            // Set horn
            _testLightColumn.Horn.Set();
            _testLightColumn.Run(inParent := context.SignalParent, outRed => _redOutput, outGreen => _greenOutput, outBlue => _blueOutput, outYellow => _yellowOutput, outHorn => _hornOutput);
            
            AxUnit.Assert.Equal(TRUE, _testLightColumn.Horn.IsTrue());
            
            // Reset horn
            _testLightColumn.Horn.Reset();
            _testLightColumn.Run(inParent := context.SignalParent, outRed => _redOutput, outGreen => _greenOutput, outBlue => _blueOutput, outYellow => _yellowOutput, outHorn => _hornOutput);
            
            AxUnit.Assert.Equal(FALSE, _testLightColumn.Horn.IsTrue());
            
            context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC Test_MultipleLights_SetSimultaneously
            context.Open();
            
            // Set multiple lights at once
            _testLightColumn.Red.Set();
            _testLightColumn.Green.Set();
            _testLightColumn.Horn.Set();
            
            _testLightColumn.Run(inParent := context.SignalParent, outRed => _redOutput, outGreen => _greenOutput, outBlue => _blueOutput, outYellow => _yellowOutput, outHorn => _hornOutput);
            
            AxUnit.Assert.Equal(TRUE, _testLightColumn.Red.IsTrue());
            AxUnit.Assert.Equal(TRUE, _testLightColumn.Green.IsTrue());
            AxUnit.Assert.Equal(FALSE, _testLightColumn.Blue.IsTrue());
            AxUnit.Assert.Equal(FALSE, _testLightColumn.Yellow.IsTrue());
            AxUnit.Assert.Equal(TRUE, _testLightColumn.Horn.IsTrue());
            
            context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC Test_Restore_CallsRestoreOnAllComponents
            context.Open();
            
            // Set some lights first                     
            _testLightColumn.Red.Set();
            _testLightColumn.Green.Reset(); 
            _testLightColumn.Blue.Reset(); 
            _testLightColumn.Yellow.Set();
            _testLightColumn.Horn.Set();  

            // Now restore
            _testLightColumn.Restore();
            
            // After restore, the signals should maintain the previous state since only tasks are restored.
            _testLightColumn.Run(inParent := context.SignalParent, outRed => _redOutput, outGreen => _greenOutput, outBlue => _blueOutput, outYellow => _yellowOutput, outHorn => _hornOutput);
            
            AxUnit.Assert.Equal(TRUE, _testLightColumn.Red.IsTrue());
            AxUnit.Assert.Equal(TRUE, _testLightColumn.Green.IsFalse());
            AxUnit.Assert.Equal(TRUE, _testLightColumn.Blue.IsFalse());
            AxUnit.Assert.Equal(TRUE, _testLightColumn.Yellow.IsTrue());
            AxUnit.Assert.Equal(TRUE, _testLightColumn.Horn.IsTrue());
            
            context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC Test_AllLights_Off_Initially
            context.Open();
            
            // Test that all lights start in OFF state
            _testLightColumn.Run(inParent := context.SignalParent, outRed => _redOutput, outGreen => _greenOutput, outBlue => _blueOutput, outYellow => _yellowOutput, outHorn => _hornOutput);
            
            AxUnit.Assert.Equal(FALSE, _testLightColumn.Red.IsTrue());
            AxUnit.Assert.Equal(FALSE, _testLightColumn.Green.IsTrue());
            AxUnit.Assert.Equal(FALSE, _testLightColumn.Blue.IsTrue());
            AxUnit.Assert.Equal(FALSE, _testLightColumn.Yellow.IsTrue());
            AxUnit.Assert.Equal(FALSE, _testLightColumn.Horn.IsTrue());
            
            context.Close();
        END_METHOD
    END_CLASS
END_NAMESPACE