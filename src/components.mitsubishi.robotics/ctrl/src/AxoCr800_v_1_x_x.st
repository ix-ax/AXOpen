USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Robotics;
USING AXOpen.Components.Abstractions.Robotics;

NAMESPACE AXOpen.Components.Mitsubishi.Robotics
    {S7.extern=ReadWrite}
    CLASS AxoCr800_v_1_x_x EXTENDS AXOpen.Core.AxoComponent IMPLEMENTS AXOpen.Components.Abstractions.Robotics.IAxoRobotics
        VAR PRIVATE
            _infoTimer :  AXOpen.Timers.OnDelayTimer;
            _infoTime       :   LTIME := LT#2S;
        END_VAR

        VAR PUBLIC //HEADER
                    
        END_VAR

        VAR PUBLIC //Tasks
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AxoTask;            

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start at main#>"}
            StartAtMainTask : AxoTask;            

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start motors and program#>"}
            StartMotorsAndProgramTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Stop movements#>"}
            StopMovementsTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Stop movements and program#>"}
            StopMovementsAndProgramTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start movements with extended parameters#>"}
            StartMovementsTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start movements with extended parameters#>"}
            MovementParameters : AxoRoboticsMovementsParams;
        END_VAR
        
        VAR PUBLIC //CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config  :   AxoCr800Config_v_1_x_x;
        END_VAR

        VAR PUBLIC //STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            RobotStatus         :   AxoRobot_Status;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR

        VAR PUBLIC //Hardware signals
            {#ix-attr:[ComponentDetails("Hardware signals")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            {#ix-attr:[ReadOnly()]}
            Inputs              :   AxoMitsubishiRobotics_State_v_1_x_x;
            {#ix-attr:[ComponentDetails("Hardware signals")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   AxoMitsubishiRobotics_Control_v_1_x_x;
        END_VAR    

        VAR PUBLIC //HardwareDiagnostics
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Hardware diagnostics")]}
            {#ix-set:AttributeName = "<#Update diagnostics#>"}
            HardwareDiagnosticsTask :   AXOpen.Io.AxoHardwareDiagnostics;
        END_VAR

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent : IAxoObject;
                hwID            :   UINT;
                refFieldbus_In  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the robot
                refFieldbus_Out :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the robot
            END_VAR

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                RobotStatus.Error.Id := UINT#700;
                RETURN;
            END_IF;

            THIS.Initialize(parent);
            THIS.Execute(hwID,refFieldbus_In,refFieldbus_Out);
        END_METHOD

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run 
            VAR_INPUT
                parent          :   IAxoContext;
                hwID            :   UINT;
                refFieldbus_In  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the robot
                refFieldbus_Out :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the robot
            END_VAR

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                RobotStatus.Error.Id := UINT#700;
                RETURN;
            END_IF;

            THIS.Initialize(parent);
            THIS.Execute(hwID,refFieldbus_In,refFieldbus_Out);

        END_METHOD

        METHOD PRIVATE Execute 
            VAR_INPUT
                hwID            :   UINT;
                refFieldbus_In  :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the robot
                refFieldbus_Out :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the robot
            END_VAR
            VAR 
                _dword: DWORD;
            END_VAR

            Messenger.ActivateOnCondition(ULINT#701,refFieldbus_In = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#702,refFieldbus_Out = NULL, eAxoMessageCategory#ProgrammingError);
            IF refFieldbus_In = NULL THEN
                RobotStatus.Error.Id := UINT#701;
                RETURN;
            ELSIF refFieldbus_Out = NULL THEN
                RobotStatus.Error.Id := UINT#702;
                RETURN;
            END_IF;
            
            THIS.Open();



            THIS.Open();
            //***********UPDATE**INPUTS******************
            //SYSTEM INPUTS
            Inputs.OperationEnable          := refFieldbus_In^[0].%X0;
            Inputs.AutoEnable               := refFieldbus_In^[0].%X1;
            Inputs.Start                    := refFieldbus_In^[0].%X2;
            Inputs.Stop                     := refFieldbus_In^[0].%X3;
            Inputs.ProgramReset             := refFieldbus_In^[0].%X4;
            Inputs.ErrorReset               := refFieldbus_In^[0].%X5;
            Inputs.CycleStop                := refFieldbus_In^[0].%X6;
            Inputs.ServoOff                 := refFieldbus_In^[0].%X7;

            Inputs.ServoOn                  := refFieldbus_In^[1].%X0;
            Inputs.HighLevelError           := refFieldbus_In^[1].%X1;
            Inputs.LowLevelError            := refFieldbus_In^[1].%X2;
            Inputs.CautionLevelError        := refFieldbus_In^[1].%X3;
            Inputs.EmergencyError           := refFieldbus_In^[1].%X4;
            Inputs.RcReady                  := refFieldbus_In^[1].%X5;
            Inputs.BatteryLow               := refFieldbus_In^[1].%X6;

            //Area/positions flags this  should be obsolete because Zones and InPosition is used as byte below
            Inputs.InArea_1                 := refFieldbus_In^[2].%X0;
            Inputs.InArea_2                 := refFieldbus_In^[2].%X1;
            Inputs.InArea_3                 := refFieldbus_In^[2].%X2;
            Inputs.InArea_4                 := refFieldbus_In^[2].%X3;
            Inputs.InPosition_1             := refFieldbus_In^[2].%X4;
            Inputs.InPosition_2             := refFieldbus_In^[2].%X5;
            Inputs.InPosition_3             := refFieldbus_In^[2].%X6;
            Inputs.InPosition_4             := refFieldbus_In^[2].%X7;

            //Tool signals
            Inputs.Tool_1_Retract           := refFieldbus_In^[3].%X0;
            Inputs.Tool_1_Extend            := refFieldbus_In^[3].%X1;
            Inputs.Tool_2_Retract           := refFieldbus_In^[3].%X2;
            Inputs.Tool_2_Extend            := refFieldbus_In^[3].%X3;
            Inputs.Tool_3_Retract           := refFieldbus_In^[3].%X4;
            Inputs.Tool_3_Extend            := refFieldbus_In^[3].%X5;
            Inputs.Tool_4_Retract           := refFieldbus_In^[3].%X6;
            Inputs.Tool_4_Extend            := refFieldbus_In^[3].%X7;

            // //Safety signals
            // index:=4;
            // Inputs.AutoStop_1               := refFieldbus_In^[4].%X0;
            // Inputs.AutoStop_2               := refFieldbus_In^[4].%X1;
            // Inputs.EmergencyStop_1          := refFieldbus_In^[4].%X2;
            // Inputs.EmergencyStop_2          := refFieldbus_In^[4].%X3;
            // Inputs.GeneralStop_1            := refFieldbus_In^[4].%X4;
            // Inputs.GeneralStop_2            := refFieldbus_In^[4].%X5;
            // Inputs.Enable_1                 := refFieldbus_In^[4].%X6;
            // Inputs.Enable_2                 := refFieldbus_In^[4].%X7;

            Inputs.Zone                     := refFieldbus_In^[5];
            Inputs.InPosition               := refFieldbus_In^[6];

            //Movement parameters
            Inputs.ActionNo                 := refFieldbus_In^[7];
            Inputs.GlobalSpeed              := refFieldbus_In^[8];
            Inputs.ToolNo                   := refFieldbus_In^[9];
            Inputs.WorkobjectNo             := refFieldbus_In^[10];
            Inputs.PointNo                  := refFieldbus_In^[11];

            _dword.%B3                      := refFieldbus_In^[12];
            _dword.%B2                      := refFieldbus_In^[13];
            _dword.%B1                      := refFieldbus_In^[14];
            _dword.%B0                      := refFieldbus_In^[15];
            Inputs.UserSpecSpeed1           := TO_DINT(_dword);

            _dword.%B3                      := refFieldbus_In^[16];
            _dword.%B2                      := refFieldbus_In^[17];
            _dword.%B1                      := refFieldbus_In^[18];
            _dword.%B0                      := refFieldbus_In^[19];
            Inputs.UserSpecSpeed2           := TO_DINT(_dword);

            _dword.%B3                      := refFieldbus_In^[20];
            _dword.%B2                      := refFieldbus_In^[21];
            _dword.%B1                      := refFieldbus_In^[22];
            _dword.%B0                      := refFieldbus_In^[23];
            Inputs.Coordinates.X:= TO_REAL(_dword)/REAL#10000.0-REAL#10000.0;

            _dword.%B3                      := refFieldbus_In^[24];
            _dword.%B2                      := refFieldbus_In^[25];
            _dword.%B1                      := refFieldbus_In^[26];
            _dword.%B0                      := refFieldbus_In^[27];
            Inputs.Coordinates.Y:= TO_REAL(_dword)/REAL#10000.0-REAL#10000.0;

            _dword.%B3                      := refFieldbus_In^[28];
            _dword.%B2                      := refFieldbus_In^[29];
            _dword.%B1                      := refFieldbus_In^[30];
            _dword.%B0                      := refFieldbus_In^[31];
            Inputs.Coordinates.Z:= TO_REAL(_dword)/REAL#10000.0-REAL#10000.0;

            _dword.%B3                      := refFieldbus_In^[32];
            _dword.%B2                      := refFieldbus_In^[33];
            _dword.%B1                      := refFieldbus_In^[34];
            _dword.%B0                      := refFieldbus_In^[35];
            Inputs.Coordinates.Rx:= TO_REAL(_dword)/REAL#10000.0-REAL#360.0;

            _dword.%B3                      := refFieldbus_In^[36];
            _dword.%B2                      := refFieldbus_In^[37];
            _dword.%B1                      := refFieldbus_In^[39];
            _dword.%B0                      := refFieldbus_In^[39];
            Inputs.Coordinates.Ry:= TO_REAL(_dword)/REAL#10000.0-REAL#360.0;

            _dword.%B3                      := refFieldbus_In^[40];
            _dword.%B2                      := refFieldbus_In^[41];
            _dword.%B1                      := refFieldbus_In^[42];
            _dword.%B0                      := refFieldbus_In^[43];
            Inputs.Coordinates.Rz:= TO_REAL(_dword)/REAL#10000.0-REAL#360.0;
            //*******************************************

            _infoTime := Config.InfoTime;

            //*************INITIALIZATION*************
            RestoreTask.Initialize(THIS);
            StartAtMainTask.Initialize(THIS);
            StartMotorsAndProgramTask.Initialize(THIS);
            StopMovementsTask.Initialize(THIS);
            StopMovementsAndProgramTask.Initialize(THIS);
            StartMovementsTask.Initialize(THIS);
            HardwareDiagnosticsTask.Initialize(THIS);
            //****************************************
            //********************Diagnostics*********        
            HardwareDiagnosticsTask.Run(hwID);
            //****************************************

            //*************RESTORE********************
            RestoreTask.IsDisabled := FALSE;
            IF RestoreTask.Execute() THEN
                THIS.Restore();
            END_IF;
            //****************************************

            //*************StartAtMainTask************
            StartAtMainTask.IsDisabled := FALSE;
            IF StartAtMainTask.Execute() THEN
                ;
            END_IF;


            //****************************************


            //***********UPDATE**OUTPUTS*****************
            //SYSTEM OUTPUTS
            refFieldbus_Out^[0].%X0	        := Outputs.OperationEnable;    
            refFieldbus_Out^[0].%X1	        := Outputs.AutoEnable;    
            refFieldbus_Out^[0].%X2         := Outputs.Start; 
            refFieldbus_Out^[0].%X3         := Outputs.Stop;
            refFieldbus_Out^[0].%X4         := Outputs.ProgramReset;   
            refFieldbus_Out^[0].%X5         := Outputs.ErrorReset; 
            refFieldbus_Out^[0].%X6         := Outputs.CycleStop;    
            refFieldbus_Out^[0].%X7         := Outputs.ServoOff; 

            refFieldbus_Out^[1].%X0 	    := Outputs.ServoOn;    
            refFieldbus_Out^[1].%X1 	    := Outputs.GeneralPurposeReset;    
            refFieldbus_Out^[1].%X2 	    := Outputs.OverideSpecifications;    
                
            //Tool signals
            refFieldbus_Out^[2].%X0 	    := Outputs.Tool_1_Retract;    
            refFieldbus_Out^[2].%X1 	    := Outputs.Tool_1_Extend;    
            refFieldbus_Out^[2].%X2	        := Outputs.Tool_2_Retract;    
            refFieldbus_Out^[2].%X3	        := Outputs.Tool_2_Extend;    
            refFieldbus_Out^[2].%X4	        := Outputs.Tool_3_Retract;    
            refFieldbus_Out^[2].%X5	        := Outputs.Tool_3_Extend;    
            refFieldbus_Out^[2].%X6 	    := Outputs.Tool_4_Retract;    
            refFieldbus_Out^[2].%X7	        := Outputs.Tool_4_Extend;    

            //master mode  such as manual/auto ....
            refFieldbus_Out^[3]             := Outputs.MasterMode;

            //zone
            refFieldbus_Out^[5]             := Outputs.Zone;

            //position
            refFieldbus_Out^[6]             := Outputs.InPosition;

            //Movement parameters
            refFieldbus_Out^[7]             := Outputs.ActionNo;
            refFieldbus_Out^[8]             := Outputs.GlobalSpeed;
            refFieldbus_Out^[9]             := Outputs.ToolNo;
            refFieldbus_Out^[10]            := Outputs.WorkobjectNo;
            refFieldbus_Out^[11]            := Outputs.PointNo;

            _dword                          := TO_DWORD(Outputs.UserSpecSpeed1);
            refFieldbus_Out^[12]            := _dword.%B3;
            refFieldbus_Out^[13]            := _dword.%B2;
            refFieldbus_Out^[14]            := _dword.%B1;
            refFieldbus_Out^[15]            := _dword.%B0;

            _dword                          := TO_DWORD(Outputs.UserSpecSpeed2);
            refFieldbus_Out^[16]            := _dword.%B3;
            refFieldbus_Out^[18]            := _dword.%B2;
            refFieldbus_Out^[18]            := _dword.%B1;
            refFieldbus_Out^[19]            := _dword.%B0;

            ////Coordinates
            _dword                          := TO_DWORD((Outputs.Coordinates.X +REAL#10000.0)*REAL#10000.0);
            refFieldbus_Out^[20]            := _dword.%B3;
            refFieldbus_Out^[21]            := _dword.%B2;
            refFieldbus_Out^[22]            := _dword.%B1;
            refFieldbus_Out^[23]            := _dword.%B0;

            _dword                          := TO_DWORD((Outputs.Coordinates.Y +REAL#10000.0)*REAL#10000.0);
            refFieldbus_Out^[24]            := _dword.%B3;
            refFieldbus_Out^[25]            := _dword.%B2;
            refFieldbus_Out^[26]            := _dword.%B1;
            refFieldbus_Out^[27]            := _dword.%B0;

            _dword                          := TO_DWORD((Outputs.Coordinates.Z +REAL#10000.0)*REAL#10000.0);
            refFieldbus_Out^[28]            := _dword.%B3;
            refFieldbus_Out^[29]            := _dword.%B2;
            refFieldbus_Out^[30]            := _dword.%B1;
            refFieldbus_Out^[31]            := _dword.%B0;

            _dword                          := TO_DWORD((Outputs.Coordinates.Rx +REAL#360.0)*REAL#10000.0);
            refFieldbus_Out^[32]            := _dword.%B3;
            refFieldbus_Out^[33]            := _dword.%B2;
            refFieldbus_Out^[34]            := _dword.%B1;
            refFieldbus_Out^[35]            := _dword.%B0;

            _dword                          := TO_DWORD((Outputs.Coordinates.Ry +REAL#360.0)*REAL#10000.0);
            refFieldbus_Out^[36]            := _dword.%B3;
            refFieldbus_Out^[37]            := _dword.%B2;
            refFieldbus_Out^[38]            := _dword.%B1;
            refFieldbus_Out^[39]            := _dword.%B0;

            _dword                          := TO_DWORD((Outputs.Coordinates.Rz +REAL#360.0)*REAL#10000.0);
            refFieldbus_Out^[40]            := _dword.%B3;
            refFieldbus_Out^[41]            := _dword.%B2;
            refFieldbus_Out^[42]            := _dword.%B1;
            refFieldbus_Out^[43]            := _dword.%B0;
            //*******************************************
            THIS.Close();
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            THIS._isManuallyControllable := true;
        END_METHOD
        
        ///<summary>
        /// Restores this component into intial state.        
        ///</summary>
        METHOD PUBLIC OVERRIDE Restore

            ;
        END_METHOD        
    
        METHOD PUBLIC StartAtMain : IAxoTaskState
            ;
        END_METHOD
    
        METHOD PUBLIC StartMotorsAndProgram : IAxoTaskState
            ;
        END_METHOD
    
        METHOD PUBLIC StartMovements : IAxoTaskState
            VAR_IN_OUT
                inData : AxoRoboticsMovementsParams;
            END_VAR

            ;
        END_METHOD
    
        METHOD PUBLIC StopMovements : IAxoTaskState
            VAR_INPUT
                inStopType : eAxoRoboticsStopType;
            END_VAR

            ;
        END_METHOD
    
        METHOD PUBLIC StopMovementsAndProgram : IAxoTaskState
            VAR_INPUT
                inStopType : eAxoRoboticsStopType;
            END_VAR

            ;
        END_METHOD
    

    END_CLASS
END_NAMESPACE
