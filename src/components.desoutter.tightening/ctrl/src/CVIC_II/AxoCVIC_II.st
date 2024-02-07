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
            _errorTimer :  AXOpen.Timers.OnDelayTimer;
            _hwID                   :   WORD;
            _hwId_Input_1_byte_1    :   WORD;
            _hwId_Input_1_byte_2    :   WORD;
            _hwId_Input_2_word_1    :   WORD;
            _hwId_Input_1_word_1    :   WORD;
            _hwId_Input_2_word_2    :   WORD;
            _hwId_Input_1_word_2    :   WORD;
            _hwId_Output_1_byte_1   :   WORD;
            _hwId_Output_1_byte_2   :   WORD;
        END_VAR
        VAR PUBLIC  //HEADER
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#_progress#>"}
            _progress          :   INT;
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

        VAR PUBLIC

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Hardware diagnostics")]}
            {#ix-set:AttributeName = "<#Update diagnostics#>"}
            HardwareDiagnosticsTask :   AXOpen.Io.AxoHardwareDiagnostics;
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
                hwID                    :   WORD;
                hwId_Input_1_byte_1     :   WORD;
                hwId_Input_1_byte_2     :   WORD;
                hwId_Input_2_word_1     :   WORD;
                hwId_Input_1_word_1     :   WORD;
                hwId_Input_2_word_2     :   WORD;
                hwId_Input_1_word_2     :   WORD;
                hwId_Output_1_byte_1    :   WORD;
                hwId_Output_1_byte_2    :   WORD;
            END_VAR

            Messenger.Serve(THIS);
            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701,hwId_Input_1_byte_1 = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#702,hwId_Input_1_byte_2 = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#703,hwId_Input_2_word_1 = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#704,hwId_Input_1_word_1 = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#705,hwId_Input_2_word_2 = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#706,hwId_Input_1_word_2 = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#707,hwId_Output_1_byte_1 = WORD#0, eAxoMessageCategory#ProgrammingError);            
            Messenger.ActivateOnCondition(ULINT#708,hwId_Output_1_byte_2 = WORD#0, eAxoMessageCategory#ProgrammingError);            

            IF parent = NULL THEN
                Status.Error.Id := UINT#700;
                RETURN;
            ELSIF hwId_Input_1_byte_2 = WORD#0 THEN
                Status.Error.Id := UINT#701;
                RETURN;
            ELSIF hwId_Input_1_byte_2 = WORD#0 THEN
                Status.Error.Id := UINT#702;
                RETURN;
            ELSIF hwId_Input_2_word_1 = WORD#0 THEN
                Status.Error.Id := UINT#703;
                RETURN;
            ELSIF hwId_Input_1_word_1 = WORD#0 THEN
                Status.Error.Id := UINT#704;
                RETURN;
            ELSIF hwId_Input_2_word_2 = WORD#0 THEN
                Status.Error.Id := UINT#705;
                RETURN;
            ELSIF hwId_Input_1_word_2 = WORD#0 THEN
                Status.Error.Id := UINT#706;
                RETURN;
            ELSIF hwId_Output_1_byte_1 = WORD#0 THEN
                Status.Error.Id := UINT#707;
                RETURN;
            ELSIF hwId_Output_1_byte_2 = WORD#0 THEN
                Status.Error.Id := UINT#708;
                RETURN;
            END_IF;

            _hwID                   :=  hwID;
            _hwId_Input_1_byte_1    :=  hwId_Input_1_byte_1;
            _hwId_Input_1_byte_2    :=  hwId_Input_1_byte_2;
            _hwId_Input_2_word_1    :=  hwId_Input_2_word_1;
            _hwId_Input_1_word_1    :=  hwId_Input_1_word_1;
            _hwId_Input_2_word_2    :=  hwId_Input_2_word_2;
            _hwId_Input_1_word_2    :=  hwId_Input_1_word_2;
            _hwId_Output_1_byte_1   :=  hwId_Output_1_byte_1;
            _hwId_Output_1_byte_2   :=  hwId_Output_1_byte_2;
            THIS.Initialize(parent);
            THIS.Execute();
                
        END_METHOD   

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent                  :   IAxoContext; 
                hwID                    :   WORD;
                hwId_Input_1_byte_1     :   WORD;
                hwId_Input_1_byte_2     :   WORD;
                hwId_Input_2_word_1     :   WORD;
                hwId_Input_1_word_1     :   WORD;
                hwId_Input_2_word_2     :   WORD;
                hwId_Input_1_word_2     :   WORD;
                hwId_Output_1_byte_1    :   WORD;
                hwId_Output_1_byte_2    :   WORD;
            END_VAR

            Messenger.Serve(THIS);
            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701,hwId_Input_1_byte_1 = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#702,hwId_Input_1_byte_2 = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#703,hwId_Input_2_word_1 = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#704,hwId_Input_1_word_1 = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#705,hwId_Input_2_word_2 = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#706,hwId_Input_1_word_2 = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#707,hwId_Output_1_byte_1 = WORD#0, eAxoMessageCategory#ProgrammingError);            
            Messenger.ActivateOnCondition(ULINT#708,hwId_Output_1_byte_2 = WORD#0, eAxoMessageCategory#ProgrammingError);            

            IF parent = NULL THEN
                Status.Error.Id := UINT#700;
                RETURN;
            ELSIF hwId_Input_1_byte_2 = WORD#0 THEN
                Status.Error.Id := UINT#701;
                RETURN;
            ELSIF hwId_Input_1_byte_2 = WORD#0 THEN
                Status.Error.Id := UINT#702;
                RETURN;
            ELSIF hwId_Input_2_word_1 = WORD#0 THEN
                Status.Error.Id := UINT#703;
                RETURN;
            ELSIF hwId_Input_1_word_1 = WORD#0 THEN
                Status.Error.Id := UINT#704;
                RETURN;
            ELSIF hwId_Input_2_word_2 = WORD#0 THEN
                Status.Error.Id := UINT#705;
                RETURN;
            ELSIF hwId_Input_1_word_2 = WORD#0 THEN
                Status.Error.Id := UINT#706;
                RETURN;
            ELSIF hwId_Output_1_byte_1 = WORD#0 THEN
                Status.Error.Id := UINT#707;
                RETURN;
            ELSIF hwId_Output_1_byte_2 = WORD#0 THEN
                Status.Error.Id := UINT#708;
                RETURN;
            END_IF;

            _hwID                   :=  hwID;
            _hwId_Input_1_byte_1    :=  hwId_Input_1_byte_1;
            _hwId_Input_1_byte_2    :=  hwId_Input_1_byte_2;
            _hwId_Input_2_word_1    :=  hwId_Input_2_word_1;
            _hwId_Input_1_word_1    :=  hwId_Input_1_word_1;
            _hwId_Input_2_word_2    :=  hwId_Input_2_word_2;
            _hwId_Input_1_word_2    :=  hwId_Input_1_word_2;
            _hwId_Output_1_byte_1   :=  hwId_Output_1_byte_1;
            _hwId_Output_1_byte_2   :=  hwId_Output_1_byte_2;
            THIS.Initialize(parent);
            THIS.Execute();
        END_METHOD

        METHOD PRIVATE Execute

            VAR 
                _tempDword  :   DWORD;
                returnValue : WORD;
                _data_1 : ARRAY[0..0] OF BYTE;
                _data_2 : ARRAY[0..1] OF BYTE;
                _data_4 : ARRAY[0..3] OF BYTE;
            END_VAR
            VAR
                _invalidDataSize : BOOL;
            END_VAR

            THIS.Open();

            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwId_Input_1_byte_1 ,_data_1);
            Messenger.ActivateOnCondition(ULINT#709,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#709;
                RETURN;
            END_IF;

            Inputs.Status.CycleBit1         := _data_1[0].%X0;
            Inputs.Status.CycleBit2         := _data_1[0].%X1;
            Inputs.Status.CycleBit4         := _data_1[0].%X2;
            Inputs.Status.Ready             := _data_1[0].%X3;
            Inputs.Status.InCycle           := _data_1[0].%X4;
            Inputs.Status.Passed            := _data_1[0].%X5;
            Inputs.Status.Failed            := _data_1[0].%X6;
            Inputs.Status.NumberOfCyclesOk  := _data_1[0].%X7;

            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwId_Input_1_byte_2 ,_data_1);
            Messenger.ActivateOnCondition(ULINT#710,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#710;
                RETURN;
            END_IF;

            Inputs.ScrewingProgram          := _data_1[0];

            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwId_Input_2_word_1 ,_data_4);
            Messenger.ActivateOnCondition(ULINT#711,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#711;
                RETURN;
            END_IF;

            System.Serialization.Deserialize(UINT#0,_data_4,Inputs.Torque);

            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwId_Input_1_word_1 ,_data_2);
            Messenger.ActivateOnCondition(ULINT#712,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#712;
                RETURN;
            END_IF;

            System.Serialization.Deserialize(UINT#0,_data_2,Inputs.TorqueTrend);

            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwId_Input_2_word_2 ,_data_4);
            Messenger.ActivateOnCondition(ULINT#713,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#713;
                RETURN;
            END_IF;

            System.Serialization.Deserialize(UINT#0,_data_4,Inputs.Angle);

            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwId_Input_1_word_2 ,_data_2);
            Messenger.ActivateOnCondition(ULINT#714,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#714;
                RETURN;
            END_IF;

            System.Serialization.Deserialize(UINT#0,_data_2,Inputs.AngleTrend);

            //***********************************************//

            //*************INITIALIZATION*************
            RestoreTask.Initialize(THIS);
            ResetTask.Initialize(THIS);
            SetScrewingProgramTask.Initialize(THIS);
            StartScrewingTask.Initialize(THIS);
            HardwareDiagnosticsTask.Initialize(THIS);
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

            //*************RESET**********************
            ResetTask.SetIsDisabled(FALSE);
            IF ResetTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#100,ResetTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,ResetTask.IsDone(), eAxoMessageCategory#Info);
            IF ResetTask.Execute() THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;

                IF _progress = 300 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#600, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#600;
                    END_IF;

                    Outputs.Control.SpindleValidation := FALSE;
                    Outputs.Control.StartCycle := FALSE;
                    Outputs.Control.Reset := TRUE;
                    Outputs.Control.Direction := FALSE;
                    Outputs.Control.ErrorAck := FALSE;
                    IF NOT Inputs.Status.Failed THEN
                        _progress := 301;
                    END_IF;
                END_IF;

                IF _progress = 301 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#601, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#601;
                    END_IF;
                    IF NOT Inputs.Status.InCycle THEN
                        _progress := 302;
                    END_IF;
                END_IF;
                
                IF _progress = 302 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#602, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#602;
                    END_IF;
                    IF Inputs.Status.Ready THEN
                        _progress := 303;
                    END_IF;
                END_IF;
                
                IF _progress = 303 THEN
                    Outputs.Control.SpindleValidation := FALSE;
                    Outputs.Control.StartCycle := FALSE;
                    Outputs.Control.Reset := FALSE;
                    Outputs.Control.Direction := FALSE;
                    Outputs.Control.ErrorAck := FALSE;
                    ResetTask.DoneWhen(TRUE);
                END_IF;
                THIS.CallTimers(TRUE);
                
                ResetTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ResetTask.ThrowWhen(ResetTask.Duration >= T#3S ,'Unable to reset the device.');
            END_IF;
            IF ResetTask.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF ResetTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#800;
                Status.Error.Id  :=  UINT#800;
            ELSIF ResetTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#801;
                Status.Error.Id  :=  UINT#801;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#800,ResetTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#801,ResetTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,ResetTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ResetTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 309  THEN
                Status.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;

            //******************************************

            //*************SetScrewingProgram***********
            SetScrewingProgramTask.IsDisabled := FALSE;
            IF SetScrewingProgramTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#110;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#110,SetScrewingProgramTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,SetScrewingProgramTask.IsDone(), eAxoMessageCategory#Info);
            IF SetScrewingProgramTask.Execute() THEN
                IF _RequiredScrewingProgram < Config.ScrewingProgramMin THEN
                    Status.Error.Id := UINT#717;
                    RETURN;
                END_IF;
                IF _RequiredScrewingProgram > Config.ScrewingProgramMax THEN
                    Status.Error.Id := UINT#718;
                    RETURN;
                END_IF; 

                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);      
                    _progress := 310;
                END_IF; 

                //Set program
                IF _progress = 310 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#610, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#610;
                    END_IF;

                    Outputs.ScrewingProgram := _RequiredScrewingProgram;
                    
                    IF _RequiredScrewingProgram = Inputs.ScrewingProgram THEN
                        ScrewingProgram	:= _RequiredScrewingProgram;
                        THIS.CallTimers(FALSE);
                        _progress := 311;
                    END_IF;
                END_IF;

                IF _progress = 311 THEN
                    SetScrewingProgramTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;

                SetScrewingProgramTask.ThrowWhen(SetScrewingProgramTask.Duration > Config.ProgramChangeTimeout, 'Unable to change the screwing program.');
                THIS.CallTimers(TRUE);
                
                Status.Action.Id := TO_UINT(_progress);
            END_IF;
            IF SetScrewingProgramTask.DoneReached() THEN
                Status.Action.Id :=  UINT#111;
                Status.Error.Id :=  UINT#0;
            ELSIF SetScrewingProgramTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#810;
                Status.Error.Id  :=  UINT#810;
            ELSIF SetScrewingProgramTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#811;
                Status.Error.Id  :=  UINT#811;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#810,SetScrewingProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#811,SetScrewingProgramTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#112,SetScrewingProgramTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF SetScrewingProgramTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 329  THEN
                Status.Action.Id :=  UINT#112;
                _progress := 0;
            END_IF;
            //****************************************

            //*************StartScrewing**************
            StartScrewingTask.IsDisabled := FALSE;
            IF StartScrewingTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#120;
            END_IF;
            IF StartScrewingTask.Execute() THEN
                IF _RequiredScrewingProgram < Config.ScrewingProgramMin THEN
                    Status.Error.Id := UINT#717;
                    RETURN;
                END_IF;
                IF _RequiredScrewingProgram > Config.ScrewingProgramMax THEN
                    Status.Error.Id := UINT#718;
                    RETURN;
                END_IF; 

                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 320;
                END_IF; 

                //Reset results
                IF _progress = 320 THEN
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
                    _progress := 321;
                END_IF;

                //Check if program already set 
                IF _progress = 321 THEN
                    IF _RequiredScrewingProgram = Inputs.ScrewingProgram THEN
                        ScrewingProgram	:= _RequiredScrewingProgram;
                        _progress := 323;
                    ELSE
                        ScrewingProgram	:= BYTE#0;
                        _progress := 322;
                    END_IF;
                END_IF;

                //Set program
                IF _progress = 322 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#622, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#622;
                    END_IF;

                    Outputs.ScrewingProgram := _RequiredScrewingProgram;

                    IF _RequiredScrewingProgram = Inputs.ScrewingProgram THEN
                        ScrewingProgram	:= _RequiredScrewingProgram;
                        THIS.CallTimers(FALSE);
                        _progress := 323;
                    END_IF;
                END_IF;

                
                // wait for screwdriver ready
                IF _progress = 323 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#623, _infoTimer.output, eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#623;
                    END_IF;

                    IF (NOT Inputs.Status.InCycle) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 324;
                    END_IF;
                END_IF;

                // wait for screwdriver ready
                IF _progress = 324 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#624, _infoTimer.output, eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#624;
                    END_IF;

                    IF (Inputs.Status.Ready ) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 325;
                    END_IF;
                END_IF;

                // start screwing cycle 
                IF _progress = 325 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#625, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#625;
                    END_IF;

                    Outputs.Control.StartCycle := TRUE;
                    Outputs.Control.SpindleValidation := TRUE;
                    
                    IF (Inputs.Status.InCycle) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 326;
                    END_IF;
                END_IF;

                // wait for screwing cycle end
                IF _progress = 326 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#626, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#626;
                    END_IF;
                    
                    IF (NOT Inputs.Status.InCycle ) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 327;
                    END_IF;
                END_IF;

                
                // wait for screwing cycle end
                IF _progress = 327 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#627, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#627;
                    END_IF;

                    IF (Inputs.Status.Failed OR Inputs.Status.Passed) THEN
                        Outputs.Control.StartCycle := FALSE;
                        Outputs.Control.SpindleValidation := FALSE;
                        
                        Passed          := Inputs.Status.Passed;
                        Failed          := Inputs.Status.Failed;
                        Torque          := Inputs.Torque;
                        TorqueTrend     := Inputs.TorqueTrend;
                        Angle           := Inputs.Angle;
                        AngleTrend      := Inputs.AngleTrend;
                        THIS.CallTimers(FALSE);
                        _progress := 328;
                    END_IF;
                END_IF;

                // finished
                IF _progress = 328 THEN
                    _progress := 0;
                    StartScrewingTask.DoneWhen(TRUE);
                END_IF;

                StartScrewingTask.ThrowWhen(StartScrewingTask.Duration > Config.ScrewingCycleTimeout, 'Screwing cycle takes too long.');
                Status.Action.Id := TO_UINT(_progress);
                THIS.CallTimers(TRUE);
            END_IF;
            IF StartScrewingTask.DoneReached() THEN
                Status.Action.Id :=  UINT#121;
                Status.Error.Id :=  UINT#0;
            ELSIF StartScrewingTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#820;
                Status.Error.Id  :=  UINT#820;
            ELSIF StartScrewingTask.AbortTriggered() THEN
                Status.Action.Id :=  UINT#821;
                Status.Error.Id  :=  UINT#821;
            END_IF; 
            Messenger.ActivateOnCondition(ULINT#820,StartScrewingTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#821,StartScrewingTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#122,StartScrewingTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StartScrewingTask.RestoreTriggered() AND _progress >= 320 AND _progress <= 339  THEN
                Status.Action.Id :=  UINT#122;
                _progress := 0;
            END_IF;  
            //****************************************

            //***********************************************//
            _data_1[0].%X0         :=  Outputs.Control.CycleBit1;      
            _data_1[0].%X1         :=  Outputs.Control.CycleBit2;      
            _data_1[0].%X2         :=  Outputs.Control.CycleBit4;      
            _data_1[0].%X3         :=  Outputs.Control.SpindleValidation;      
            _data_1[0].%X4         :=  Outputs.Control.ErrorAck;      
            _data_1[0].%X5         :=  Outputs.Control.StartCycle;      
            _data_1[0].%X6         :=  Outputs.Control.Direction;      
            _data_1[0].%X7         :=  Outputs.Control.Reset;      

            returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwId_Output_1_byte_1,_data_1);
            Messenger.ActivateOnCondition(ULINT#715,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#715;
                RETURN;
            END_IF;

            _data_1[0]  :=  Outputs.ScrewingProgram;             

            returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwId_Output_1_byte_2,_data_1);
            Messenger.ActivateOnCondition(ULINT#716,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#716;
                RETURN;
            END_IF;

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
            _progress := 0;
            RestoreTask.DoneWhen(TRUE);
        END_METHOD
    
        METHOD PROTECTED OVERRIDE ManualControl
            _RequiredScrewingProgram := RequiredScrewingProgram;
            
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