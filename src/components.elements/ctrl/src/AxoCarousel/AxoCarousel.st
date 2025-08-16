USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Abstractions;


NAMESPACE AXOpen.Elements
    {S7.extern=ReadWrite}
    CLASS AxoCarousel EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC // HEADER
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Turn#>"}
            TurnTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentHeader()]}         
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Current position#>"}
            CurrentPosition  :   UINT;
        END_VAR

        VAR PUBLIC // TASKS
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#InitPositionTask#>"}
            InitPositionTask : AXOpen.Core.AxoTask;
        END_VAR
        
        VAR PUBLIC // CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config  :   AxoCarousel_Config;
        END_VAR

        VAR PUBLIC // STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status              :   AxoCarousel_Component_Status;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR    

        VAR PUBLIC //Hardware signals
            {#ix-attr:[ComponentDetails("Hardware signals")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            // {#ix-attr:[ReadOnly()]}      //TODO uncomment this after debugging is finished
            Inputs              :   AxoCarousel_State;
            {#ix-attr:[ComponentDetails("Hardware signals")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            // {#ix-attr:[ReadOnly()]}      //TODO uncomment this after debugging is finished
            Outputs              :   AxoCarousel_Control;
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
        METHOD PUBLIC Run
            VAR_INPUT
                parent              :   IAxoObject;
                SafetyCondition     :   BOOL;
            	InPosition          :   BOOL;
            	InPrecisePosition   :   BOOL;                
                CodingPosition      :   UINT;
            END_VAR

            VAR_OUTPUT
                EnableTurn : BOOL;
                StartTurn : BOOL;
            END_VAR

            VAR
                _index :    UINT;
            END_VAR

            SUPER.Run(parent);

            Messenger.Serve(THIS);
            
            IF parent = NULL THEN
                Messenger.Activate(UINT#700, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#700;
                RETURN;
            END_IF;
            
            IF Config.NumberOfPositions < UINT#2 THEN
                Messenger.Activate(UINT#701, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#701;
                RETURN;
            END_IF;

            IF Config.NumberOfPositions > UINT#32 THEN
                Messenger.Activate(UINT#702, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#702;
                RETURN;
            END_IF;

            IF Config.OffSet = UINT#0 THEN
                Config.OffSet := UINT#1;
            END_IF;
            
            //***********Update inputs **************
            Inputs.SafetyCondition      :=  SafetyCondition;
            Inputs.InPosition           :=  InPosition;
            Inputs.InPrecisePosition    :=  InPrecisePosition;
            Inputs.CodingPosition       :=  CodingPosition;


            //*************INITIALIZATION*************
            RestoreTask.Run(THIS);
            TurnTask.Run(THIS);
            InitPositionTask.Run(THIS);
    
            //****************************************
    
            //*********CALCULATE POSITIONS************
            CurrentPosition := Inputs.CodingPosition - Config.Offset + UINT#1;
            Status.Positions[Config.NumberOfPositions - UINT#1] := UINT#1 + CurrentPosition MOD Config.NumberOfPositions;
            FOR _index := 1 TO (Config.NumberOfPositions - UINT#1) DO	
                Status.Positions[Config.NumberOfPositions - UINT#1 - _index] := UINT#1 + (Status.Positions[Config.NumberOfPositions - _index]) MOD (Config.NumberOfPositions);			
            END_FOR;

            //****************************************
    
            //*************RESTORE********************
            RestoreTask.SetIsDisabled(FALSE);
            IF RestoreTask.Execute(THIS) THEN
                THIS.Restore();
            END_IF;
            //****************************************
    
            //*************TurnTask**************
            TurnTask.ThrowWhen(TurnTask.IsBusy() AND NOT SafetyCondition, 'The safety condition is lost during movement.');
            TurnTask.SetIsDisabled(NOT SafetyCondition OR RestoreTask.IsBusy() OR InitPositionTask.IsBusy());
            IF TurnTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#100,TurnTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,TurnTask.IsDone(), eAxoMessageCategory#Info);
            IF TurnTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;
    
                IF _progress = 300 THEN                                                                                     // TurnTask running: checking the initial position
                    IF NOT Inputs.InPosition THEN                                                                           // Turn table is not in the initial position
                        Messenger.Activate(     UINT#703, eAxoMessageCategory#Error);                                       
                        TaskMessenger.Activate( UINT#703, eAxoMessageCategory#Error);                                       
                        Status.Error.Id :=      UINT#703;
                    END_IF;

                    IF Inputs.InPosition THEN
                        THIS.CallTimers(FALSE);
                        _progress := 301;
                    END_IF;
                END_IF;
    
                IF _progress = 301 THEN                                                                                     // TurnTask running: evaluating start index
                    IF CurrentPosition = UINT#0 THEN                                                                        // Invalid coding, no signal from any coding sensor
                        Messenger.Activate(     UINT#704, eAxoMessageCategory#Error);                                       
                        TaskMessenger.Activate( UINT#704, eAxoMessageCategory#Error);
                        Status.Error.Id :=      UINT#704;                                       
                     END_IF;
                    IF CurrentPosition > Config.NumberOfPositions THEN                                                      // Invalid coding, current position is greather then maximum
                        Messenger.Activate(     UINT#705, eAxoMessageCategory#Error);                                       
                        TaskMessenger.Activate( UINT#705, eAxoMessageCategory#Error);
                        Status.Error.Id :=      UINT#705;                                       
                    END_IF;
    
                    IF CurrentPosition > UINT#0 AND CurrentPosition<= Config.NumberOfPositions THEN
                        Status.StartPosition := CurrentPosition;
                        Status.EndPosition := Status.Positions[Config.NumberOfPositions-UINT#1];
                        THIS.CallTimers(FALSE);
                        _progress := 302;
                    END_IF;
                END_IF;
                
                IF _progress = 302 THEN                                                                                     // TurnTask running: turn table moving, waiting for 'Inputs.InPosition' to be reseted.
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#502, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#502;
                    END_IF;

                    Outputs.EnableTurn := TRUE;
                    Outputs.StartTurn := TRUE;

                    IF NOT Inputs.InPosition THEN
                        Outputs.EnableTurn := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 303;
                    END_IF;
                END_IF;
                
                IF _progress = 303 THEN                                                                                     // TurnTask running: turn table moving, waiting for 'Inputs.InPosition' to be set.
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#503, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#503;
                    END_IF;
    
                    Outputs.EnableTurn := FALSE;
                    Outputs.StartTurn := TRUE;

                    IF Inputs.InPosition THEN
                        Outputs.EnableTurn := FALSE;
                        Outputs.StartTurn := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 304;
                    END_IF;
                END_IF;
                
                IF _progress = 304 THEN                                                                                     // TurnTask running: evaluating end index
                    IF Status.EndPosition = Status.Positions[UINT#0] THEN
                        THIS.CallTimers(FALSE);
                        _progress := 309;
                    ELSE
                        Messenger.Activate(     UINT#706, eAxoMessageCategory#Error);                                       
                        TaskMessenger.Activate( UINT#706, eAxoMessageCategory#Error);
                        Status.Error.Id :=      UINT#706;
                    END_IF;
                END_IF;
                
                IF _progress = 309 THEN                                                                                     // TurnTask running: , <add the detailed description of the current action 10>
                    TurnTask.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TurnTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TurnTask.ThrowWhen(TurnTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TurnTask timeout.');
            END_IF;
            IF TurnTask.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF TurnTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10000;
                Status.Error.Id  :=  UINT#10000;
                Outputs.EnableTurn := FALSE;
                Outputs.StartTurn := FALSE;
            ELSIF TurnTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10001;
                Status.Error.Id  :=  UINT#10001;
                Outputs.EnableTurn := FALSE;
                Outputs.StartTurn := FALSE;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10000,TurnTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10001,TurnTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,TurnTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TurnTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 309  THEN
                Status.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************InitPositionTask***************
            InitPositionTask.ThrowWhen(InitPositionTask.IsBusy() AND NOT SafetyCondition, 'The safety condition is lost during movement.');
            InitPositionTask.SetIsDisabled(NOT SafetyCondition OR RestoreTask.IsBusy() OR TurnTask.IsBusy());
            IF InitPositionTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#110;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#110,InitPositionTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,InitPositionTask.IsDone(), eAxoMessageCategory#Info);
            IF InitPositionTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 312;
                END_IF;
    
                IF _progress = 312 THEN                                                                                     // InitPositionTask running: turn table moving, waiting for 'Inputs.InPosition' to be reseted.
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#512, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#512;
                    END_IF;
    
                    Outputs.EnableTurn := TRUE;
                    Outputs.StartTurn := TRUE;

                    IF NOT Inputs.InPosition THEN
                        Outputs.EnableTurn := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 313;
                    END_IF;
                END_IF;
                
                IF _progress = 313 THEN                                                                                     // InitPositionTask running: turn table moving, waiting for 'Inputs.InPosition' to be set.
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#513, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#513;
                    END_IF;
    
                    Outputs.EnableTurn := FALSE;
                    Outputs.StartTurn := TRUE;

                    IF Inputs.InPosition THEN
                        Outputs.EnableTurn := FALSE;
                        Outputs.StartTurn := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 319;
                    END_IF;
                END_IF;
                
                IF _progress = 319 THEN                                                                                     // InitPositionTask running: , <add the detailed description of the current action 10>
                    InitPositionTask.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                InitPositionTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                InitPositionTask.ThrowWhen(InitPositionTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'InitPositionTask timeout.');
            END_IF;
            IF InitPositionTask.DoneReached() THEN
                Status.Action.Id :=  UINT#111;
                Status.Error.Id :=  UINT#0;
            ELSIF InitPositionTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10010;
                Status.Error.Id  :=  UINT#10010;
                Outputs.EnableTurn := FALSE;
                Outputs.StartTurn := FALSE;
            ELSIF InitPositionTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10011;
                Status.Error.Id  :=  UINT#10011;
                Outputs.EnableTurn := FALSE;
                Outputs.StartTurn := FALSE;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10010,InitPositionTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10011,InitPositionTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#112,InitPositionTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF InitPositionTask.RestoreTriggered() AND _progress >= 310 AND _progress <= 319  THEN
                Status.Action.Id :=  UINT#112;
                _progress := 0;
            END_IF;
            //**************************************************
            IF NOT Inputs.SafetyCondition THEN 
                Outputs.EnableTurn  :=  FALSE;
                Outputs.StartTurn   :=  FALSE;
            END_IF;

            //***********Update outputs ****************
            EnableTurn  :=  Outputs.EnableTurn;
            StartTurn   :=  Outputs.StartTurn;
            
            //******************************************      

        END_METHOD

        METHOD PUBLIC Turn : IAxoTaskState
            Turn := TurnTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC InitPosition : IAxoTaskState
            InitPosition := InitPositionTask.Invoke(THIS);
        END_METHOD


        METHOD PROTECTED OVERRIDE ManualControl
            THIS._isManuallyControllable := true;
        END_METHOD
        
        ///<summary>
        /// Restores this component into intial state.        
        ///</summary>
        METHOD PUBLIC OVERRIDE Restore
            VAR
                _index : INT;
            END_VAR
            Status.Action.Id := UINT#0;
            Status.Error.Id  := UINT#0;

            _progress       :=   INT#0;
            TurnTask.Restore();
            InitPositionTask.Restore();
            Status.Action.Id := UINT#50;
            RestoreTask.DoneWhen(TRUE);

            Outputs.EnableTurn  :=  FALSE;
            Outputs.StartTurn   :=  FALSE;


        END_METHOD        

        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal AND Config.InfoTime > LT#0S ,Config.InfoTime);
            _errorTimer.OnDelay(THIS, signal AND Config.ErrorTime > LT#0S , Config.ErrorTime);
        END_METHOD

    END_CLASS
END_NAMESPACE
