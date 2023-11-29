USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

NAMESPACE AXOpen.Components.Drives
    {S7.extern=ReadWrite}
    CLASS PUBLIC Axo_Power EXTENDS AXOpen.Core.AxoToggleTask IMPLEMENTS AXOpen.Components.Abstractions.Drives.IAxo_Power
        VAR PRIVATE 
            _motionTaskId    :  AXOpen.Components.Drives.eAxoMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Power;      
            _EnablePositive  :  AXOpen.Core.AxoToggleTask;
            _EnableNegative  :  AXOpen.Core.AxoToggleTask;
            _manualOverride  :  BOOL;
        END_VAR

        ///<summary>
        /// Runs the logic of this tasks.
        /// >[!IMPORTANT] This method must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run 
            VAR_INPUT
                Enable          :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
                EnablePositive  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in positive direction
                EnableNegative  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in negative direction
            END_VAR

            SUPER.Run();

            // Enables manually switch off and switch on the power in case of enable is 'TRUE'
            IF _manualOverride THEN
                SUPER.SetIsDisabled(NOT Enable);
            ELSE
                SUPER.SetIsDisabled(FALSE);
                IF Enable THEN
                    SUPER.SwitchOn();
                ELSE
                    SUPER.SwitchOff();
                END_IF;
            END_IF;

            _EnablePositive.Initialize(THIS);
            _EnablePositive.Run();
            _EnablePositive.SetIsDisabled(SUPER.IsSwitchedOn());
            IF EnablePositive THEN
                _EnablePositive.SwitchOn();
            ELSE
                _EnablePositive.SwitchOff();
            END_IF;

            _EnableNegative.Initialize(THIS);
            _EnableNegative.Run();
            _EnableNegative.SetIsDisabled(SUPER.IsSwitchedOn());
            IF EnableNegative THEN
                _EnableNegative.SwitchOn();
            ELSE
                _EnableNegative.SwitchOff();
            END_IF;

            _manualOverride := FALSE;
        END_METHOD

        ///<summary>
        /// Returns `TRUE` if movement to positive direction is enabled
        ///</summary>
        METHOD PUBLIC EnabledPositive : BOOL
            EnabledPositive := _EnablePositive.IsSwitchedOn();
        END_METHOD
        ///<summary>
        /// Returns `TRUE` if movement to positive direction is disabled
        ///</summary>
        METHOD PUBLIC DisabledPositive : BOOL
            DisabledPositive := _EnablePositive.IsSwitchedOff();
        END_METHOD
        ///<summary>
        /// Returns `TRUE` if movement to negative direction is enabled
        ///</summary>
        METHOD PUBLIC EnabledNegative : BOOL
            EnabledNegative := _EnableNegative.IsSwitchedOn();
        END_METHOD
        ///<summary>
        /// Returns `TRUE` if movement to negative direction is disabled
        ///</summary>
        METHOD PUBLIC DisabledNegative : BOOL
            DisabledNegative := _EnableNegative.IsSwitchedOff();
        END_METHOD

        METHOD PUBLIC Manual
            _manualOverride := TRUE;
        END_METHOD
    END_CLASS    
END_NAMESPACE
