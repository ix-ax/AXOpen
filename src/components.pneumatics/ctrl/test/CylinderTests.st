USING AXOpen.Components.Pneumatics;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE Cylinder.Tests
    CLASS TestContext IMPLEMENTS AXOpen.Core.IAxoContext
        VAR
            _openCounter : ULINT;
            _closeCounter : ULINT; 
        END_VAR
              
        METHOD PUBLIC Open : ULINT
            _openCounter := _openCounter + ULINT#1;
        END_METHOD    

        METHOD PUBLIC Close : ULINT
            _closeCounter := _closeCounter + ULINT#1;
        END_METHOD

        METHOD PUBLIC CreateIdentity : ULINT
            ;
        END_METHOD

        METHOD PUBLIC OpenCycleCount : ULINT
            OpenCycleCount := _openCounter;
        END_METHOD

        METHOD PUBLIC GetRtc : AXOpen.Rtc.IAxoRtc
            ;
        END_METHOD

        METHOD PUBLIC InjectRtc
            VAR_INPUT
                Rtc : IAxoRtc;
            END_VAR

            ;
        END_METHOD

        METHOD PUBLIC GetLogger : IAxoLogger
            ;
        END_METHOD

        METHOD PUBLIC InjectLogger
            VAR_INPUT
                _logger : IAxoLogger;
            END_VAR

            ;
        END_METHOD
    END_CLASS
    {TestFixture}
    CLASS CylinderTests 
        VAR 
            context : TestContext;
            cylinder : AxoCylinder;
            _homeSensor : BOOL;
            _workSensor : BOOL;
            _moveHomeSignal : BOOL;
            _moveWorkSignal : BOOL;
            _done : BOOL;
        END_VAR    
        
        {Test}
        METHOD PUBLIC MoveHome          
               
                context.Open();                                                              
                cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
                cylinder.MoveToHome.Invoke();
                context.Close();                          
                
                context.Open();                                                              
                cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
                context.Close();                          
                
                context.Open();                                                              
                cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
                context.Close();                          

                context.Open();                                                              
                cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
                context.Close();                          
                
                AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
                AxUnit.Assert.Equal(FALSE, _moveHomeSignal);   
        END_METHOD
    END_CLASS    
END_NAMESPACE
