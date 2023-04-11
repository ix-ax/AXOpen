USING AxUnit;
USING AXOpen.Core;
USING AXOpen.Rtc;

NAMESPACE AXOpen.Core
    NAMESPACE AxoRemoteTasksTests
        
    
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
        
    
        METHOD PUBLIC Environment : IAxoContextEnvironment
            ;
        END_METHOD
    END_CLASS      
   
    {TestFixture}
    CLASS IxRemoteTaskTests 
        VAR PROTECTED
           _context : TestContext;
           myTask : AxoRemoteTask;
           expState:  eAxoTaskState;
           actState:  eAxoTaskState;
           initValue : ULINT;
        END_VAR    

        METHOD PRIVATE Initialize
            myTask.Initialize(_context);
        END_METHOD     

        METHOD Equal : BOOL
            VAR_INPUT
                 expected:  eAxoTaskState;
                 actual:  eAxoTaskState;
            END_VAR
            Equal := expected = actual;
        END_METHOD 

        {Test}
        METHOD PUBLIC should_invoke_remote_task             
            // Arrange
            THIS.Initialize();
            _context.Open();
            myTask.Invoke();
            Assert.Equal(TRUE, myTask.Execute());             
            _context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC should_invoke_remote_task_and_set_context_counter
            VAR
                _contexCounter : ULINT;
            END_VAR;    
            // Arrange
            THIS.Initialize();
            _context.Open();
            _contexCounter := _context.OpenCycleCount();
            //Act/Assert
            myTask.Invoke();
            Assert.Equal(FALSE, _contexCounter = myTask.GetStartSignature());
            Assert.Equal(TRUE, myTask.Execute());  
            Assert.Equal(_contexCounter, myTask.GetStartSignature());                
            _context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC should_complete_remote_task
            VAR
                _contexCounter : ULINT;
            END_VAR;    
            // Arrange
            THIS.Initialize();
            _context.Open();
            _contexCounter := _context.OpenCycleCount();
            //Act/Assert
            myTask.Invoke();          
            Assert.Equal(TRUE, myTask.Execute());                                          
            _context.Close();

            _context.Open();
            myTask.SetDoneSignature();
            myTask.Execute();
            THIS.Equal(eAxoTaskState#Done, myTask.Status);
            Assert.Equal(FALSE, myTask.Execute());        
            _context.Close();
        END_METHOD

    END_CLASS
    END_NAMESPACE
END_NAMESPACE
