USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Abstractions;
USING Siemens.Simatic.Hardware.Utilities;
USING Siemens.Simatic.MemoryAccess;
USING AXOpen.Timers;

NAMESPACE AXOpen.Components.Cognex.Vision
    {S7.extern=ReadWrite}

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
            InspectionResultTask.Execute(THIS);
            SetRecipeTask.Execute(THIS);  
            SendSpecificDataTask.Execute(THIS);
            ReceiveSpecificDataTask.Execute(THIS);
            TriggerWithSpecificDataTask.Execute(THIS);
            SendSpecificDataAndTypesTask.Execute(THIS);


            //*************RESTORE********************
            RestoreTask.SetIsDisabled(FALSE);
            IF RestoreTask.Execute(THIS) THEN
                THIS.Restore();
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
            Status.Action.Id := UINT#50;
            RestoreTask.DoneWhen(TRUE);

        END_METHOD     
    END_CLASS    
END_NAMESPACE