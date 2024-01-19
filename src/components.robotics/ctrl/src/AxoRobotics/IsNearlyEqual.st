USING System.Math;

NAMESPACE AXOpen.Components.Robotics
    FUNCTION IsNearlyEqual : BOOL
        VAR_INPUT
            Coordinate1 : REAL;
            Coordinate2 : REAL;
            Epsilon : REAL; 
        END_VAR
        VAR
            AbsCoordinate1 : REAL;
            AbsCoordinate2 : REAL;
            Diff : REAL;
            Denominator : LREAL;
        END_VAR
        IsNearlyEqual := FALSE;
        AbsCoordinate1 := ABS(Coordinate1);
        AbsCoordinate2 := ABS (Coordinate2);
        Diff := ABS(Coordinate1-Coordinate2) ;
        Denominator := AbsCoordinate1;
        Denominator := Denominator + AbsCoordinate2;
        
        IF Epsilon < 0 THEN
            RETURN;
        END_IF;	
            
        IF Coordinate1 = Coordinate2 THEN
            IsNearlyEqual := TRUE;
        ELSIF (Coordinate1 = 0 OR Coordinate2 = 0) AND Diff <= Epsilon THEN 
            IsNearlyEqual := Diff <= Epsilon;
        ELSE
            IsNearlyEqual := Diff / Denominator <= Epsilon;
        END_IF;  
        
    END_FUNCTION
END_NAMESPACE

