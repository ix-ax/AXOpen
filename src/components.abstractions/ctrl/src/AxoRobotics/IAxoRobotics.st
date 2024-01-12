USING AXOpen.Core;
NAMESPACE AXOpen.Components.Abstractions.Robotics
    INTERFACE PUBLIC IAxoRobotics
        METHOD StartAtMain : AXOpen.Core.IAxoTaskState  END_METHOD
        METHOD StartMotorsAndProgram : AXOpen.Core.IAxoTaskState  END_METHOD
        METHOD StartMovements  :   AXOpen.Core.IAxoTaskState
            VAR_INPUT
                inData : AxoRoboticsMovementsParams;
            END_VAR
        END_METHOD
        METHOD StopMovements  :   AXOpen.Core.IAxoTaskState
            VAR_INPUT
                inStopType : eAxoRoboticsStopType;
            END_VAR
        END_METHOD
        METHOD StopMovementsAndProgram  :   AXOpen.Core.IAxoTaskState
            VAR_INPUT
                inStopType : eAxoRoboticsStopType;
            END_VAR
        END_METHOD
 
    END_INTERFACE    
END_NAMESPACE
