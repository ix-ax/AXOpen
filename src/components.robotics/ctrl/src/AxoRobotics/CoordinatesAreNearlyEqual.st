USING System.Math;

NAMESPACE AXOpen.Components.Robotics
    FUNCTION CoordinatesAreNearlyEqual : BOOL
        VAR_INPUT
            Coordinates1 : AXOpen.Components.Abstractions.Robotics.AxoRoboticsCoordinates;
            Coordinates2 : AXOpen.Components.Abstractions.Robotics.AxoRoboticsCoordinates;
            EpsilonX : REAL; 
            EpsilonY : REAL; 
            EpsilonZ : REAL; 
            EpsilonRx : REAL; 
            EpsilonRy : REAL; 
            EpsilonRz : REAL; 
        END_VAR

        CoordinatesAreNearlyEqual :=	IsNearlyEqual(Coordinates1.X,Coordinates2.X,EpsilonX)  AND
                                        IsNearlyEqual(Coordinates1.Y,Coordinates2.Y,EpsilonY)  AND
                                        IsNearlyEqual(Coordinates1.Z,Coordinates2.Z,EpsilonZ)  AND
                                        IsNearlyEqual(Coordinates1.Rx,Coordinates2.Rx,EpsilonRx)  AND
                                        IsNearlyEqual(Coordinates1.Ry,Coordinates2.Ry,EpsilonRy)  AND
                                        IsNearlyEqual(Coordinates1.Rz,Coordinates2.Rz,EpsilonRz);
    END_FUNCTION
END_NAMESPACE

