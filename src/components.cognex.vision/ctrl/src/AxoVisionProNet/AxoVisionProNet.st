USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Abstractions;
USING Siemens.Simatic.Hardware.Utilities;
USING Siemens.Simatic.MemoryAccess;
USING AXOpen.Timers;

NAMESPACE AXOpen.Components.Cognex.Vision
      {S7.extern=ReadWrite}
        {#ix-prop: public string DeviceIpAddress}
        {#ix-prop: public string Proxy}
        CLASS AxoVisionProNet EXTENDS AXOpen.Core.AxoComponent

        VAR PUBLIC // TASKS
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Trigger#>"}
            TriggerTask : AXOpen.Core.AxoRemoteTask;
  
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#InspectionResult#>"}
            InspectionResultTask : AXOpen.Core.AxoRemoteTask;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#SetRecipe#>"}
            SetRecipeTask : AXOpen.Core.AxoRemoteTask;
      
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#SendSpecificData#>"}
            SendSpecificDataTask : AXOpen.Core.AxoRemoteTask;


         

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#ReceiveSpecificData#>"}
            ReceiveSpecificDataTask : AXOpen.Core.AxoRemoteTask;

             {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#TriggerWithSpecificData#>"}
            TriggerWithSpecificDataTask : AXOpen.Core.AxoRemoteTask;


            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#SendSpecificDataAndTypes#>"}
            SendSpecificDataAndTypesTask : AXOpen.Core.AxoRemoteTask;
       
        END_VAR
        
        VAR PUBLIC // CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config  :   AxoVisionProNet_Config;
        END_VAR

         VAR PUBLIC // CONTROL
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Control")]}
            Control  :   AxoVisionProNet_Control;
        END_VAR

        VAR PUBLIC // STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            Status              :   AxoVisionProNet_Component_Status;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR    

     

        VAR PRIVATE
            _progress       :   INT;
            _infoTimer      :   AXOpen.Timers.OnDelayTimer;
            _errorTimer     :   AXOpen.Timers.OnDelayTimer;
  
        END_VAR

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC OVERRIDE  Run
            VAR_INPUT
                inParent      :   IAxoObject;
               
            END_VAR
            VAR_OUTPUT
            
            END_VAR
            

            SUPER.Run(inParent);

            Messenger.Serve(THIS);

            RestoreTask.Run(THIS);


            TriggerTask.Execute(THIS);
            if TriggerTask.HasRemoteException and not TriggerTask.IsBusy() then
                Status.ErrorDescription := TriggerTask.ErrorDetails;
            END_IF;
            InspectionResultTask.Execute(THIS);
             if InspectionResultTask.HasRemoteException and not InspectionResultTask.IsBusy() then
                Status.ErrorDescription := InspectionResultTask.ErrorDetails;
            END_IF;
            SetRecipeTask.Execute(THIS);  
             if SetRecipeTask.HasRemoteException and not SetRecipeTask.IsBusy() then
                Status.ErrorDescription := SetRecipeTask.ErrorDetails;
            END_IF;
                SendSpecificDataTask.Execute(THIS); if SendSpecificDataTask.HasRemoteException and not SendSpecificDataTask.IsBusy() then
                Status.ErrorDescription := SendSpecificDataTask.ErrorDetails;
            END_IF;
            ReceiveSpecificDataTask.Execute(THIS);
            if ReceiveSpecificDataTask.HasRemoteException and not ReceiveSpecificDataTask.IsBusy() then
                Status.ErrorDescription := ReceiveSpecificDataTask.ErrorDetails;
            END_IF;
            TriggerWithSpecificDataTask.SetIsDisabled(TriggerTask.IsBusy() OR SendSpecificDataTask.IsBusy() OR SetRecipeTask.IsBusy());
            TriggerWithSpecificDataTask.Execute(THIS);
            IF TriggerWithSpecificDataTask.HasRemoteException and not TriggerWithSpecificDataTask.IsBusy() then
                Status.ErrorDescription := TriggerWithSpecificDataTask.ErrorDetails;
            END_IF;
            SendSpecificDataAndTypesTask.SetIsDisabled(not THIS.IsManuallyControllable()); // This task is only for commissioning purposes, so it can only be executed in manual mode.
            SendSpecificDataAndTypesTask.Execute(THIS);
            IF SendSpecificDataAndTypesTask.HasRemoteException and not SendSpecificDataAndTypesTask.IsBusy() then
                Status.ErrorDescription := SendSpecificDataAndTypesTask.ErrorDetails;   
            END_IF;


            //*************RESTORE********************
            RestoreTask.SetIsDisabled(FALSE);
            IF RestoreTask.Execute(THIS) THEN
                THIS.Restore();
                Status.ActionDescription := '<#Component restored#>';
            END_IF;
            //****************************************
    



        END_METHOD

        METHOD PUBLIC Trigger : IAxoTaskState
            Trigger := TriggerTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC InspectionResult : IAxoTaskState
            InspectionResult := InspectionResultTask.Invoke(THIS);
        END_METHOD
        
        METHOD PUBLIC SetRecipe : IAxoTaskState
            SetRecipe := SetRecipeTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC SendSpecificData : IAxoTaskState
            SendSpecificData := SendSpecificDataTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC ReceiveSpecificData : IAxoTaskState
            ReceiveSpecificData := ReceiveSpecificDataTask.Invoke(THIS);  
        END_METHOD
        METHOD PUBLIC TriggerWithSpecificData : IAxoTaskState
            TriggerWithSpecificData := TriggerWithSpecificDataTask.Invoke(THIS);
        END_METHOD
        METHOD PUBLIC SendSpecificDataAndTypes : IAxoTaskState
            SendSpecificDataAndTypes := SendSpecificDataAndTypesTask.Invoke(THIS);
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            THIS._isManuallyControllable := TRUE;

         
        END_METHOD
          METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal AND Config.InfoTime > LT#0S ,Config.InfoTime);
            _errorTimer.OnDelay(THIS, signal AND Config.ErrorTime > LT#0S , Config.ErrorTime);
        END_METHOD

        ///<summary>
        /// Restores this component into intial state.        
        ///</summary>
        METHOD PUBLIC OVERRIDE Restore
            VAR
                _index : INT;
            END_VAR
         

 
            TriggerTask.Restore();
            SetRecipeTask.Restore();
            SendSpecificDataTask.Restore();
            SendSpecificDataAndTypesTask.Restore();
            InspectionResultTask.Restore();
            ReceiveSpecificDataTask.Restore();
            TriggerWithSpecificDataTask.Restore();
            Status.ActionDescription := '';
            Status.ErrorDescription  := '';
            Status.Accepted := FALSE;
            Status.ErrorCode := 0;
            Status.RejectReason := '';
            RestoreTask.DoneWhen(TRUE);

        END_METHOD     
    END_CLASS    
END_NAMESPACE