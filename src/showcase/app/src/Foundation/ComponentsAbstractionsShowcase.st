USING AXOpen.Core;

// Showcase reference for AXOpen.Components.Abstractions — documents the
// standard interface contracts that all component implementations must follow.
// This library defines IAxoDrive, IAxoRobotics, IAxoCodeReader,
// IAxoVisionSensor, IAxo_Power, and supporting data types.
NAMESPACE AXOpen.Showcase.ComponentsAbstractions

    {S7.extern=ReadWrite}
    CLASS DocumentationContext EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject : AxoObject;
            _abstractionsDoc : ComponentAbstractionsDoc;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            _abstractionsDoc.Run(_rootObject);
        END_METHOD
    END_CLASS

    // Reference class showing the shared data types used across all components.
    {S7.extern=ReadWrite}
    CLASS PUBLIC ComponentAbstractionsDoc EXTENDS AXOpen.Core.AxoObject
        //<ComponentAbstractionsDeclarations>
        VAR PUBLIC
            _componentStatus : AXOpen.Components.Abstractions.AxoComponent_Status;
            _robotCoordinates : AXOpen.Components.Abstractions.Robotics.AxoRoboticsCoordinates;
            _basicCoordinates : AXOpen.Components.Abstractions.Robotics.AxoRoboticsBasicCoordinates;
            _movementParams : AXOpen.Components.Abstractions.Robotics.AxoRoboticsMovementsParams;
            _driveDirection : AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;
            _executionMode : AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;
            _stopType : AXOpen.Components.Abstractions.Robotics.eAxoRoboticsStopType;
        END_VAR
        //</ComponentAbstractionsDeclarations>

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR
            SUPER.Run(inParent);

            //<RoboticsDataTypes>
            // AxoRoboticsCoordinates: 6-axis position (X, Y, Z, Rx, Ry, Rz)
            _robotCoordinates.X := REAL#100.0;
            _robotCoordinates.Y := REAL#200.0;
            _robotCoordinates.Z := REAL#50.0;
            _robotCoordinates.Rx := REAL#0.0;
            _robotCoordinates.Ry := REAL#90.0;
            _robotCoordinates.Rz := REAL#0.0;

            // AxoRoboticsMovementsParams: movement configuration
            _movementParams.ActionNo := BYTE#1;
            _movementParams.GlobalSpeed := BYTE#50;
            _movementParams.ToolNo := BYTE#1;
            _movementParams.WorkobjectNo := BYTE#0;
            _movementParams.Coordinates := _robotCoordinates;
            //</RoboticsDataTypes>

            //<DriveEnums>
            // eAxoDriveDirection: PositiveDirection, ShortestWay, NegativeDirection, CurrentDirection
            _driveDirection := AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection;
            // eAxoExecutionMode: Immediately, Queued
            _executionMode := AXOpen.Components.Abstractions.Drives.eAxoExecutionMode#Immediately;
            //</DriveEnums>
        END_METHOD
    END_CLASS

END_NAMESPACE
