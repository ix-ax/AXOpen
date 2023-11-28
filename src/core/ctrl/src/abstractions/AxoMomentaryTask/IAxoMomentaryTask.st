NAMESPACE AXOpen.Core
    INTERFACE IAxoMomentaryTask EXTENDS IAxoObject, IAxoTaskInt
        // ///<summary>
        // /// Use to set the state of the '''AxoMomentaryTask''' to the value '''FALSE'''.
        // ///</summary>        
        // METHOD SwitchOff : BOOL END_METHOD
            
        // ///<summary>
        // /// Use to set the state of the '''AxoMomentaryTask''' to the value '''TRUE'''.
        // ///</summary>        
        // METHOD SwitchOn : BOOL END_METHOD

        ///<summary>
        /// Returns `TRUE` if task is switched on
        ///</summary>
        METHOD IsSwitchedOn : BOOL END_METHOD

        ///<summary>
        /// Returns `TRUE` if task is switched off
        ///</summary>
        METHOD IsSwitchedOff : BOOL END_METHOD                
    END_INTERFACE
END_NAMESPACE    
