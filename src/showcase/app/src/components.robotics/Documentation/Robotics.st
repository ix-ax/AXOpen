USING AXOpen.Core;
USING AXOpen.Components.Abstractions.Robotics;

// Showcase for AXOpen.Components.Robotics — demonstrates the shared
// utility functions (CalculateDistance, CoordinatesAreNearlyEqual,
// IsNearlyEqual) and the AxoRobot_Status type used by all robotics
// component implementations (ABB, KUKA, Mitsubishi, UR).
NAMESPACE AXOpen.Components.Robotics

    {S7.extern=ReadWrite}
    CLASS RoboticsShowcase EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject : AxoObject;
            _roboticsDoc : RoboticsDoc;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            _roboticsDoc.Run(_rootObject);
        END_METHOD
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC RoboticsDoc EXTENDS AXOpen.Core.AxoObject
        //<RoboticsDeclarations>
        VAR PUBLIC
            _status : AxoRobot_Status;
            _pointA : AxoRoboticsCoordinates;
            _pointB : AxoRoboticsCoordinates;
            _movementParams : AxoRoboticsMovementsParams;
            _distance3D : REAL;
            _distanceXY : REAL;
            _coordsMatch : BOOL;
        END_VAR
        //</RoboticsDeclarations>

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR
            SUPER.Run(inParent);

            //<CoordinateSetup>
            // Define two 6-axis robot positions
            _pointA.X  := REAL#500.0;
            _pointA.Y  := REAL#200.0;
            _pointA.Z  := REAL#100.0;
            _pointA.Rx := REAL#0.0;
            _pointA.Ry := REAL#90.0;
            _pointA.Rz := REAL#0.0;

            _pointB.X  := REAL#510.0;
            _pointB.Y  := REAL#205.0;
            _pointB.Z  := REAL#100.0;
            _pointB.Rx := REAL#0.0;
            _pointB.Ry := REAL#90.0;
            _pointB.Rz := REAL#0.0;
            //</CoordinateSetup>

            //<CalculateDistanceUsage>
            // Full 3D Euclidean distance between two points
            _distance3D := CalculateDistance(
                inDistType := eAxoRoboticsDistance#XYZ,
                inP1       := _pointA,
                inP2       := _pointB);

            // 2D distance in the XY plane only
            _distanceXY := CalculateDistance(
                inDistType := eAxoRoboticsDistance#XY,
                inP1       := _pointA,
                inP2       := _pointB);
            //</CalculateDistanceUsage>

            //<CoordinatesAreNearlyEqualUsage>
            // Check if two positions match within per-axis tolerances
            _coordsMatch := CoordinatesAreNearlyEqual(
                Coordinates1 := _pointA,
                Coordinates2 := _pointB,
                EpsilonX     := REAL#0.05,
                EpsilonY     := REAL#0.05,
                EpsilonZ     := REAL#0.05,
                EpsilonRx    := REAL#0.01,
                EpsilonRy    := REAL#0.01,
                EpsilonRz    := REAL#0.01);
            //</CoordinatesAreNearlyEqualUsage>

            //<MovementParamsSetup>
            // Configure movement parameters for a robot action
            _movementParams.ActionNo    := BYTE#1;
            _movementParams.GlobalSpeed := BYTE#75;
            _movementParams.ToolNo      := BYTE#1;
            _movementParams.WorkobjectNo := BYTE#0;
            _movementParams.PointNo     := BYTE#10;
            _movementParams.UserSpecSpeed1 := INT#500;
            _movementParams.UserSpecSpeed2 := INT#100;
            _movementParams.Coordinates := _pointB;
            //</MovementParamsSetup>
        END_METHOD
    END_CLASS

END_NAMESPACE
