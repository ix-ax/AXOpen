USING System.Math;

NAMESPACE AXOpen.Components.Robotics
    FUNCTION CalculateDistance : REAL
        VAR_INPUT
            inDistType : AXOpen.Components.Abstractions.Robotics.eAxoRoboticsDistance;
        END_VAR
        VAR_IN_OUT
            inP1 : AXOpen.Components.Abstractions.Robotics.AxoRoboticsCoordinates;
            inP2 : AXOpen.Components.Abstractions.Robotics.AxoRoboticsCoordinates;
        END_VAR
        VAR
            x2 : REAL;
            y2 : REAL;
            z2 : REAL;
        END_VAR
        x2 := (inP1.X-inP2.X);
        x2 := x2 * x2;
        y2 := (inP1.Y-inP2.Y);
        y2 := y2 * y2;
        z2 := (inP1.Z-inP2.Z);
        z2 := z2 * z2;
        CASE inDistType OF
            AXOpen.Components.Abstractions.Robotics.eAxoRoboticsDistance#X:
                CalculateDistance := SQRT(x2);	
            AXOpen.Components.Abstractions.Robotics.eAxoRoboticsDistance#Y:
                CalculateDistance := SQRT(y2);	
            AXOpen.Components.Abstractions.Robotics.eAxoRoboticsDistance#Z:
                CalculateDistance := SQRT(z2);	
            AXOpen.Components.Abstractions.Robotics.eAxoRoboticsDistance#XY:
                CalculateDistance := SQRT(x2+y2);	
            AXOpen.Components.Abstractions.Robotics.eAxoRoboticsDistance#XZ:
                CalculateDistance := SQRT(x2+z2);	
            AXOpen.Components.Abstractions.Robotics.eAxoRoboticsDistance#YZ:
                CalculateDistance := SQRT(y2+z2);	
            AXOpen.Components.Abstractions.Robotics.eAxoRoboticsDistance#XYZ:
                CalculateDistance := SQRT(x2+y2+z2);	
        END_CASE;
    END_FUNCTION
END_NAMESPACE

