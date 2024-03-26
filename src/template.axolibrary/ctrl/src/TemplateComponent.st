USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;


NAMESPACE Template.Axolibrary
    {S7.extern=ReadWrite}
    CLASS TemplateComponent EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC // HEADER
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Move to work#>"}
            MoveToWorkTask : AxoTask;            

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}            
            {#ix-set:AttributeName = "<#Move to home#>"}
            MoveToHomeTask : AxoTask;
        END_VAR

        VAR PUBLIC // TASKS
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Stop#>"}
            StopTask : AXOpen.Core.AxoTask;
        END_VAR

        VAR PUBLIC // TEMPLATE TASKS
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_10steps_1#>"}
            TemplateTask_10steps_1 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_10steps_2#>"}
            TemplateTask_10steps_2 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_10steps_3#>"}
            TemplateTask_10steps_3 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_10steps_4#>"}
            TemplateTask_10steps_4 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_10steps_5#>"}
            TemplateTask_10steps_5 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_20steps_1#>"}
            TemplateTask_20steps_1 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_20steps_2#>"}
            TemplateTask_20steps_2 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_20steps_3#>"}
            TemplateTask_20steps_3 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_20steps_4#>"}
            TemplateTask_20steps_4 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_20steps_5#>"}
            TemplateTask_20steps_5 : AXOpen.Core.AxoTask;
            
        END_VAR
        
        VAR PUBLIC // CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config  :   TemplateComponent_Config;
        END_VAR

        VAR PUBLIC // STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status     :   TemplateComponent_ComponentStatus;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR    

        VAR PUBLIC // HARDWARE SIGNALS
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            {#ix-attr:[ReadOnly()]}
            Inputs              :  TemplateComponent_In;
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   TemplateComponent_Out;
        END_VAR    

        VAR PUBLIC // HARDWARE DIAGNOSTICS TASK
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Hardware diagnostics")]}
            {#ix-set:AttributeName = "<#Update diagnostics#>"}
            HardwareDiagnosticsTask :   AXOpen.Io.AxoHardwareDiagnostics;
        END_VAR

        VAR PRIVATE
            _hwId   :   WORD;
            _progress          :   INT;
            _infoTimer :  AXOpen.Timers.OnDelayTimer;
            _errorTimer :  AXOpen.Timers.OnDelayTimer;
        END_VAR

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent : IAxoObject;
                hwID :   WORD;
                homeSensor : REF_TO BOOL;
                workSensor : REF_TO BOOL;    
                moveHomeSignal : REF_TO BOOL;
                moveWorkSignal : REF_TO BOOL;
            END_VAR

            THIS.Open();

            Messenger.Serve(THIS);
            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701,hwID = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#702,homeSensor = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#703,workSensor = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#704,moveHomeSignal = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#705,moveWorkSignal = NULL, eAxoMessageCategory#ProgrammingError);
            
            IF parent = NULL THEN
                Status.Error.Id := UINT#700;
                RETURN;
            ELSIF hwID = WORD#0 THEN
                Status.Error.Id := UINT#701;
                RETURN;                
            ELSIF homeSensor = NULL THEN
                Status.Error.Id := UINT#702;
                RETURN;
            ELSIF workSensor = NULL THEN
                Status.Error.Id := UINT#703;
                RETURN;
            ELSIF moveHomeSignal = NULL THEN
                Status.Error.Id := UINT#704;
                RETURN;
            ELSIF moveWorkSignal = NULL THEN
                Status.Error.Id := UINT#705;
                RETURN;
            END_IF;

            THIS.Initialize(parent);

            Inputs.Status.HomeSensor := homeSensor^;
            Inputs.Status.WorkSensor := workSensor^;
            _hwId := hwID;

            THIS.Execute();

            moveHomeSignal^  :=  Outputs.Control.MoveHomeSignal;
            moveWorkSignal^  :=  Outputs.Control.MoveWorkSignal;

            THIS.Close();

        END_METHOD


        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run 
            VAR_INPUT
                parent : IAxoContext;
                hwID :   WORD;
                homeSensor : REF_TO BOOL;
                workSensor : REF_TO BOOL;    
                moveHomeSignal : REF_TO BOOL;
                moveWorkSignal : REF_TO BOOL;
            END_VAR

            THIS.Open();

            Messenger.Serve(THIS);
            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701,hwID = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#702,homeSensor = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#703,workSensor = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#704,moveHomeSignal = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#705,moveWorkSignal = NULL, eAxoMessageCategory#ProgrammingError);
            
            IF parent = NULL THEN
                Status.Error.Id := UINT#700;
                RETURN;
            ELSIF hwID = WORD#0 THEN
                Status.Error.Id := UINT#701;
                RETURN;                
            ELSIF homeSensor = NULL THEN
                Status.Error.Id := UINT#702;
                RETURN;
            ELSIF workSensor = NULL THEN
                Status.Error.Id := UINT#703;
                RETURN;
            ELSIF moveHomeSignal = NULL THEN
                Status.Error.Id := UINT#704;
                RETURN;
            ELSIF moveWorkSignal = NULL THEN
                Status.Error.Id := UINT#705;
                RETURN;
            END_IF;

            THIS.Initialize(parent);

            Inputs.Status.HomeSensor := homeSensor^;
            Inputs.Status.WorkSensor := workSensor^;
            _hwId := hwID;

            THIS.Execute();

            moveHomeSignal^  :=  Outputs.Control.MoveHomeSignal;
            moveWorkSignal^  :=  Outputs.Control.MoveWorkSignal;

            THIS.Close();

        END_METHOD

        METHOD PRIVATE Execute 

            //*************INITIALIZATION*************
            RestoreTask.Initialize(THIS);
            MoveToWorkTask.Initialize(THIS);
            MoveToHomeTask.Initialize(THIS);
            StopTask.Initialize(THIS);
            HardwareDiagnosticsTask.Initialize(THIS);

            TemplateTask_10steps_1.Initialize(THIS);
            TemplateTask_10steps_2.Initialize(THIS);
            TemplateTask_10steps_3.Initialize(THIS);
            TemplateTask_10steps_4.Initialize(THIS);
            TemplateTask_10steps_5.Initialize(THIS);
            TemplateTask_20steps_1.Initialize(THIS);
            TemplateTask_20steps_2.Initialize(THIS);
            TemplateTask_20steps_3.Initialize(THIS);
            TemplateTask_20steps_4.Initialize(THIS);
            TemplateTask_20steps_5.Initialize(THIS);

            //****************************************

            //********************Diagnostics*********        
            HardwareDiagnosticsTask.Run(_hwID);
            //****************************************

            //*************RESTORE********************
            RestoreTask.IsDisabled := FALSE;
            IF RestoreTask.Execute() THEN
                THIS.Restore();
            END_IF;
            //****************************************
            

            //*************StopTask*******************
            StopTask.SetIsDisabled(FALSE);
            IF StopTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#100,StopTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,StopTask.IsDone(), eAxoMessageCategory#Info);
            IF StopTask.Execute() THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;

                IF _progress = 300 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#500, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#500;
                    END_IF;

                    MoveToWorkTask.Restore();
                    MoveToHomeTask.Restore();

                    IF TRUE THEN
                        _progress := 301;
                    END_IF;
                END_IF;

                IF _progress = 301 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#501, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#501;
                    END_IF;

                    Outputs.Control.MoveWorkSignal := FALSE;
                    Outputs.Control.MoveHomeSignal := FALSE;

                    IF TRUE THEN
                        _progress := 302;
                    END_IF;
                END_IF;
                
                IF _progress = 302 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#502, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#502;
                    END_IF;

                    IF TRUE THEN
                        _progress := 303;
                    END_IF;
                END_IF;
                
                IF _progress = 303 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#503, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#503;
                    END_IF;

                    IF TRUE THEN
                        _progress := 304;
                    END_IF;
                END_IF;
                
                IF _progress = 304 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#504, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#504;
                    END_IF;

                    IF TRUE THEN
                        _progress := 305;
                    END_IF;
                END_IF;
                
                IF _progress = 305 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#505, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#505;
                    END_IF;

                    IF TRUE THEN
                        _progress := 306;
                    END_IF;
                END_IF;
                
                IF _progress = 306 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#506, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#506;
                    END_IF;

                    IF TRUE THEN
                        _progress := 307;
                    END_IF;
                END_IF;
                
                IF _progress = 307 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#507, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#507;
                    END_IF;

                    IF TRUE THEN
                        _progress := 308;
                    END_IF;
                END_IF;
                
                IF _progress = 308 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#508, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#508;
                    END_IF;

                    IF TRUE THEN
                        _progress := 309;
                    END_IF;
                END_IF;
                
                IF _progress = 309 THEN
                    StopTask.DoneWhen(TRUE);
                END_IF;

                THIS.CallTimers(TRUE);
                
                StopTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                StopTask.ThrowWhen(StopTask.Duration >= Config.ErrorTime ,'Unable to stop.');
            END_IF;
            IF StopTask.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF StopTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#800;
                Status.Error.Id  :=  UINT#800;
            ELSIF StopTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#801;
                Status.Error.Id  :=  UINT#801;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#800,StopTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#801,StopTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,StopTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StopTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 309  THEN
                Status.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            //******************************************

            //*************MoveToHomeTask***************
            MoveToHomeTask.SetIsDisabled(FALSE);
            IF MoveToHomeTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#110;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#110,MoveToHomeTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,MoveToHomeTask.IsDone(), eAxoMessageCategory#Info);
            IF MoveToHomeTask.Execute() THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 310;
                END_IF;

                IF _progress = 310 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#510, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#510;
                    END_IF;

                    MoveToWorkTask.Restore();

                    IF TRUE THEN
                        _progress := 311;
                    END_IF;
                END_IF;

                IF _progress = 311 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#511, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#511;
                    END_IF;

                    Outputs.Control.MoveWorkSignal := FALSE;
                    Outputs.Control.MoveHomeSignal := TRUE;

                    IF Inputs.Status.HomeSensor THEN
                        _progress := 312;
                    END_IF;
                END_IF;
                
                IF _progress = 312 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#512, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#512;
                    END_IF;

                    IF TRUE THEN
                        _progress := 313;
                    END_IF;
                END_IF;
                
                IF _progress = 313 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#513, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#513;
                    END_IF;

                    IF TRUE THEN
                        _progress := 314;
                    END_IF;
                END_IF;
                
                IF _progress = 314 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#514, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#514;
                    END_IF;

                    IF TRUE THEN
                        _progress := 315;
                    END_IF;
                END_IF;
                
                IF _progress = 315 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#515, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#515;
                    END_IF;

                    IF TRUE THEN
                        _progress := 316;
                    END_IF;
                END_IF;
                
                IF _progress = 316 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#516, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#516;
                    END_IF;

                    IF TRUE THEN
                        _progress := 317;
                    END_IF;
                END_IF;
                
                IF _progress = 317 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#517, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#517;
                    END_IF;

                    IF TRUE THEN
                        _progress := 318;
                    END_IF;
                END_IF;
                
                IF _progress = 318 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#518, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#518;
                    END_IF;

                    IF TRUE THEN
                        _progress := 319;
                    END_IF;
                END_IF;
                
                IF _progress = 319 THEN
                    MoveToHomeTask.DoneWhen(TRUE);
                END_IF;

                THIS.CallTimers(TRUE);
                
                MoveToHomeTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                MoveToHomeTask.ThrowWhen(StopTask.Duration >= Config.ErrorTime ,'Unable to move home.');
            END_IF;
            IF MoveToHomeTask.DoneReached() THEN
                Status.Action.Id :=  UINT#111;
                Status.Error.Id :=  UINT#0;
            ELSIF MoveToHomeTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#810;
                Status.Error.Id  :=  UINT#810;
            ELSIF MoveToHomeTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#811;
                Status.Error.Id  :=  UINT#811;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#810,MoveToHomeTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#811,MoveToHomeTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#112,MoveToHomeTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF MoveToHomeTask.RestoreTriggered() AND _progress >= 310 AND _progress <= 319  THEN
                Status.Action.Id :=  UINT#112;
                _progress := 0;
            END_IF;
            //******************************************

            //*************MoveToWorkTask***************
            MoveToWorkTask.SetIsDisabled(FALSE);
            IF MoveToWorkTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#120;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#120,MoveToWorkTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#121,MoveToWorkTask.IsDone(), eAxoMessageCategory#Info);
            IF MoveToWorkTask.Execute() THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 320;
                END_IF;

                IF _progress = 320 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#520, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#520;
                    END_IF;

                    MoveToHomeTask.Restore();

                    IF TRUE THEN
                        _progress := 321;
                    END_IF;
                END_IF;

                IF _progress = 321 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#521, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#521;
                    END_IF;

                    Outputs.Control.MoveHomeSignal := FALSE;
                    Outputs.Control.MoveWorkSignal := TRUE;

                    IF Inputs.Status.WorkSensor THEN
                        _progress := 322;
                    END_IF;
                END_IF;
                
                IF _progress = 322 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#522, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#522;
                    END_IF;

                    IF TRUE THEN
                        _progress := 323;
                    END_IF;
                END_IF;
                
                IF _progress = 323 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#523, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#523;
                    END_IF;

                    IF TRUE THEN
                        _progress := 324;
                    END_IF;
                END_IF;
                
                IF _progress = 324 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#524, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#524;
                    END_IF;

                    IF TRUE THEN
                        _progress := 325;
                    END_IF;
                END_IF;
                
                IF _progress = 325 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#525, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#525;
                    END_IF;

                    IF TRUE THEN
                        _progress := 326;
                    END_IF;
                END_IF;
                
                IF _progress = 326 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#526, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#526;
                    END_IF;

                    IF TRUE THEN
                        _progress := 327;
                    END_IF;
                END_IF;
                
                IF _progress = 327 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#527, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#527;
                    END_IF;

                    IF TRUE THEN
                        _progress := 328;
                    END_IF;
                END_IF;
                
                IF _progress = 328 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#528, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#528;
                    END_IF;

                    IF TRUE THEN
                        _progress := 329;
                    END_IF;
                END_IF;
                
                IF _progress = 329 THEN
                    MoveToWorkTask.DoneWhen(TRUE);
                END_IF;

                THIS.CallTimers(TRUE);
                
                MoveToWorkTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                MoveToWorkTask.ThrowWhen(StopTask.Duration >= Config.ErrorTime ,'Unable to move work.');
            END_IF;
            IF MoveToWorkTask.DoneReached() THEN
                Status.Action.Id :=  UINT#121;
                Status.Error.Id :=  UINT#0;
            ELSIF MoveToWorkTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#820;
                Status.Error.Id  :=  UINT#820;
            ELSIF MoveToWorkTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#821;
                Status.Error.Id  :=  UINT#821;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#820,MoveToWorkTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#821,MoveToWorkTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#122,MoveToWorkTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF MoveToWorkTask.RestoreTriggered() AND _progress >= 320 AND _progress <= 329  THEN
                Status.Action.Id :=  UINT#122;
                _progress := 0;
            END_IF;
            //******************************************

            //*************TemplateTask_10steps_1***************
            TemplateTask_10steps_1.SetIsDisabled(FALSE);
            IF TemplateTask_10steps_1.StartTriggered() THEN
                Status.Action.Id :=  UINT#130;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#130,TemplateTask_10steps_1.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#131,TemplateTask_10steps_1.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_10steps_1.Execute() THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 330;
                END_IF;

                IF _progress = 330 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#530, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#530;
                    END_IF;

                    IF TRUE THEN
                        _progress := 331;
                    END_IF;
                END_IF;

                IF _progress = 331 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#531, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#531;
                    END_IF;

                    IF Inputs.Status.WorkSensor THEN
                        _progress := 332;
                    END_IF;
                END_IF;
                
                IF _progress = 332 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#532, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#532;
                    END_IF;

                    IF TRUE THEN
                        _progress := 333;
                    END_IF;
                END_IF;
                
                IF _progress = 333 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#533, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#533;
                    END_IF;

                    IF TRUE THEN
                        _progress := 334;
                    END_IF;
                END_IF;
                
                IF _progress = 334 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#534, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#534;
                    END_IF;

                    IF TRUE THEN
                        _progress := 335;
                    END_IF;
                END_IF;
                
                IF _progress = 335 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#535, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#535;
                    END_IF;

                    IF TRUE THEN
                        _progress := 336;
                    END_IF;
                END_IF;
                
                IF _progress = 336 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#536, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#536;
                    END_IF;

                    IF TRUE THEN
                        _progress := 337;
                    END_IF;
                END_IF;
                
                IF _progress = 337 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#537, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#537;
                    END_IF;

                    IF TRUE THEN
                        _progress := 338;
                    END_IF;
                END_IF;
                
                IF _progress = 338 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#538, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#538;
                    END_IF;

                    IF TRUE THEN
                        _progress := 339;
                    END_IF;
                END_IF;
                
                IF _progress = 339 THEN
                    TemplateTask_10steps_1.DoneWhen(TRUE);
                END_IF;

                THIS.CallTimers(TRUE);
                
                TemplateTask_10steps_1.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_10steps_1.ThrowWhen(StopTask.Duration >= Config.ErrorTime ,'xxxxxxxx');
            END_IF;
            IF TemplateTask_10steps_1.DoneReached() THEN
                Status.Action.Id :=  UINT#131;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_10steps_1.ErrorOccured() THEN
                Status.Action.Id :=  UINT#830;
                Status.Error.Id  :=  UINT#830;
            ELSIF TemplateTask_10steps_1.AbortTriggered()THEN
                Status.Action.Id :=  UINT#831;
                Status.Error.Id  :=  UINT#831;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#830,TemplateTask_10steps_1.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#831,TemplateTask_10steps_1.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#132,TemplateTask_10steps_1.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_10steps_1.RestoreTriggered() AND _progress >= 330 AND _progress <= 339  THEN
                Status.Action.Id :=  UINT#132;
                _progress := 0;
            END_IF;
            //******************************************

            //*************TemplateTask_10steps_2***************
            TemplateTask_10steps_2.SetIsDisabled(FALSE);
            IF TemplateTask_10steps_2.StartTriggered() THEN
                Status.Action.Id :=  UINT#140;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#140,TemplateTask_10steps_2.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#141,TemplateTask_10steps_2.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_10steps_2.Execute() THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 340;
                END_IF;

                IF _progress = 340 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#540, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#540;
                    END_IF;

                    IF TRUE THEN
                        _progress := 341;
                    END_IF;
                END_IF;

                IF _progress = 341 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#541, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#541;
                    END_IF;

                    IF Inputs.Status.WorkSensor THEN
                        _progress := 342;
                    END_IF;
                END_IF;
                
                IF _progress = 342 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#542, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#542;
                    END_IF;

                    IF TRUE THEN
                        _progress := 343;
                    END_IF;
                END_IF;
                
                IF _progress = 343 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#544, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#544;
                    END_IF;

                    IF TRUE THEN
                        _progress := 344;
                    END_IF;
                END_IF;
                
                IF _progress = 344 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#544, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#544;
                    END_IF;

                    IF TRUE THEN
                        _progress := 345;
                    END_IF;
                END_IF;
                
                IF _progress = 345 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#545, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#545;
                    END_IF;

                    IF TRUE THEN
                        _progress := 346;
                    END_IF;
                END_IF;
                
                IF _progress = 346 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#546, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#546;
                    END_IF;

                    IF TRUE THEN
                        _progress := 347;
                    END_IF;
                END_IF;
                
                IF _progress = 347 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#547, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#547;
                    END_IF;

                    IF TRUE THEN
                        _progress := 348;
                    END_IF;
                END_IF;
                
                IF _progress = 348 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#548, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#548;
                    END_IF;

                    IF TRUE THEN
                        _progress := 349;
                    END_IF;
                END_IF;
                
                IF _progress = 349 THEN
                    TemplateTask_10steps_2.DoneWhen(TRUE);
                END_IF;

                THIS.CallTimers(TRUE);
                
                TemplateTask_10steps_2.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_10steps_2.ThrowWhen(StopTask.Duration >= Config.ErrorTime ,'xxxxxxxx');
            END_IF;
            IF TemplateTask_10steps_2.DoneReached() THEN
                Status.Action.Id :=  UINT#141;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_10steps_2.ErrorOccured() THEN
                Status.Action.Id :=  UINT#840;
                Status.Error.Id  :=  UINT#840;
            ELSIF TemplateTask_10steps_2.AbortTriggered()THEN
                Status.Action.Id :=  UINT#841;
                Status.Error.Id  :=  UINT#841;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#840,TemplateTask_10steps_2.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#841,TemplateTask_10steps_2.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#142,TemplateTask_10steps_2.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_10steps_2.RestoreTriggered() AND _progress >= 340 AND _progress <= 349  THEN
                Status.Action.Id :=  UINT#142;
                _progress := 0;
            END_IF;
            //******************************************

            //*************TemplateTask_10steps_3***************
            TemplateTask_10steps_3.SetIsDisabled(FALSE);
            IF TemplateTask_10steps_3.StartTriggered() THEN
                Status.Action.Id :=  UINT#150;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#150,TemplateTask_10steps_3.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#151,TemplateTask_10steps_3.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_10steps_3.Execute() THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 350;
                END_IF;

                IF _progress = 350 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#550, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#550;
                    END_IF;

                    IF TRUE THEN
                        _progress := 351;
                    END_IF;
                END_IF;

                IF _progress = 351 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#551, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#551;
                    END_IF;

                    IF Inputs.Status.WorkSensor THEN
                        _progress := 352;
                    END_IF;
                END_IF;
                
                IF _progress = 352 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#552, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#552;
                    END_IF;

                    IF TRUE THEN
                        _progress := 335;
                    END_IF;
                END_IF;
                
                IF _progress = 353 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#553, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#553;
                    END_IF;

                    IF TRUE THEN
                        _progress := 354;
                    END_IF;
                END_IF;
                
                IF _progress = 354 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#554, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#554;
                    END_IF;

                    IF TRUE THEN
                        _progress := 355;
                    END_IF;
                END_IF;
                
                IF _progress = 355 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#555, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#555;
                    END_IF;

                    IF TRUE THEN
                        _progress := 356;
                    END_IF;
                END_IF;
                
                IF _progress = 356 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#556, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#556;
                    END_IF;

                    IF TRUE THEN
                        _progress := 357;
                    END_IF;
                END_IF;
                
                IF _progress = 357 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#557, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#557;
                    END_IF;

                    IF TRUE THEN
                        _progress := 358;
                    END_IF;
                END_IF;
                
                IF _progress = 358 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#558, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#558;
                    END_IF;

                    IF TRUE THEN
                        _progress := 359;
                    END_IF;
                END_IF;
                
                IF _progress = 359 THEN
                    TemplateTask_10steps_3.DoneWhen(TRUE);
                END_IF;

                THIS.CallTimers(TRUE);
                
                TemplateTask_10steps_3.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_10steps_3.ThrowWhen(StopTask.Duration >= Config.ErrorTime ,'xxxxxxxx');
            END_IF;
            IF TemplateTask_10steps_3.DoneReached() THEN
                Status.Action.Id :=  UINT#151;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_10steps_3.ErrorOccured() THEN
                Status.Action.Id :=  UINT#850;
                Status.Error.Id  :=  UINT#850;
            ELSIF TemplateTask_10steps_3.AbortTriggered()THEN
                Status.Action.Id :=  UINT#851;
                Status.Error.Id  :=  UINT#851;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#850,TemplateTask_10steps_3.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#851,TemplateTask_10steps_3.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#152,TemplateTask_10steps_3.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_10steps_3.RestoreTriggered() AND _progress >= 350 AND _progress <= 359  THEN
                Status.Action.Id :=  UINT#152;
                _progress := 0;
            END_IF;
            //******************************************
            
            //*************TemplateTask_10steps_4***************
            TemplateTask_10steps_4.SetIsDisabled(FALSE);
            IF TemplateTask_10steps_4.StartTriggered() THEN
                Status.Action.Id :=  UINT#160;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#160,TemplateTask_10steps_4.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#161,TemplateTask_10steps_4.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_10steps_4.Execute() THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 360;
                END_IF;

                IF _progress = 360 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#560, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#560;
                    END_IF;

                    IF TRUE THEN
                        _progress := 361;
                    END_IF;
                END_IF;

                IF _progress = 361 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#561, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#561;
                    END_IF;

                    IF Inputs.Status.WorkSensor THEN
                        _progress := 362;
                    END_IF;
                END_IF;
                
                IF _progress = 362 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#562, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#562;
                    END_IF;

                    IF TRUE THEN
                        _progress := 363;
                    END_IF;
                END_IF;
                
                IF _progress = 363 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#563, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#563;
                    END_IF;

                    IF TRUE THEN
                        _progress := 364;
                    END_IF;
                END_IF;
                
                IF _progress = 364 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#564, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#564;
                    END_IF;

                    IF TRUE THEN
                        _progress := 365;
                    END_IF;
                END_IF;
                
                IF _progress = 365 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#565, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#565;
                    END_IF;

                    IF TRUE THEN
                        _progress := 366;
                    END_IF;
                END_IF;
                
                IF _progress = 366 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#566, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#566;
                    END_IF;

                    IF TRUE THEN
                        _progress := 367;
                    END_IF;
                END_IF;
                
                IF _progress = 367 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#567, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#567;
                    END_IF;

                    IF TRUE THEN
                        _progress := 368;
                    END_IF;
                END_IF;
                
                IF _progress = 368 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#568, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#568;
                    END_IF;

                    IF TRUE THEN
                        _progress := 369;
                    END_IF;
                END_IF;
                
                IF _progress = 369 THEN
                    TemplateTask_10steps_4.DoneWhen(TRUE);
                END_IF;

                THIS.CallTimers(TRUE);
                
                TemplateTask_10steps_4.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_10steps_4.ThrowWhen(StopTask.Duration >= Config.ErrorTime ,'xxxxxxxx');
            END_IF;
            IF TemplateTask_10steps_4.DoneReached() THEN
                Status.Action.Id :=  UINT#161;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_10steps_4.ErrorOccured() THEN
                Status.Action.Id :=  UINT#860;
                Status.Error.Id  :=  UINT#860;
            ELSIF TemplateTask_10steps_4.AbortTriggered()THEN
                Status.Action.Id :=  UINT#861;
                Status.Error.Id  :=  UINT#861;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#860,TemplateTask_10steps_4.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#861,TemplateTask_10steps_4.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#162,TemplateTask_10steps_4.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_10steps_4.RestoreTriggered() AND _progress >= 360 AND _progress <= 369  THEN
                Status.Action.Id :=  UINT#162;
                _progress := 0;
            END_IF;
            //******************************************
            
            //*************TemplateTask_10steps_5***************
            TemplateTask_10steps_5.SetIsDisabled(FALSE);
            IF TemplateTask_10steps_5.StartTriggered() THEN
                Status.Action.Id :=  UINT#170;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#170,TemplateTask_10steps_5.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#171,TemplateTask_10steps_5.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_10steps_5.Execute() THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 370;
                END_IF;

                IF _progress = 370 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#570, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#570;
                    END_IF;

                    IF TRUE THEN
                        _progress := 371;
                    END_IF;
                END_IF;

                IF _progress = 371 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#571, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#571;
                    END_IF;

                    IF Inputs.Status.WorkSensor THEN
                        _progress := 372;
                    END_IF;
                END_IF;
                
                IF _progress = 372 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#572, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#572;
                    END_IF;

                    IF TRUE THEN
                        _progress := 373;
                    END_IF;
                END_IF;
                
                IF _progress = 373 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#573, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#573;
                    END_IF;

                    IF TRUE THEN
                        _progress := 374;
                    END_IF;
                END_IF;
                
                IF _progress = 374 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#574, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#574;
                    END_IF;

                    IF TRUE THEN
                        _progress := 375;
                    END_IF;
                END_IF;
                
                IF _progress = 375 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#575, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#575;
                    END_IF;

                    IF TRUE THEN
                        _progress := 376;
                    END_IF;
                END_IF;
                
                IF _progress = 376 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#576, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#576;
                    END_IF;

                    IF TRUE THEN
                        _progress := 377;
                    END_IF;
                END_IF;
                
                IF _progress = 377 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#577, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#577;
                    END_IF;

                    IF TRUE THEN
                        _progress := 378;
                    END_IF;
                END_IF;
                
                IF _progress = 378 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#578, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#578;
                    END_IF;

                    IF TRUE THEN
                        _progress := 379;
                    END_IF;
                END_IF;
                
                IF _progress = 379 THEN
                    TemplateTask_10steps_5.DoneWhen(TRUE);
                END_IF;

                THIS.CallTimers(TRUE);
                
                TemplateTask_10steps_5.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_10steps_5.ThrowWhen(StopTask.Duration >= Config.ErrorTime ,'xxxxxxxx');
            END_IF;
            IF TemplateTask_10steps_5.DoneReached() THEN
                Status.Action.Id :=  UINT#171;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_10steps_5.ErrorOccured() THEN
                Status.Action.Id :=  UINT#870;
                Status.Error.Id  :=  UINT#870;
            ELSIF TemplateTask_10steps_5.AbortTriggered()THEN
                Status.Action.Id :=  UINT#871;
                Status.Error.Id  :=  UINT#871;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#870,TemplateTask_10steps_5.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#871,TemplateTask_10steps_5.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#172,TemplateTask_10steps_5.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_10steps_5.RestoreTriggered() AND _progress >= 370 AND _progress <= 379  THEN
                Status.Action.Id :=  UINT#172;
                _progress := 0;
            END_IF;
            //******************************************

            //*************TemplateTask_20steps_1***************
            TemplateTask_20steps_1.SetIsDisabled(FALSE);
            IF TemplateTask_20steps_1.StartTriggered() THEN
                Status.Action.Id :=  UINT#180;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#180,TemplateTask_20steps_1.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#181,TemplateTask_20steps_1.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_20steps_1.Execute() THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 380;
                END_IF;

                IF _progress = 380 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#580, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#580;
                    END_IF;

                    IF TRUE THEN
                        _progress := 381;
                    END_IF;
                END_IF;

                IF _progress = 381 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#581, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#581;
                    END_IF;

                    IF TRUE THEN
                        _progress := 382;
                    END_IF;
                END_IF;
                
                IF _progress = 382 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#582, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#582;
                    END_IF;

                    IF TRUE THEN
                        _progress := 383;
                    END_IF;
                END_IF;
                
                IF _progress = 383 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#583, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#583;
                    END_IF;

                    IF TRUE THEN
                        _progress := 384;
                    END_IF;
                END_IF;
                
                IF _progress = 384 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#584, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#584;
                    END_IF;

                    IF TRUE THEN
                        _progress := 385;
                    END_IF;
                END_IF;
                
                IF _progress = 385 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#585, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#585;
                    END_IF;

                    IF TRUE THEN
                        _progress := 386;
                    END_IF;
                END_IF;
                
                IF _progress = 386 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#586, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#586;
                    END_IF;

                    IF TRUE THEN
                        _progress := 387;
                    END_IF;
                END_IF;
                
                IF _progress = 387 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#587, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#587;
                    END_IF;

                    IF TRUE THEN
                        _progress := 388;
                    END_IF;
                END_IF;
                
                IF _progress = 388 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#588, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#588;
                    END_IF;

                    IF TRUE THEN
                        _progress := 389;
                    END_IF;
                END_IF;
                
                IF _progress = 389 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#589, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#589;
                    END_IF;

                    IF TRUE THEN
                        _progress := 390;
                    END_IF;
                END_IF;

                IF _progress = 390 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#590, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#590;
                    END_IF;

                    IF TRUE THEN
                        _progress := 391;
                    END_IF;
                END_IF;

                IF _progress = 391 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#591, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#591;
                    END_IF;

                    IF TRUE THEN
                        _progress := 392;
                    END_IF;
                END_IF;
                
                IF _progress = 392 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#592, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#592;
                    END_IF;

                    IF TRUE THEN
                        _progress := 393;
                    END_IF;
                END_IF;
                
                IF _progress = 393 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#593, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#593;
                    END_IF;

                    IF TRUE THEN
                        _progress := 394;
                    END_IF;
                END_IF;
                
                IF _progress = 394 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#594, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#594;
                    END_IF;

                    IF TRUE THEN
                        _progress := 395;
                    END_IF;
                END_IF;
                
                IF _progress = 395 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#595, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#595;
                    END_IF;

                    IF TRUE THEN
                        _progress := 396;
                    END_IF;
                END_IF;
                
                IF _progress = 396 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#596, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#596;
                    END_IF;

                    IF TRUE THEN
                        _progress := 397;
                    END_IF;
                END_IF;
                
                IF _progress = 397 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#597, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#597;
                    END_IF;

                    IF TRUE THEN
                        _progress := 398;
                    END_IF;
                END_IF;
                
                IF _progress = 398 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#598, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#598;
                    END_IF;

                    IF TRUE THEN
                        _progress := 399;
                    END_IF;
                END_IF;
                
                IF _progress = 399 THEN
                    TemplateTask_20steps_1.DoneWhen(TRUE);
                END_IF;

                THIS.CallTimers(TRUE);
                
                TemplateTask_20steps_1.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_1.ThrowWhen(StopTask.Duration >= Config.ErrorTime ,'xxxxxxxx');
            END_IF;
            IF TemplateTask_20steps_1.DoneReached() THEN
                Status.Action.Id :=  UINT#181;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_1.ErrorOccured() THEN
                Status.Action.Id :=  UINT#880;
                Status.Error.Id  :=  UINT#880;
            ELSIF TemplateTask_20steps_1.AbortTriggered()THEN
                Status.Action.Id :=  UINT#881;
                Status.Error.Id  :=  UINT#881;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#880,TemplateTask_20steps_1.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#881,TemplateTask_20steps_1.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#182,TemplateTask_20steps_1.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_20steps_1.RestoreTriggered() AND _progress >= 380 AND _progress <= 399  THEN
                Status.Action.Id :=  UINT#182;
                _progress := 0;
            END_IF;
            //******************************************

            //*************TemplateTask_20steps_2***************
            TemplateTask_20steps_2.SetIsDisabled(FALSE);
            IF TemplateTask_20steps_2.StartTriggered() THEN
                Status.Action.Id :=  UINT#200;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#200,TemplateTask_20steps_2.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#201,TemplateTask_20steps_2.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_20steps_2.Execute() THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 400;
                END_IF;

                IF _progress = 400 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#600, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#600;
                    END_IF;

                    IF TRUE THEN
                        _progress := 401;
                    END_IF;
                END_IF;

                IF _progress = 401 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#601, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#601;
                    END_IF;

                    IF TRUE THEN
                        _progress := 402;
                    END_IF;
                END_IF;
                
                IF _progress = 402 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#602, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#602;
                    END_IF;

                    IF TRUE THEN
                        _progress := 403;
                    END_IF;
                END_IF;
                
                IF _progress = 403 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#603, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#603;
                    END_IF;

                    IF TRUE THEN
                        _progress := 404;
                    END_IF;
                END_IF;
                
                IF _progress = 404 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#604, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#604;
                    END_IF;

                    IF TRUE THEN
                        _progress := 405;
                    END_IF;
                END_IF;
                
                IF _progress = 405 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#605, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#605;
                    END_IF;

                    IF TRUE THEN
                        _progress := 406;
                    END_IF;
                END_IF;
                
                IF _progress = 406 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#606, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#606;
                    END_IF;

                    IF TRUE THEN
                        _progress := 407;
                    END_IF;
                END_IF;
                
                IF _progress = 407 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#607, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#607;
                    END_IF;

                    IF TRUE THEN
                        _progress := 408;
                    END_IF;
                END_IF;
                
                IF _progress = 408 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#608, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#608;
                    END_IF;

                    IF TRUE THEN
                        _progress := 409;
                    END_IF;
                END_IF;
                
                IF _progress = 409 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#609, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#609;
                    END_IF;

                    IF TRUE THEN
                        _progress := 410;
                    END_IF;
                END_IF;

                IF _progress = 410 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#610, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#610;
                    END_IF;

                    IF TRUE THEN
                        _progress := 411;
                    END_IF;
                END_IF;

                IF _progress = 411 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#611, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#611;
                    END_IF;

                    IF TRUE THEN
                        _progress := 412;
                    END_IF;
                END_IF;
                
                IF _progress = 412 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#612, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#612;
                    END_IF;

                    IF TRUE THEN
                        _progress := 413;
                    END_IF;
                END_IF;
                
                IF _progress = 413 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#613, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#613;
                    END_IF;

                    IF TRUE THEN
                        _progress := 414;
                    END_IF;
                END_IF;
                
                IF _progress = 414 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#614, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#614;
                    END_IF;

                    IF TRUE THEN
                        _progress := 415;
                    END_IF;
                END_IF;
                
                IF _progress = 415 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#615, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#615;
                    END_IF;

                    IF TRUE THEN
                        _progress := 416;
                    END_IF;
                END_IF;
                
                IF _progress = 416 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#616, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#616;
                    END_IF;

                    IF TRUE THEN
                        _progress := 417;
                    END_IF;
                END_IF;
                
                IF _progress = 417 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#617, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#617;
                    END_IF;

                    IF TRUE THEN
                        _progress := 418;
                    END_IF;
                END_IF;
                
                IF _progress = 418 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#618, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#618;
                    END_IF;

                    IF TRUE THEN
                        _progress := 419;
                    END_IF;
                END_IF;
                
                IF _progress = 419 THEN
                    TemplateTask_20steps_2.DoneWhen(TRUE);
                END_IF;

                THIS.CallTimers(TRUE);
                
                TemplateTask_20steps_2.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_2.ThrowWhen(StopTask.Duration >= Config.ErrorTime ,'xxxxxxxx');
            END_IF;
            IF TemplateTask_20steps_2.DoneReached() THEN
                Status.Action.Id :=  UINT#201;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_2.ErrorOccured() THEN
                Status.Action.Id :=  UINT#900;
                Status.Error.Id  :=  UINT#900;
            ELSIF TemplateTask_20steps_2.AbortTriggered()THEN
                Status.Action.Id :=  UINT#901;
                Status.Error.Id  :=  UINT#901;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#900,TemplateTask_20steps_2.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#901,TemplateTask_20steps_2.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#202,TemplateTask_20steps_2.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_20steps_2.RestoreTriggered() AND _progress >= 400 AND _progress <= 419  THEN
                Status.Action.Id :=  UINT#202;
                _progress := 0;
            END_IF;
            //******************************************

            //*************TemplateTask_20steps_3***************
            TemplateTask_20steps_3.SetIsDisabled(FALSE);
            IF TemplateTask_20steps_3.StartTriggered() THEN
                Status.Action.Id :=  UINT#220;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#220,TemplateTask_20steps_3.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#221,TemplateTask_20steps_3.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_20steps_3.Execute() THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 420;
                END_IF;

                IF _progress = 420 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#620, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#620;
                    END_IF;

                    IF TRUE THEN
                        _progress := 421;
                    END_IF;
                END_IF;

                IF _progress = 421 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#621, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#621;
                    END_IF;

                    IF TRUE THEN
                        _progress := 422;
                    END_IF;
                END_IF;
                
                IF _progress = 422 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#622, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#622;
                    END_IF;

                    IF TRUE THEN
                        _progress := 423;
                    END_IF;
                END_IF;
                
                IF _progress = 423 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#623, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#623;
                    END_IF;

                    IF TRUE THEN
                        _progress := 424;
                    END_IF;
                END_IF;
                
                IF _progress = 424 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#624, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#624;
                    END_IF;

                    IF TRUE THEN
                        _progress := 425;
                    END_IF;
                END_IF;
                
                IF _progress = 425 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#625, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#625;
                    END_IF;

                    IF TRUE THEN
                        _progress := 426;
                    END_IF;
                END_IF;
                
                IF _progress = 426 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#626, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#626;
                    END_IF;

                    IF TRUE THEN
                        _progress := 427;
                    END_IF;
                END_IF;
                
                IF _progress = 427 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#627, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#627;
                    END_IF;

                    IF TRUE THEN
                        _progress := 428;
                    END_IF;
                END_IF;
                
                IF _progress = 428 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#628, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#628;
                    END_IF;

                    IF TRUE THEN
                        _progress := 429;
                    END_IF;
                END_IF;
                
                IF _progress = 429 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#629, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#629;
                    END_IF;

                    IF TRUE THEN
                        _progress := 430;
                    END_IF;
                END_IF;

                IF _progress = 430 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#630, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#630;
                    END_IF;

                    IF TRUE THEN
                        _progress := 431;
                    END_IF;
                END_IF;

                IF _progress = 431 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#631, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#631;
                    END_IF;

                    IF TRUE THEN
                        _progress := 432;
                    END_IF;
                END_IF;
                
                IF _progress = 432 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#632, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#632;
                    END_IF;

                    IF TRUE THEN
                        _progress := 433;
                    END_IF;
                END_IF;
                
                IF _progress = 433 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#633, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#633;
                    END_IF;

                    IF TRUE THEN
                        _progress := 434;
                    END_IF;
                END_IF;
                
                IF _progress = 434 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#634, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#634;
                    END_IF;

                    IF TRUE THEN
                        _progress := 435;
                    END_IF;
                END_IF;
                
                IF _progress = 435 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#635, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#635;
                    END_IF;

                    IF TRUE THEN
                        _progress := 436;
                    END_IF;
                END_IF;
                
                IF _progress = 436 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#636, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#636;
                    END_IF;

                    IF TRUE THEN
                        _progress := 437;
                    END_IF;
                END_IF;
                
                IF _progress = 437 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#637, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#637;
                    END_IF;

                    IF TRUE THEN
                        _progress := 438;
                    END_IF;
                END_IF;
                
                IF _progress = 438 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#638, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#638;
                    END_IF;

                    IF TRUE THEN
                        _progress := 439;
                    END_IF;
                END_IF;
                
                IF _progress = 439 THEN
                    TemplateTask_20steps_3.DoneWhen(TRUE);
                END_IF;

                THIS.CallTimers(TRUE);
                
                TemplateTask_20steps_3.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_3.ThrowWhen(StopTask.Duration >= Config.ErrorTime ,'xxxxxxxx');
            END_IF;
            IF TemplateTask_20steps_3.DoneReached() THEN
                Status.Action.Id :=  UINT#221;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_3.ErrorOccured() THEN
                Status.Action.Id :=  UINT#920;
                Status.Error.Id  :=  UINT#920;
            ELSIF TemplateTask_20steps_3.AbortTriggered()THEN
                Status.Action.Id :=  UINT#921;
                Status.Error.Id  :=  UINT#921;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#920,TemplateTask_20steps_3.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#921,TemplateTask_20steps_3.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#222,TemplateTask_20steps_3.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_20steps_3.RestoreTriggered() AND _progress >= 420 AND _progress <= 439  THEN
                Status.Action.Id :=  UINT#222;
                _progress := 0;
            END_IF;
            //******************************************       
            
            //*************TemplateTask_20steps_4***************
            TemplateTask_20steps_4.SetIsDisabled(FALSE);
            IF TemplateTask_20steps_4.StartTriggered() THEN
                Status.Action.Id :=  UINT#240;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#240,TemplateTask_20steps_4.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#241,TemplateTask_20steps_4.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_20steps_4.Execute() THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 440;
                END_IF;

                IF _progress = 440 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#640, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#640;
                    END_IF;

                    IF TRUE THEN
                        _progress := 441;
                    END_IF;
                END_IF;

                IF _progress = 441 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#641, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#641;
                    END_IF;

                    IF TRUE THEN
                        _progress := 442;
                    END_IF;
                END_IF;
                
                IF _progress = 442 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#642, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#642;
                    END_IF;

                    IF TRUE THEN
                        _progress := 443;
                    END_IF;
                END_IF;
                
                IF _progress = 443 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#643, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#643;
                    END_IF;

                    IF TRUE THEN
                        _progress := 444;
                    END_IF;
                END_IF;
                
                IF _progress = 444 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#644, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#644;
                    END_IF;

                    IF TRUE THEN
                        _progress := 445;
                    END_IF;
                END_IF;
                
                IF _progress = 445 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#645, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#645;
                    END_IF;

                    IF TRUE THEN
                        _progress := 446;
                    END_IF;
                END_IF;
                
                IF _progress = 446 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#646, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#646;
                    END_IF;

                    IF TRUE THEN
                        _progress := 447;
                    END_IF;
                END_IF;
                
                IF _progress = 447 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#647, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#647;
                    END_IF;

                    IF TRUE THEN
                        _progress := 448;
                    END_IF;
                END_IF;
                
                IF _progress = 448 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#648, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#648;
                    END_IF;

                    IF TRUE THEN
                        _progress := 449;
                    END_IF;
                END_IF;
                
                IF _progress = 449 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#649, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#649;
                    END_IF;

                    IF TRUE THEN
                        _progress := 450;
                    END_IF;
                END_IF;

                IF _progress = 450 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#650, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#650;
                    END_IF;

                    IF TRUE THEN
                        _progress := 451;
                    END_IF;
                END_IF;

                IF _progress = 451 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#651, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#651;
                    END_IF;

                    IF TRUE THEN
                        _progress := 452;
                    END_IF;
                END_IF;
                
                IF _progress = 452 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#652, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#652;
                    END_IF;

                    IF TRUE THEN
                        _progress := 453;
                    END_IF;
                END_IF;
                
                IF _progress = 453 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#653, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#653;
                    END_IF;

                    IF TRUE THEN
                        _progress := 454;
                    END_IF;
                END_IF;
                
                IF _progress = 454 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#654, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#654;
                    END_IF;

                    IF TRUE THEN
                        _progress := 455;
                    END_IF;
                END_IF;
                
                IF _progress = 455 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#655, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#655;
                    END_IF;

                    IF TRUE THEN
                        _progress := 456;
                    END_IF;
                END_IF;
                
                IF _progress = 456 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#656, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#656;
                    END_IF;

                    IF TRUE THEN
                        _progress := 457;
                    END_IF;
                END_IF;
                
                IF _progress = 457 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#657, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#657;
                    END_IF;

                    IF TRUE THEN
                        _progress := 458;
                    END_IF;
                END_IF;
                
                IF _progress = 458 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#658, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#658;
                    END_IF;

                    IF TRUE THEN
                        _progress := 459;
                    END_IF;
                END_IF;
                
                IF _progress = 459 THEN
                    TemplateTask_20steps_4.DoneWhen(TRUE);
                END_IF;

                THIS.CallTimers(TRUE);
                
                TemplateTask_20steps_4.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_4.ThrowWhen(StopTask.Duration >= Config.ErrorTime ,'xxxxxxxx');
            END_IF;
            IF TemplateTask_20steps_4.DoneReached() THEN
                Status.Action.Id :=  UINT#241;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_4.ErrorOccured() THEN
                Status.Action.Id :=  UINT#940;
                Status.Error.Id  :=  UINT#940;
            ELSIF TemplateTask_20steps_4.AbortTriggered()THEN
                Status.Action.Id :=  UINT#941;
                Status.Error.Id  :=  UINT#941;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#940,TemplateTask_20steps_4.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#941,TemplateTask_20steps_4.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#242,TemplateTask_20steps_4.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_20steps_4.RestoreTriggered() AND _progress >= 440 AND _progress <= 459  THEN
                Status.Action.Id :=  UINT#242;
                _progress := 0;
            END_IF;
            //******************************************
            
            //*************TemplateTask_20steps_5***************
            TemplateTask_20steps_5.SetIsDisabled(FALSE);
            IF TemplateTask_20steps_5.StartTriggered() THEN
                Status.Action.Id :=  UINT#260;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#260,TemplateTask_20steps_5.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#261,TemplateTask_20steps_5.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_20steps_5.Execute() THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 460;
                END_IF;

                IF _progress = 460 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#660, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#660;
                    END_IF;

                    IF TRUE THEN
                        _progress := 461;
                    END_IF;
                END_IF;

                IF _progress = 461 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#661, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#661;
                    END_IF;

                    IF TRUE THEN
                        _progress := 462;
                    END_IF;
                END_IF;
                
                IF _progress = 462 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#662, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#662;
                    END_IF;

                    IF TRUE THEN
                        _progress := 463;
                    END_IF;
                END_IF;
                
                IF _progress = 463 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#663, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#663;
                    END_IF;

                    IF TRUE THEN
                        _progress := 464;
                    END_IF;
                END_IF;
                
                IF _progress = 464 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#664, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#664;
                    END_IF;

                    IF TRUE THEN
                        _progress := 465;
                    END_IF;
                END_IF;
                
                IF _progress = 465 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#665, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#665;
                    END_IF;

                    IF TRUE THEN
                        _progress := 466;
                    END_IF;
                END_IF;
                
                IF _progress = 466 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#666, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#666;
                    END_IF;

                    IF TRUE THEN
                        _progress := 467;
                    END_IF;
                END_IF;
                
                IF _progress = 467 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#667, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#667;
                    END_IF;

                    IF TRUE THEN
                        _progress := 468;
                    END_IF;
                END_IF;
                
                IF _progress = 468 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#668, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#668;
                    END_IF;

                    IF TRUE THEN
                        _progress := 469;
                    END_IF;
                END_IF;
                
                IF _progress = 469 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#669, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#669;
                    END_IF;

                    IF TRUE THEN
                        _progress := 470;
                    END_IF;
                END_IF;

                IF _progress = 470 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#670, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#670;
                    END_IF;

                    IF TRUE THEN
                        _progress := 471;
                    END_IF;
                END_IF;

                IF _progress = 471 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#671, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#671;
                    END_IF;

                    IF TRUE THEN
                        _progress := 472;
                    END_IF;
                END_IF;
                
                IF _progress = 472 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#672, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#672;
                    END_IF;

                    IF TRUE THEN
                        _progress := 473;
                    END_IF;
                END_IF;
                
                IF _progress = 473 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#673, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#673;
                    END_IF;

                    IF TRUE THEN
                        _progress := 474;
                    END_IF;
                END_IF;
                
                IF _progress = 474 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#674, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#674;
                    END_IF;

                    IF TRUE THEN
                        _progress := 475;
                    END_IF;
                END_IF;
                
                IF _progress = 475 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#675, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#675;
                    END_IF;

                    IF TRUE THEN
                        _progress := 476;
                    END_IF;
                END_IF;
                
                IF _progress = 476 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#676, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#676;
                    END_IF;

                    IF TRUE THEN
                        _progress := 477;
                    END_IF;
                END_IF;
                
                IF _progress = 477 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#677, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#677;
                    END_IF;

                    IF TRUE THEN
                        _progress := 478;
                    END_IF;
                END_IF;
                
                IF _progress = 478 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#678, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#678;
                    END_IF;

                    IF TRUE THEN
                        _progress := 479;
                    END_IF;
                END_IF;
                
                IF _progress = 479 THEN
                    TemplateTask_20steps_5.DoneWhen(TRUE);
                END_IF;

                THIS.CallTimers(TRUE);
                
                TemplateTask_20steps_5.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_5.ThrowWhen(StopTask.Duration >= Config.ErrorTime ,'xxxxxxxx');
            END_IF;
            IF TemplateTask_20steps_5.DoneReached() THEN
                Status.Action.Id :=  UINT#261;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_5.ErrorOccured() THEN
                Status.Action.Id :=  UINT#960;
                Status.Error.Id  :=  UINT#960;
            ELSIF TemplateTask_20steps_5.AbortTriggered()THEN
                Status.Action.Id :=  UINT#961;
                Status.Error.Id  :=  UINT#961;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#960,TemplateTask_20steps_5.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#961,TemplateTask_20steps_5.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#262,TemplateTask_20steps_5.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_20steps_5.RestoreTriggered() AND _progress >= 460 AND _progress <= 479  THEN
                Status.Action.Id :=  UINT#262;
                _progress := 0;
            END_IF;
            //******************************************      
            
            
        END_METHOD

        METHOD PUBLIC Stop : IAxoTaskState
            Stop := StopTask.Invoke();
        END_METHOD

        METHOD PUBLIC MoveToHome : IAxoTaskState
            MoveToHome := MoveToHomeTask.Invoke();
        END_METHOD

        METHOD PUBLIC MoveToWork : IAxoTaskState
            MoveToWork := MoveToWorkTask.Invoke();
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            THIS._isManuallyControllable := true;
        END_METHOD
        
        ///<summary>
        /// Restores this component into intial state.        
        ///</summary>
        METHOD PUBLIC OVERRIDE Restore
            MoveToWorkTask.Restore();
            MoveToHomeTask.Restore();
            StopTask.Restore();

            TemplateTask_10steps_1.Restore();
            TemplateTask_10steps_2.Restore();
            TemplateTask_10steps_3.Restore();
            TemplateTask_10steps_4.Restore();
            TemplateTask_10steps_5.Restore();
            TemplateTask_20steps_1.Restore();
            TemplateTask_20steps_2.Restore();
            TemplateTask_20steps_3.Restore();
            TemplateTask_20steps_4.Restore();
            TemplateTask_20steps_5.Restore();

        END_METHOD        

        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal ,Config.InfoTime);
            _errorTimer.OnDelay(THIS, signal , Config.ErrorTime);
        END_METHOD

    END_CLASS
END_NAMESPACE
