USING AXOpen.Logging;
USING AXOpen.Core;
USING AXOpen.Messaging.Static;
USING AXOpen.Messaging;
USING AXOpen.Core;
USING AXOpen.Components.Abstractions;
USING AXOpen.Components.Abstractions.Drives;
USING System.Math;
USING System.BitAccess;

NAMESPACE AXOpen.Components.Desoutter.Tightening
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC AxoCVIC_II EXTENDS AXOpen.Core.AxoComponent
        VAR PRIVATE
            _RequiredScrewingProgram : BYTE;
            _infoTimer :  AXOpen.Timers.OnDelayTimer;
            // _errorTimer :  AXOpen.Timers.OnDelayTimer;
            _infoTime       :   LTIME := LT#2S;
            // _errorTime      :   LTIME := LT#5S;
        END_VAR
        VAR PUBLIC  //HEADER
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#State#>"}
            State          :   INT;
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Screwing program#>"}
            {#ix-attr:[ReadOnly()]}
            ScrewingProgram	:   BYTE;
            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Passed#>"}
            Passed          :   BOOL;
            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Failed#>"}
            Failed         :   BOOL;
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Torque#>"}
            {#ix-attr:[ReadOnly()]}
            Torque	    :   REAL;
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Torque trend#>"}
            {#ix-attr:[ReadOnly()]}
            TorqueTrend	:   INT;
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Angle#>"}
            {#ix-attr:[ReadOnly()]}
            Angle	    :   REAL;
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Angle trend#>"}
            {#ix-attr:[ReadOnly()]}
            AngleTrend	:   INT;
        END_VAR


        VAR PUBLIC // TASKS
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Reset#>"}
            ResetTask : AXOpen.Core.AxoTask;

            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Required screwing program#>"}
            RequiredScrewingProgram : BYTE;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Set screwing program#>"}
            SetScrewingProgramTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Start screwing#>"}
            StartScrewingTask : AXOpen.Core.AxoTask;


        END_VAR

        VAR PUBLIC //CONFIG
            // {#ix-attr:[Container(Layout.Stack)]}
            // {#ix-attr:[ComponentDetails("Config")]}
            // {#ix-set:AttributeName = "<#Screwing program min#>"}
            // {#ix-attr:[ReadOnly()]}
            // ScrewingProgramMin         :   BYTE := BYTE#0;
            // {#ix-attr:[Container(Layout.Stack)]}
            // {#ix-attr:[ComponentDetails("Config")]}
            // {#ix-set:AttributeName = "<#Screwing program max#>"}
            // {#ix-attr:[ReadOnly()]}
            // ScrewingProgramMax         :   BYTE := BYTE#255;
            // {#ix-attr:[Container(Layout.Stack)]}
            // {#ix-attr:[ComponentDetails("Config")]}
            // {#ix-set:AttributeName = "<#Program change timeout#>"}
            // {#ix-attr:[ReadOnly()]}
            // ProgramChangeTimeout         :   TIME := TIME#2S;
            // {#ix-attr:[ComponentDetails("Config")]}
            // {#ix-set:AttributeName = "<#Screwing cycle timeout#>"}
            // {#ix-attr:[ReadOnly()]}
            // ScrewingCycleTimeout         :   TIME := TIME#60S;

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config  :   AxoCVIC_II_Config;
        END_VAR

        VAR PUBLIC //STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status              :   AxoCVIC_II_ComponentStatus;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR    

        VAR PUBLIC //HARDWARE SIGNALS
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            {#ix-attr:[ReadOnly()]}
            Inputs              :   AxoCVIC_II_In;
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   AxoCVIC_II_Out;
        END_VAR    


        ///<summary>
		/// Custom component logic running before any other component logic.
        ///</summary>   
        METHOD PROTECTED OVERRIDE Open
            SUPER.Open();
        END_METHOD  
        
        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent                  :   IAxoObject; 
                refStatus               :   REF_TO BYTE;
                refActScrewingProgram   :   REF_TO BYTE;
                refTorque               :   REF_TO DWORD;
                refTorqueTrend          :   REF_TO WORD;
                refAngle                :   REF_TO DWORD;
                refAngleTrend           :   REF_TO WORD;
                refControl              :   REF_TO BYTE;
                refReqScrewingProgram   :   REF_TO BYTE;
            END_VAR

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                Status.Error.Id := UINT#700;
                RETURN;
            END_IF;

            THIS.Initialize(parent);
            THIS.Execute(refStatus,refActScrewingProgram,refTorque,refTorqueTrend,refAngle,refAngleTrend,refControl,refReqScrewingProgram);
                
        END_METHOD   

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent                  :   IAxoContext; 
                refStatus               :   REF_TO BYTE;
                refActScrewingProgram   :   REF_TO BYTE;
                refTorque               :   REF_TO DWORD;
                refTorqueTrend          :   REF_TO WORD;
                refAngle                :   REF_TO DWORD;
                refAngleTrend           :   REF_TO WORD;
                refControl              :   REF_TO BYTE;
                refReqScrewingProgram   :   REF_TO BYTE;
            END_VAR

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                Status.Error.Id := UINT#700;
                RETURN;
            END_IF;

            THIS.Initialize(parent);
            THIS.Execute(refStatus,refActScrewingProgram,refTorque,refTorqueTrend,refAngle,refAngleTrend,refControl,refReqScrewingProgram);
        END_METHOD  

        METHOD PRIVATE Execute
            VAR_INPUT
                refStatus       :   REF_TO BYTE;
                refActScrewingProgram   :   REF_TO BYTE;
                refTorque               :   REF_TO DWORD;
                refTorqueTrend          :   REF_TO WORD;
                refAngle                :   REF_TO DWORD;
                refAngleTrend           :   REF_TO WORD;
                refControl              :   REF_TO BYTE;
                refReqScrewingProgram   :   REF_TO BYTE;
            END_VAR
            VAR 
                _tempDword  :   DWORD;
            END_VAR

            Messenger.ActivateOnCondition(ULINT#701,refStatus   = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#702,refActScrewingProgram   = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#703,refTorque   = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#704,refTorqueTrend   = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#705,refAngle   = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#706,refAngleTrend   = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#707,refControl  = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#708,refReqScrewingProgram  = NULL, eAxoMessageCategory#ProgrammingError);

            IF refStatus = NULL THEN
                Status.Error.Id := UINT#701;
                RETURN;
            ELSIF refActScrewingProgram = NULL THEN
                Status.Error.Id := UINT#702;
                RETURN;
            ELSIF refTorque = NULL THEN
                Status.Error.Id := UINT#703;
                RETURN;
            ELSIF refTorqueTrend = NULL THEN
                Status.Error.Id := UINT#704;
                RETURN;
            ELSIF refAngle = NULL THEN
                Status.Error.Id := UINT#705;
                RETURN;
            ELSIF refAngleTrend = NULL THEN
                Status.Error.Id := UINT#706;
                RETURN;
            ELSIF refControl = NULL THEN
                Status.Error.Id := UINT#707;
                RETURN;
            ELSIF refReqScrewingProgram = NULL THEN
                Status.Error.Id := UINT#708;
                RETURN;
            END_IF;
            
            THIS.Open();

            Inputs.Status.CycleBit1         := refStatus^.%X0;
            Inputs.Status.CycleBit2         := refStatus^.%X1;
            Inputs.Status.CycleBit4         := refStatus^.%X2;
            Inputs.Status.Ready             := refStatus^.%X3;
            Inputs.Status.InCycle           := refStatus^.%X4;
            Inputs.Status.Passed            := refStatus^.%X5;
            Inputs.Status.Failed            := refStatus^.%X6;
            Inputs.Status.NumberOfCyclesOk  := refStatus^.%X7;

            Inputs.ScrewingProgram          := refActScrewingProgram^;
            Inputs.Torque                   := TO_REAL(refTorque^);
            Inputs.TorqueTrend              := TO_INT(refTorqueTrend^);
            Inputs.Angle                    := TO_REAL(refAngle^);
            Inputs.AngleTrend               := TO_INT(refAngleTrend^);
            //***********************************************//

            _infoTime := Config.InfoTime;

            //*************INITIALIZATION*************
            RestoreTask.Initialize(THIS);
            ResetTask.Initialize(THIS);
            SetScrewingProgramTask.Initialize(THIS);
            StartScrewingTask.Initialize(THIS);
            //****************************************

            //*************RESTORE********************
            RestoreTask.IsDisabled := FALSE;
            IF RestoreTask.Execute() THEN
                THIS.Restore();
            END_IF;
            //****************************************

            //*************RESET**********************
            ResetTask.SetIsDisabled(FALSE);
            IF ResetTask.Execute() THEN
                State := 0;
                Outputs.Control.SpindleValidation := FALSE;
                Outputs.Control.StartCycle := FALSE;
                Outputs.Control.Reset := TRUE;
                Outputs.Control.Direction := FALSE;
                Outputs.Control.ErrorAck := FALSE;
                ResetTask.DoneWhen(NOT Inputs.Status.Failed AND NOT Inputs.Status.InCycle AND Inputs.Status.Ready);
                ResetTask.ThrowWhen(ResetTask.Duration >= T#3S ,'Unable to reset the device.');
            END_IF;
            IF ResetTask.DoneReached() THEN
                Outputs.Control.Reset := FALSE;
                Status.Action.Id :=  UINT#320;
                Status.Error.Id :=  UINT#0;
            ELSIF ResetTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#713;
                Status.Error.Id :=  UINT#713;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#713,ResetTask.ErrorOccured() , eAxoMessageCategory#Error);

            //******************************************

            //*************SetScrewingProgram***********
            SetScrewingProgramTask.IsDisabled := FALSE;
            IF SetScrewingProgramTask.Execute() THEN
                IF _RequiredScrewingProgram < Config.ScrewingProgramMin THEN
                    Status.Error.Id := UINT#709;
                    RETURN;
                END_IF;
                IF _RequiredScrewingProgram > Config.ScrewingProgramMax THEN
                    Status.Error.Id := UINT#710;
                    RETURN;
                END_IF; 

                IF State = 0 THEN
                    THIS.CallTimers(FALSE);
                    State := 300;         
                END_IF; 

                //Set program
                IF State = 300 THEN
                    Outputs.ScrewingProgram := _RequiredScrewingProgram;
                    
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#600;
                    END_IF;

                    IF _RequiredScrewingProgram = Inputs.ScrewingProgram THEN
                        ScrewingProgram	:= _RequiredScrewingProgram;
                        THIS.CallTimers(FALSE);
                        State := 301;
                    END_IF;
                END_IF;

                IF State = 301 THEN
                    SetScrewingProgramTask.DoneWhen(TRUE);
                    State := 0;
                END_IF;

                SetScrewingProgramTask.ThrowWhen(SetScrewingProgramTask.Duration > Config.ProgramChangeTimeout, 'Unable to change the screwing program.');

                Status.Action.Id := TO_UINT(State);
                THIS.CallTimers(TRUE);
            END_IF;
            Messenger.ActivateOnCondition(ULINT#709,SetScrewingProgramTask.IsBusy() AND _RequiredScrewingProgram < Config.ScrewingProgramMin, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#710,SetScrewingProgramTask.IsBusy() AND _RequiredScrewingProgram > Config.ScrewingProgramMax, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#711,SetScrewingProgramTask.ErrorOccured() , eAxoMessageCategory#Error);

            IF SetScrewingProgramTask.DoneReached() THEN
                Status.Action.Id :=  UINT#302;
                Status.Error.Id :=  UINT#0;
            ELSIF SetScrewingProgramTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#711;
                Status.Error.Id :=  UINT#711;
            END_IF;
            //****************************************

            //*************StartScrewing**************
            StartScrewingTask.IsDisabled := FALSE;
            IF StartScrewingTask.Execute() THEN
                IF _RequiredScrewingProgram < Config.ScrewingProgramMin THEN
                    Status.Error.Id := UINT#709;
                    RETURN;
                END_IF;
                IF _RequiredScrewingProgram > Config.ScrewingProgramMax THEN
                    Status.Error.Id := UINT#710;
                    RETURN;
                END_IF; 

                IF State = 0 THEN
                    THIS.CallTimers(FALSE);
                    State := 310;
                END_IF; 

                //Reset results
                IF State = 310 THEN
                    Outputs.Control.SpindleValidation := FALSE;
                    Outputs.Control.Reset := FALSE;
                    Outputs.Control.StartCycle := FALSE;
                    Passed := FALSE;
                    Failed := FALSE;
                    Torque	    :=  REAL#0.0;
                    TorqueTrend	:=  INT#0;
                    Angle	    :=  REAL#0.0;
                    AngleTrend	:=  INT#0;
                    THIS.CallTimers(FALSE);
                    State := 311;
                END_IF;

                //Check if program already set 
                IF State = 311 THEN
                    IF _RequiredScrewingProgram = Inputs.ScrewingProgram THEN
                        ScrewingProgram	:= _RequiredScrewingProgram;
                        State := 313;
                    ELSE
                        ScrewingProgram	:= BYTE#0;
                        State := 312;
                    END_IF;
                END_IF;

                //Set program
                IF State = 312 THEN
                    Outputs.ScrewingProgram := _RequiredScrewingProgram;

                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#601;
                    END_IF;

                    IF _RequiredScrewingProgram = Inputs.ScrewingProgram THEN
                        ScrewingProgram	:= _RequiredScrewingProgram;
                        THIS.CallTimers(FALSE);
                        State := 313;
                    END_IF;
                END_IF;

                // wait for screwdriver ready
                IF State = 313 THEN
                    IF _infoTimer.output THEN
                        IF NOT Inputs.Status.Ready THEN
                            Status.Error.Id := UINT#602;
                        ELSIF Inputs.Status.InCycle THEN
                            Status.Error.Id := UINT#603;
                        END_IF;
                    END_IF;
                    IF (Inputs.Status.Ready AND NOT Inputs.Status.InCycle) THEN
                        THIS.CallTimers(FALSE);
                        State := 314;
                    END_IF;
                END_IF;

                // start screwing cycle 
                IF State = 314 THEN
                    Outputs.Control.StartCycle := TRUE;
                    Outputs.Control.SpindleValidation := TRUE;
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#604;
                    END_IF;
                    IF (Inputs.Status.InCycle) THEN
                        THIS.CallTimers(FALSE);
                        State := 315;
                    END_IF;
                END_IF;

                // wait for screwing cycle end
                IF State = 315 THEN
                    IF _infoTimer.output THEN
                        IF Inputs.Status.InCycle THEN
                            Status.Error.Id := UINT#605;
                        ELSIF NOT Inputs.Status.Failed AND NOT Inputs.Status.Passed THEN
                            Status.Error.Id := UINT#606;
                        END_IF;
                    END_IF;
                    
                    IF (NOT Inputs.Status.InCycle AND (Inputs.Status.Failed OR Inputs.Status.Passed)) THEN
                        Outputs.Control.StartCycle := FALSE;
                        Outputs.Control.SpindleValidation := FALSE;
                        
                        Passed          := Inputs.Status.Passed;
                        Failed          := Inputs.Status.Failed;
                        Torque          := Inputs.Torque;
                        TorqueTrend     := Inputs.TorqueTrend;
                        Angle           := Inputs.Angle;
                        AngleTrend      := Inputs.AngleTrend;
                        THIS.CallTimers(FALSE);
                        State := 316;
                    END_IF;
                END_IF;

                // finished
                IF State = 316 THEN
                    State := 0;
                    StartScrewingTask.DoneWhen(TRUE);
                END_IF;

                StartScrewingTask.ThrowWhen(StartScrewingTask.Duration > Config.ScrewingCycleTimeout, 'Screwing cycle takes too long.');
                Status.Action.Id := TO_UINT(State);
                THIS.CallTimers(TRUE);
            END_IF;

            Messenger.ActivateOnCondition(ULINT#709,SetScrewingProgramTask.IsBusy() AND _RequiredScrewingProgram < Config.ScrewingProgramMin, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#710,SetScrewingProgramTask.IsBusy() AND _RequiredScrewingProgram > Config.ScrewingProgramMax, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#712,SetScrewingProgramTask.ErrorOccured(), eAxoMessageCategory#ProgrammingError);

            IF StartScrewingTask.DoneReached() THEN
                Status.Action.Id :=  UINT#317;
                Status.Error.Id :=  UINT#0;
            ELSIF StartScrewingTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#712;
                Status.Error.Id :=  UINT#712;
            END_IF;
            //****************************************

            //***********************************************//
            refControl^.%X0         :=  Outputs.Control.CycleBit1;      
            refControl^.%X1         :=  Outputs.Control.CycleBit2;      
            refControl^.%X2         :=  Outputs.Control.CycleBit4;      
            refControl^.%X3         :=  Outputs.Control.SpindleValidation;      
            refControl^.%X4         :=  Outputs.Control.ErrorAck;      
            refControl^.%X5         :=  Outputs.Control.StartCycle;      
            refControl^.%X6         :=  Outputs.Control.Direction;      
            refControl^.%X7         :=  Outputs.Control.Reset;      

            refReqScrewingProgram^  :=  Outputs.ScrewingProgram;             
            THIS.Close();
        END_METHOD  

        ///<summary>
        /// This method resets the device
        ///<summary>
        METHOD PUBLIC Reset : IAxoTaskState
            Reset    := ResetTask.Invoke();
        END_METHOD

        ///<summary>
        /// This method changes the screwing program
        ///<summary>
        METHOD PUBLIC SetScrewingProgram : IAxoTaskState
            VAR_INPUT
                ProgramNo : INT;
            END_VAR
            
            _RequiredScrewingProgram := TO_BYTE(ProgramNo);

            SetScrewingProgram    := SetScrewingProgramTask.Invoke();
        END_METHOD


        ///<summary>
        /// This method starts the screwing process
        ///<summary>
        METHOD PUBLIC StartScrewing : IAxoTaskState
            VAR_INPUT
                ProgramNo : INT;
            END_VAR
            
            _RequiredScrewingProgram := TO_BYTE(ProgramNo);

            StartScrewing    := StartScrewingTask.Invoke();
        END_METHOD

        ///<summary>
		/// Custom component logic running after any other component logic.
        ///</summary>   
        METHOD PROTECTED OVERRIDE Close
            SUPER.Close();
        END_METHOD 


        METHOD PUBLIC OVERRIDE Restore
            Status.Action.Id := UINT#0;
            Status.Error.Id  := UINT#0;

            ResetTask.Restore();
            SetScrewingProgramTask.Restore();
            StartScrewingTask.Restore();
            State := 0;
            RestoreTask.DoneWhen(TRUE);
        END_METHOD
    
        METHOD PROTECTED OVERRIDE ManualControl
            _RequiredScrewingProgram := RequiredScrewingProgram;
            
        END_METHOD

        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal , _infoTime);
            // _errorTimer.OnDelay(THIS, signal , _errorTime );
        END_METHOD


    END_CLASS
END_NAMESPACE