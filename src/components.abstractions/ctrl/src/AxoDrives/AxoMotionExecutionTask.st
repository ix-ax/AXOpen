USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

NAMESPACE AXOpen.Components.Abstractions.AxoDrives
    CLASS PUBLIC ABSTRACT AxoMotionExecutionTask EXTENDS AXOpen.Core.AxoTask
        VAR PUBLIC
            Messenger   :   AxoMessenger;	
        END_VAR

        VAR PROTECTED 
            _infoTimer      :   AXOpen.Timers.OnDelayTimer;
            _errorTimer     :   AXOpen.Timers.OnDelayTimer;
            _infoTime       :   LTIME := LT#2S;
            _errorTime      :   LTIME := LT#5S;
            _progress       :   INT;
        END_VAR
        VAR PRIVATE
            _motionTaskId   :   INT;      
            _isBusyPV       :   BOOL;    
        END_VAR

        ///<summary>
        /// Runs the logic of this tasks.
        /// >[!IMPORTANT] This method must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run 
            VAR_IN_OUT
                AxisRef :   AxoAxisRef;
            END_VAR

            VAR_OUTPUT
                Done            :   BOOL;   //Motion task syccesfully finished
                Busy            :   BOOL;   //The FB is not finished and new output values are to be expected
                Active          :   BOOL;   //Indicates that the FB has control on the axis
                CommandAborted  :   BOOL;   //‘Command’ is aborted by another command
                Error           :   BOOL;   //Signals that an error has occurred within the Function Block
                ErrorID         :   WORD;   //Error identification
            END_VAR

            VAR 
                _Active         :   BOOL;
                _ErrorID        :   WORD;
            END_VAR


            _infoTime := AxisRef.Config.InfoTime;
            _errorTime := AxisRef.Config.ErrorTime;
            Messenger.Serve(THIS);
            _Active := FALSE;
            _ErrorID := WORD#0;

            // //Set the _motionTaskId for discovering which method controls the axis 
            // IF _motionTaskId = 0 THEN
            //     AxisRef.Status._MotionTaskIds := AxisRef.Status._MotionTaskIds + 1;
            //     _motionTaskId  := AxisRef.Status._MotionTaskIds;
            // END_IF;

            _isBusyPV := THIS.IsBusy();
            IF THIS.Execute() THEN
                THIS.MotionTaskExecute(AxisRef,_Active,_ErrorID);
                THIS.CallTimers(TRUE);
            END_IF;

            THIS.MotionTaskCyclic(AxisRef,_Active,_ErrorID);

            //Set the _motionTaskId as current one at the begining of the motion task
            IF NOT _isBusyPV AND THIS.IsBusy() THEN
                AxisRef.Status._CurrentMotionTaskId := _motionTaskId;
            END_IF;

            Done            := THIS.IsDone();
            Busy            := THIS.IsBusy();
            Active          := _Active;
            CommandAborted  := THIS.IsAborted();
            Error           := THIS.HasError();
            ErrorID         := _ErrorID;
        END_METHOD

        METHOD PUBLIC ABSTRACT MotionTaskExecute
            VAR_IN_OUT
                AxisRef     :   AxoAxisRef;
                Active      :   BOOL;       //Indicates that the FB has control on the axis
                ErrorID     :   WORD;       //Error identification
            END_VAR
        END_METHOD

        METHOD PUBLIC ABSTRACT MotionTaskCyclic
            VAR_IN_OUT
                AxisRef     :   AxoAxisRef;
                Active      :   BOOL;       //Indicates that the FB has control on the axis
                ErrorID     :   WORD;       //Error identification
            END_VAR
        END_METHOD

        METHOD INTERNAL CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal , _infoTime);
            _errorTimer.OnDelay(THIS, signal , _errorTime );
        END_METHOD

        METHOD PUBLIC Restore 
            _progress := 0;
            THIS.CallTimers(FALSE);
            SUPER.Restore();
        END_METHOD

        METHOD PROTECTED OVERRIDE OnRestore 
            ;
        END_METHOD

        METHOD PROTECTED OVERRIDE OnAbort 
            ;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnDone 
            ;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnError 
            ;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnStart 
            ;
        END_METHOD        
    END_CLASS    
END_NAMESPACE