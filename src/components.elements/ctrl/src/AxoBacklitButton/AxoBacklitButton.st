NAMESPACE AXOpen.Components.Elements
    /// <summary>
    /// Button with LED indicator component.
    /// </summary>
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoBacklitButton 
        EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Button")]}
            {#ix-set:AttributeName = "<#Button Signal#>"} 
            Button             :   AXOpen.Elements.AxoDi;            
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Led")]}
            {#ix-set:AttributeName = "<#LED Indicator#>"} 
            Led                :   AXOpen.Elements.AxoDo;             
        END_VAR

        /// <summary>
        /// Runs the button with the given input signal and output LED signal.
        /// </summary>
        /// <param name="inParent">The parent object.</param>
        /// <param name="inSignal">The input signal.</param>
        /// <param name="oLed">The output LED signal.</param>
        METHOD PUBLIC Run
            VAR_INPUT
                inParent : Axopen.Core.IAxoObject;
                inSignal: BOOL;
            END_VAR

            VAR_OUTPUT
                outLed : BOOL;
            END_VAR

            IF (inParent = NULL) THEN 
                RETURN; 
            END_IF;

            SUPER.Run(inParent);
            THIS.Button.Run(  parent := THIS, inSignal    :=  inSignal );
            THIS.Led.Run(  parent := THIS, oSignal    =>  outLed );
        END_METHOD

        /// <summary>
        /// Restores the button and LED states.
        /// </summary>
        METHOD PUBLIC OVERRIDE Restore
            THIS.Button.Restore();
            THIS.Led.Restore();
        END_METHOD

        /// <summary>
        /// Activates manual control for the button and LED.
        /// </summary>
        METHOD PROTECTED OVERRIDE ManualControl
            THIS.Button.ActivateManualControl();
            THIS.Led.ActivateManualControl();
        END_METHOD
    END_CLASS
END_NAMESPACE