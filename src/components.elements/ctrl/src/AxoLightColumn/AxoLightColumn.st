NAMESPACE AXOpen.Components.Elements
    /// <summary>
    /// Represents a light column with multiple color lights.
    /// </summary>
    {S7.extern=ReadWrite}
    CLASS AxoLightColumn 
        EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC
            Red                :   AXOpen.Elements.AxoDo; 
            Green              :   AXOpen.Elements.AxoDo; 
            Blue               :   AXOpen.Elements.AxoDo; 
            Yellow             :   AXOpen.Elements.AxoDo; 
            Horn               :   AXOpen.Elements.AxoDo;             
        END_VAR

        /// <summary>
        /// Runs the light bar logic.
        /// </summary>
        METHOD PUBLIC Run
            VAR_INPUT
                inParent : Axopen.Core.IAxoObject;
            END_VAR

            VAR_OUTPUT
                outRed    : BOOL;
                outGreen  : BOOL;
                outBlue   : BOOL;
                outYellow : BOOL;
                outHorn   : BOOL;
            END_VAR

            IF (inParent = NULL) THEN 
                RETURN; 
            END_IF;

            SUPER.Run(inParent);

            THIS.Red.Run    (  parent := THIS, oSignal    =>  outRed );
            THIS.Green.Run  (  parent := THIS, oSignal    =>  outGreen );
            THIS.Blue.Run   (  parent := THIS, oSignal    =>  outBlue );
            THIS.Yellow.Run (  parent := THIS, oSignal    =>  outYellow );
            THIS.Horn.Run   (  parent := THIS, oSignal    =>  outHorn );
        END_METHOD
    
        /// <summary>
        /// Restores the state of the light bar.
        /// </summary>
        METHOD PUBLIC OVERRIDE Restore
            THIS.Red.Restore();
            THIS.Green.Restore(); 
            THIS.Blue.Restore(); 
            THIS.Yellow.Restore();
            THIS.Horn.Restore();  
        END_METHOD
    
        /// <summary>
        /// Activates manual control for the light bar.
        /// </summary>
        METHOD PROTECTED OVERRIDE ManualControl
            THIS.Red.ActivateManualControl();
            THIS.Green.ActivateManualControl();
            THIS.Blue.ActivateManualControl();
            THIS.Yellow.ActivateManualControl();
            THIS.Horn.ActivateManualControl();
        END_METHOD
    END_CLASS

END_NAMESPACE