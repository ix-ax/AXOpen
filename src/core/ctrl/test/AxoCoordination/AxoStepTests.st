USING AXOpen.Logging;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AxUnit;

NAMESPACE AxOpenCoreAssert
    FUNCTION Equal
        VAR_INPUT
            expected : STRING[254];
            actual : STRING[254];
        END_VAR    
        Assert.Equal(TRUE, expected = actual);
    END_FUNCTION             
END_NAMESPACE

NAMESPACE AXOpen.Core.AxoStep_Tests     
    
    

    {S7.extern=ReadWrite}
   CLASS TestContext EXTENDS AXOpen.Core.Dummies.MockAxoContext                    
            METHOD PROTECTED OVERRIDE Main
                ;
            END_METHOD               
    END_CLASS         

    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS StepTests
        VAR PROTECTED
            _context    : TestContext;
            _stepOne    : AxoStep;
            _stepTwo    : AxoStep;
            _stepThree  : AxoStep;
            _sequencer  : AxoSequencer;
        END_VAR  
        METHOD PRIVATE Initialize
            _sequencer.Initialize(_context);
            _stepOne.Initialize(_context);
            _stepTwo.Initialize(_context);
            _stepThree.Initialize(_context);
        END_METHOD
        METHOD Equal : BOOL
            VAR_INPUT
                expected:  AxoCoordinatorStates;
                actual:  AxoCoordinatorStates;
            END_VAR
            Equal := expected = actual;
        END_METHOD 

        VAR PRIVATE
            _contextClean   : TestContext;
            _rtc            :   AXOpen.Core.Dummies.MockAxoRtc;
            _rtm            :   AXOpen.Core.Dummies.MockAxoRtm;
            _stepOneClean   : AxoStep;
            _stepTwoClean   : AxoStep;
            _stepThreeClean : AxoStep;
            _sequencerClean : AxoSequencer;
        END_VAR  

        {TestSetup}
        METHOD PUBLIC TestSetup
            _context    :=  _contextClean;
            _rtm.SetElapsed(LTIME#2s);
            _context.InjectRtm(_rtm);
            _rtc.SetNowUTC(LDATE_AND_TIME#2012-01-12-15:58:12.123);
            _context.InjectRtc(_rtc);
            _stepOne    :=  _stepOneClean;
            _stepTwo    :=  _stepTwoClean;
            _stepThree  :=  _stepThreeClean;
            _sequencer  :=  _sequencerClean;
        END_METHOD

        {TestTearDown}
        METHOD PUBLIC TestTearDown
            ;
        END_METHOD

        {FixtureSetup}
        METHOD PUBLIC FixtureSetup
            ;
        END_METHOD

        {FixtureTearDown}
        METHOD PUBLIC FixtureTearDown
            ;
        END_METHOD

        {Test}        
        METHOD PUBLIC Execute_should_set_the_order_from_coordinator_when_in_config_mode
            THIS.Initialize();
            _context.Open();
            _sequencer.Invoke();
            _sequencer.Open();
            _stepOne.Execute(_sequencer);
            Assert.Equal(ULINT#1, _stepOne.GetStepOrder());
            _stepTwo.Execute(_sequencer);
            Assert.Equal(ULINT#2, _stepTwo.GetStepOrder());
            _stepThree.Execute(_sequencer);
            Assert.Equal(ULINT#3, _stepThree.GetStepOrder());
            Assert.Equal(TRUE , THIS.Equal(AxoCoordinatorStates#Configuring , _sequencer.GetCoordinatorState()));
        END_METHOD

        {Test}
        METHOD PUBLIC Execute_should_not_crush_when_coordinator_not_passed                        
            _stepOne.Execute(coord := NULL);                         
        END_METHOD

        {Test}        
        METHOD PUBLIC GetStepOrder_should_should_return_correct_order_of_steps
            THIS.Initialize();
            _context.Open();
            _sequencer.Invoke();
            _sequencer.Open();
            _stepOne.Execute(_sequencer);            
            _stepTwo.Execute(_sequencer);            
            _stepThree.Execute(_sequencer);            
            Assert.Equal(TRUE , THIS.Equal(AxoCoordinatorStates#Configuring , _sequencer.GetCoordinatorState()));
            _context.Close();
            
            _context.Open();
            _sequencer.Open();
            Assert.Equal(ULINT#1, _stepOne.GetStepOrder());
            Assert.Equal(ULINT#2, _stepTwo.GetStepOrder());
            Assert.Equal(ULINT#3, _stepThree.GetStepOrder());
            Assert.Equal(TRUE , THIS.Equal(AxoCoordinatorStates#Running , _sequencer.GetCoordinatorState()));
        END_METHOD

        {Test}
        METHOD PUBLIC step_description_should_be_assigned_via_the_argument
            THIS.Initialize();
            _context.Open();
            _sequencer.Invoke();
            _sequencer.Open();
            _stepOne.Execute(_sequencer,'StepOne');            
            _stepTwo.Execute(_sequencer,TRUE,'StepTwo');            
            _stepThree.Execute(_sequencer,FALSE,'StepThree');             

            AxOpenCoreAssert.Equal('StepOne', _stepOne.StepDescription);
            AxOpenCoreAssert.Equal('StepTwo', _stepTwo.StepDescription);
            AxOpenCoreAssert.Equal('StepThree', _stepThree.StepDescription);
            _context.Close();

            _context.Open();
            _stepOne.Execute(_sequencer);            
            _stepTwo.Execute(_sequencer);            
            _stepThree.Execute(_sequencer);             
            AxOpenCoreAssert.Equal('StepOne', _stepOne.StepDescription);
            AxOpenCoreAssert.Equal('StepTwo', _stepTwo.StepDescription);
            AxOpenCoreAssert.Equal('StepThree', _stepThree.StepDescription);
            _context.Close();

            _context.Open();
            _stepOne.Execute(_sequencer,'StepOne-new description');            
            _stepTwo.Execute(_sequencer);            
            _stepThree.Execute(_sequencer);             
            AxOpenCoreAssert.Equal('StepOne-new description', _stepOne.StepDescription);
            AxOpenCoreAssert.Equal('StepTwo', _stepTwo.StepDescription);
            AxOpenCoreAssert.Equal('StepThree', _stepThree.StepDescription);
        END_METHOD  
       END_CLASS
END_NAMESPACE
