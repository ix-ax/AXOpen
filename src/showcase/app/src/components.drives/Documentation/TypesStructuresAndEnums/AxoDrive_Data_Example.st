NAMESPACE AXOpen.Components.Drives
    {S7.extern=ReadWrite}
    CLASS AxoDrive_Data_Example
        VAR PUBLIC
            Cycle                       :   ULINT;
            OverrideVelocityFactor		:	LREAL := 1.0;	//LREAL value to be written
            OverrideAccelerationFactor	:	LREAL := 1.0;	//LREAL value to be written
            OverrideJerkFactor			:	LREAL := 1.0;	//LREAL value to be written
        END_VAR
    END_CLASS
END_NAMESPACE
