USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

NAMESPACE AXOpen.Components.Abstractions.Drives
    INTERFACE IAxo_Power EXTENDS AXOpen.Core.IAxoToggleTask
        ///<summary>
        /// Returns `TRUE` if movement to positive direction is enabled
        ///</summary>
        METHOD EnabledPositive : BOOL END_METHOD
        ///<summary>
        /// Returns `TRUE` if movement to positive direction is disabled
        ///</summary>
        METHOD DisabledPositive : BOOL END_METHOD
        ///<summary>
        /// Returns `TRUE` if movement to negative direction is enabled
        ///</summary>
        METHOD EnabledNegative : BOOL END_METHOD
        ///<summary>
        /// Returns `TRUE` if movement to negative direction is disabled
        ///</summary>
        METHOD DisabledNegative : BOOL END_METHOD
    END_INTERFACE  
END_NAMESPACE