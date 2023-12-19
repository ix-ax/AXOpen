
NAMESPACE AXOpen.Components.Festo.Drives
    {S7.extern=ReadWrite}
    CLASS AxoCmmtAsAxisData
        VAR PUBLIC
            MAP_HW_ID   :   WORD;
            Cycle       :   ULINT;
            OverrideVelocityFactor		:	LREAL := 1.0;	//LREAL value to be written
            OverrideAccelerationFactor	:	LREAL := 1.0;	//LREAL value to be written
            OverrideJerkFactor			:	LREAL := 1.0;	//LREAL value to be written
        END_VAR
    END_CLASS
END_NAMESPACE
