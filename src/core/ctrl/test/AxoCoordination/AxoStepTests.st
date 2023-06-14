USING AXOpen.Logging;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AxUnit;

NAMESPACE AXOpen.Core.AxoStep_Tests        
    CLASS TestContext IMPLEMENTS IAxoContext         
        VAR PROTECTED                        
            _openCounter : ULINT;
            _closeCounter : ULINT;
            _identityCounter : ULINT;
         END_VAR       
        METHOD PUBLIC Open : ULINT
            _openCounter := _openCounter + ULINT#1;
        END_METHOD    

        METHOD PUBLIC Close : ULINT
            _closeCounter := _closeCounter + ULINT#1;
        END_METHOD

        METHOD PUBLIC OpenCycleCount : ULINT
            OpenCycleCount := _openCounter;
        END_METHOD
                
        METHOD PUBLIC ClosedCycleCount : ULINT
            ClosedCycleCount := _closeCounter;
        END_METHOD

        METHOD PUBLIC CreateIdentity : ULINT            
            _identityCounter := _identityCounter + ULINT#1;
            CreateIdentity := _identityCounter;
        END_METHOD         

        METHOD PUBLIC GetRtc : IAxoRtc ; END_METHOD

        METHOD PUBLIC InjectRtc VAR_INPUT Rtc : IAxoRtc; END_VAR ; END_METHOD
            
        VAR PRIVATE
            NULL_LOGGER : _NULL_LOGGER;
        END_VAR    
        METHOD PUBLIC GetLogger : AXOpen.Logging.IAxoLogger GetLogger := NULL_LOGGER; END_METHOD
        METHOD PUBLIC InjectLogger VAR_INPUT _logger : AXOpen.Logging.IAxoLogger; END_VAR ; END_METHOD
           
    END_CLASS      

    {TestFixture}
    CLASS StepTests
        VAR PROTECTED
            _context : TestContext;
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

            Assert.Equal('StepOne', _stepOne.StepDescription);
            Assert.Equal('StepTwo', _stepTwo.StepDescription);
            Assert.Equal('StepThree', _stepThree.StepDescription);
            _context.Close();

            _context.Open();
            _stepOne.Execute(_sequencer);            
            _stepTwo.Execute(_sequencer);            
            _stepThree.Execute(_sequencer);             
            Assert.Equal('StepOne', _stepOne.StepDescription);
            Assert.Equal('StepTwo', _stepTwo.StepDescription);
            Assert.Equal('StepThree', _stepThree.StepDescription);
            _context.Close();

            _context.Open();
            _stepOne.Execute(_sequencer,'StepOne-new description');            
            _stepTwo.Execute(_sequencer);            
            _stepThree.Execute(_sequencer);             
            Assert.Equal('StepOne-new description', _stepOne.StepDescription);
            Assert.Equal('StepTwo', _stepTwo.StepDescription);
            Assert.Equal('StepThree', _stepThree.StepDescription);
        END_METHOD  
       END_CLASS
END_NAMESPACE
