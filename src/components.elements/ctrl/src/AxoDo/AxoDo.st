USING AXOpen.Core;
NAMESPACE AXOpen.Components.Elements

    /// <summary>
    /// Class representing Digital output
    /// </summary>
    {S7.extern=ReadWrite}
    CLASS AxoDo EXTENDS AXOpen.Core.AxoComponent

        VAR PUBLIC
            
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Signal#>"}
            _signal : BOOL;

            {#ix-set:AttributeName = "<#On#>"}
            {#ix-attr:[ComponentHeader()]}
            _setTask : AxoTask;
            
            {#ix-set:AttributeName = "<#Off#>"}
            {#ix-attr:[ComponentHeader()]}
            _resetTask : AxoTask;
            
            {#ix-set:AttributeName = "<#MessengerInfo#>"}
            {#ix-set:PlcTextList = "[1]:'<#Expecting positive signal.#>':'<#Check your signal input.#>';[2]:'<#Expecting negative signal.#>':'<#Check your signal input.#>'"}
            _messengerInfo : AXOpen.Messaging.Static.AxoMessenger;
            
           
        END_VAR

        VAR PRIVATE
            _context : IAxoContext;
        END_VAR

        METHOD PUBLIC OVERRIDE Restore 
            _setTask.Restore();
            _resetTask.Restore();
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            THIS._isManuallyControllable := true;

        END_METHOD

        /// <summary>
        /// Method, which sets or reset input/output value
        /// </summary>
        METHOD PUBLIC Run
            VAR_INPUT
                inParent : Axopen.Core.IAxoObject;
            END_VAR

            VAR_OUTPUT
                oSignal: BOOL;
            END_VAR

            IF (inParent = NULL) THEN 
                RETURN;
            END_IF;

           
            SUPER.Run(inParent);
            _setTask.Run(THIS);
            _resetTask.Run(THIS);
           
            _messengerInfo.Serve(THIS); 

            oSignal := _signal;		

            IF(_setTask.Execute(THIS))THEN
                _setTask.DoneWhen(THIS.Set());
            END_IF;
            
            IF(_resetTask.Execute(THIS))THEN
                _resetTask.DoneWhen(THIS.Reset());
            END_IF;
        END_METHOD

        METHOD PUBLIC Set : BOOL
            _signal := TRUE;
            Set := TRUE;
        END_METHOD

        METHOD PUBLIC Reset: BOOL
            _signal := FALSE;
            Reset := TRUE;
        END_METHOD

        METHOD PUBLIC IsTrue : BOOL
            IsTrue := _signal;
            _messengerInfo.ActivateOnCondition(UINT#1,IsTrue,AXOpen.Messaging.eAxoMessageCategory#Warning);
        END_METHOD

        METHOD PUBLIC IsFalse : BOOL
            IsFalse := NOT _signal;
            _messengerInfo.ActivateOnCondition(UINT#2,IsFalse,AXOpen.Messaging.eAxoMessageCategory#Warning);
        END_METHOD
    END_CLASS
END_NAMESPACE
