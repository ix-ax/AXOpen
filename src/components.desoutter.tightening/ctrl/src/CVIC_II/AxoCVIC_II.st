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
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-set:AttributeName = "<#Screwing program min#>"}
            {#ix-attr:[ReadOnly()]}
            ScrewingProgramMin         :   BYTE := BYTE#0;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-set:AttributeName = "<#Screwing program max#>"}
            {#ix-attr:[ReadOnly()]}
            ScrewingProgramMax         :   BYTE := BYTE#255;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-set:AttributeName = "<#Program change timeout#>"}
            {#ix-attr:[ReadOnly()]}
            ProgramChangeTimeout         :   TIME := TIME#2S;
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-set:AttributeName = "<#Screwing cycle timeout#>"}
            {#ix-attr:[ReadOnly()]}
            ScrewingCycleTimeout         :   TIME := TIME#60S;
        END_VAR

        VAR PUBLIC //STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status              :   AXOpen.Components.Abstractions.AxoComponent_Status;
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
                parent              :   IAxoObject; 
                refInput_1_byte_1   :   REF_TO BYTE;
                refInput_1_byte_2   :   REF_TO BYTE;
                refInput_2_word_1   :   REF_TO DWORD;
                refInput_1_word_1   :   REF_TO WORD;
                refInput_2_word_2   :   REF_TO DWORD;
                refInput_1_word_2   :   REF_TO WORD;
                refOutput_1_byte_1  :   REF_TO BYTE;
                refOutput_1_byte_2  :   REF_TO BYTE;
            END_VAR

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                Status.Error.Id := UINT#700;
                RETURN;
            END_IF;

            THIS.Initialize(parent);
            THIS.Execute(refInput_1_byte_1,refInput_1_byte_2,refInput_2_word_1,refInput_1_word_1,refInput_2_word_2,refInput_1_word_2,refOutput_1_byte_1,refOutput_1_byte_2);
        END_METHOD   

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent              :   IAxoContext; 
                refInput_1_byte_1   :   REF_TO BYTE;
                refInput_1_byte_2   :   REF_TO BYTE;
                refInput_2_word_1   :   REF_TO DWORD;
                refInput_1_word_1   :   REF_TO WORD;
                refInput_2_word_2   :   REF_TO DWORD;
                refInput_1_word_2   :   REF_TO WORD;
                refOutput_1_byte_1  :   REF_TO BYTE;
                refOutput_1_byte_2  :   REF_TO BYTE;
            END_VAR

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                Status.Error.Id := UINT#700;
                RETURN;
            END_IF;

            THIS.Initialize(parent);
            THIS.Execute(refInput_1_byte_1,refInput_1_byte_2,refInput_2_word_1,refInput_1_word_1,refInput_2_word_2,refInput_1_word_2,refOutput_1_byte_1,refOutput_1_byte_2);
        END_METHOD  

        METHOD PRIVATE Execute
            VAR_INPUT
                refInput_1_byte_1   :   REF_TO BYTE;
                refInput_1_byte_2   :   REF_TO BYTE;
                refInput_2_word_1   :   REF_TO DWORD;
                refInput_1_word_1   :   REF_TO WORD;
                refInput_2_word_2   :   REF_TO DWORD;
                refInput_1_word_2   :   REF_TO WORD;
                refOutput_1_byte_1  :   REF_TO BYTE;
                refOutput_1_byte_2  :   REF_TO BYTE;
            END_VAR
            VAR 
                _tempDword  :   DWORD;
            END_VAR

            Messenger.ActivateOnCondition(ULINT#701,refInput_1_byte_1   = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#702,refInput_1_byte_2   = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#703,refInput_2_word_1   = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#704,refInput_1_word_1   = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#705,refInput_2_word_2   = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#706,refInput_1_word_2   = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#707,refOutput_1_byte_1  = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#708,refOutput_1_byte_2  = NULL, eAxoMessageCategory#ProgrammingError);

            IF refInput_1_byte_1 = NULL THEN
                Status.Error.Id := UINT#701;
                RETURN;
            ELSIF refInput_1_byte_2 = NULL THEN
                Status.Error.Id := UINT#702;
                RETURN;
            ELSIF refInput_2_word_1 = NULL THEN
                Status.Error.Id := UINT#703;
                RETURN;
            ELSIF refInput_1_word_1 = NULL THEN
                Status.Error.Id := UINT#704;
                RETURN;
            ELSIF refInput_2_word_2 = NULL THEN
                Status.Error.Id := UINT#705;
                RETURN;
            ELSIF refInput_1_word_2 = NULL THEN
                Status.Error.Id := UINT#706;
                RETURN;
            ELSIF refOutput_1_byte_1 = NULL THEN
                Status.Error.Id := UINT#707;
                RETURN;
            ELSIF refOutput_1_byte_2 = NULL THEN
                Status.Error.Id := UINT#708;
                RETURN;
            END_IF;
            
            THIS.Open();

            Inputs.Status.CycleBit1         := refInput_1_byte_1^.%X0;
            Inputs.Status.CycleBit2         := refInput_1_byte_1^.%X1;
            Inputs.Status.CycleBit4         := refInput_1_byte_1^.%X2;
            Inputs.Status.Ready             := refInput_1_byte_1^.%X3;
            Inputs.Status.InCycle           := refInput_1_byte_1^.%X4;
            Inputs.Status.Passed            := refInput_1_byte_1^.%X5;
            Inputs.Status.Failed            := refInput_1_byte_1^.%X6;
            Inputs.Status.NumberOfCyclesOk  := refInput_1_byte_1^.%X7;

            Inputs.ScrewingProgram          := refInput_1_byte_2^;
            Inputs.Torque                   := TO_REAL(refInput_2_word_1^);
            Inputs.TorqueTrend              := TO_INT(refInput_1_word_1^);
            Inputs.Angle                    := TO_REAL(refInput_2_word_2^);
            Inputs.AngleTrend               := TO_INT(refInput_1_word_2^);
            //***********************************************//
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
            END_IF;
            //******************************************

            //*************SetScrewingProgram***********
            SetScrewingProgramTask.IsDisabled := FALSE;
            IF SetScrewingProgramTask.Execute() THEN
                IF _RequiredScrewingProgram < ScrewingProgramMin THEN
                    Status.Error.Id := UINT#709;
                    RETURN;
                END_IF;
                IF _RequiredScrewingProgram > ScrewingProgramMax THEN
                    Status.Error.Id := UINT#710;
                    RETURN;
                END_IF; 

                Outputs.ScrewingProgram := _RequiredScrewingProgram;

                SetScrewingProgramTask.DoneWhen(Inputs.ScrewingProgram = Outputs.ScrewingProgram);
                SetScrewingProgramTask.ThrowWhen(SetScrewingProgramTask.Duration > ProgramChangeTimeout, 'Unable to change screwing program.');
            END_IF;
            Messenger.ActivateOnCondition(ULINT#709,SetScrewingProgramTask.IsBusy() AND _RequiredScrewingProgram < ScrewingProgramMin, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#710,SetScrewingProgramTask.IsBusy() AND _RequiredScrewingProgram > ScrewingProgramMax, eAxoMessageCategory#ProgrammingError);

            IF SetScrewingProgramTask.DoneReached() THEN
                ScrewingProgram := _RequiredScrewingProgram;
            END_IF;
            //****************************************

            //*************StartScrewing**************
            StartScrewingTask.IsDisabled := FALSE;
            IF StartScrewingTask.Execute() THEN
                IF _RequiredScrewingProgram < ScrewingProgramMin THEN
                    Status.Error.Id := UINT#709;
                    RETURN;
                END_IF;
                IF _RequiredScrewingProgram > ScrewingProgramMax THEN
                    Status.Error.Id := UINT#710;
                    RETURN;
                END_IF; 

                //Reset results
                IF State = 0 THEN
                    Outputs.Control.SpindleValidation := FALSE;
                    Outputs.Control.Reset := FALSE;
                    Outputs.Control.StartCycle := FALSE;
                    Passed := FALSE;
                    Failed := FALSE;
                    Torque	    :=  REAL#0.0;
                    TorqueTrend	:=  INT#0;
                    Angle	    :=  REAL#0.0;
                    AngleTrend	:=  INT#0;
                    State := 10;
                END_IF;

                //Check if program already set 
                IF State = 10 THEN
                    IF _RequiredScrewingProgram = Inputs.ScrewingProgram THEN
                        ScrewingProgram	:= _RequiredScrewingProgram;
                        State := 30;
                    ELSE
                        ScrewingProgram	:= BYTE#0;
                        State := 20;
                    END_IF;
                END_IF;

                //Set program
                IF State = 20 THEN
                    Outputs.ScrewingProgram := _RequiredScrewingProgram;
                    IF _RequiredScrewingProgram = Inputs.ScrewingProgram THEN
                        ScrewingProgram	:= _RequiredScrewingProgram;
                        State := 30;
                    END_IF;
                END_IF;

                // wait for screwdriver ready
                IF State = 30 THEN
                    IF (Inputs.Status.Ready AND NOT Inputs.Status.InCycle) THEN
                        State := 40;
                    END_IF;
                END_IF;

                // start screwing cycle 
                IF State = 40 THEN
                    Outputs.Control.StartCycle := TRUE;
                    Outputs.Control.SpindleValidation := TRUE;
                    IF (Inputs.Status.InCycle) THEN
                        State := 50;
                    END_IF;
                END_IF;

                // wait for screwing cycle end
                IF State = 50 THEN
                    IF (NOT Inputs.Status.InCycle AND (Inputs.Status.Failed OR Inputs.Status.Passed)) THEN
                        Outputs.Control.StartCycle := FALSE;
                        Outputs.Control.SpindleValidation := FALSE;
                        
                        Passed          := Inputs.Status.Passed;
                        Failed          := Inputs.Status.Failed;
                        Torque          := Inputs.Torque;
                        TorqueTrend     := Inputs.TorqueTrend;
                        Angle           := Inputs.Angle;
                        AngleTrend      := Inputs.AngleTrend;
                        State := 60;
                    END_IF;
                END_IF;

                // finished
                IF State = 60 THEN
                    StartScrewingTask.DoneWhen(TRUE);
                END_IF;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#709,SetScrewingProgramTask.IsBusy() AND _RequiredScrewingProgram < ScrewingProgramMin, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#710,SetScrewingProgramTask.IsBusy() AND _RequiredScrewingProgram > ScrewingProgramMax, eAxoMessageCategory#ProgrammingError);

            //****************************************

            //***********************************************//
            refOutput_1_byte_1^.%X0         :=  Outputs.Control.CycleBit1;      
            refOutput_1_byte_1^.%X1         :=  Outputs.Control.CycleBit2;      
            refOutput_1_byte_1^.%X2         :=  Outputs.Control.CycleBit4;      
            refOutput_1_byte_1^.%X3         :=  Outputs.Control.SpindleValidation;      
            refOutput_1_byte_1^.%X4         :=  Outputs.Control.ErrorAck;      
            refOutput_1_byte_1^.%X5         :=  Outputs.Control.StartCycle;      
            refOutput_1_byte_1^.%X6         :=  Outputs.Control.Direction;      
            refOutput_1_byte_1^.%X7         :=  Outputs.Control.Reset;      

            refOutput_1_byte_2^             :=  Outputs.ScrewingProgram;             
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
            ResetTask.Restore();
            SetScrewingProgramTask.Restore();
            StartScrewingTask.Restore();
            State := 0;
            RestoreTask.DoneWhen(TRUE);
        END_METHOD
    
        METHOD PROTECTED OVERRIDE ManualControl
            _RequiredScrewingProgram := RequiredScrewingProgram;
            
        END_METHOD
    END_CLASS
END_NAMESPACE