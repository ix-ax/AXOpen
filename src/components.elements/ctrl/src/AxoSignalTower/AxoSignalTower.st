NAMESPACE AXOpen.Components.Elements
    /// <summary>
    /// Represents a light column with multiple color lights.
    /// </summary>
    {S7.extern=ReadWrite}
    CLASS AxoSignalTower 
        EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC
            
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Lights")]}
            {#ix-set:AttributeName = "<#Red Light#>"}
            Red                :   AXOpen.Components.Elements.AxoDo; 
            {#ix-attr:[ComponentDetails("Lights")]}
            {#ix-set:AttributeName = "<#Green Light#>"}
            Green              :   AXOpen.Components.Elements.AxoDo; 
            {#ix-attr:[ComponentDetails("Lights")]}
            {#ix-set:AttributeName = "<#Blue Light#>"}
            Blue               :   AXOpen.Components.Elements.AxoDo; 
            {#ix-attr:[ComponentDetails("Lights")]}
            {#ix-set:AttributeName = "<#Yellow Light#>"}
            Yellow             :   AXOpen.Components.Elements.AxoDo; 

            {#ix-attr:[ComponentDetails("Horn")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Horn#>"}
            Horn               :   AXOpen.Components.Elements.AxoDo;             
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

            THIS.Red.Run    (  inParent := THIS, oSignal    =>  outRed );
            THIS.Green.Run  (  inParent := THIS, oSignal    =>  outGreen );
            THIS.Blue.Run   (  inParent := THIS, oSignal    =>  outBlue );
            THIS.Yellow.Run (  inParent := THIS, oSignal    =>  outYellow );
            THIS.Horn.Run   (  inParent := THIS, oSignal    =>  outHorn );
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