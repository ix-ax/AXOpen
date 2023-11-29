USING AXOpen.Core;
USING AXOpen.Messaging.Static;
USING AXOpen.Messaging;
USING System.Strings;

NAMESPACE AXOpen.Components.Drives
    {#ix-attr:[Container(Layout.Wrap)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC ABSTRACT AxoDrive EXTENDS AXOpen.Core.AxoComponent IMPLEMENTS AXOpen.Components.Abstractions.Drives.IAxoDrive
        VAR PUBLIC  //HEADER
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Drive state#>"}
            DriveState          :   AXOpen.Components.Drives.eAxoDriveState;
            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Position#>"}
            ActualPosition          :   LREAL;
            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Velocity#>"}
            ActualVelocity          :   LREAL;
            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Torque#>"}
            ActualTorque          :   LREAL;
        END_VAR

        VAR PUBLIC //TASKS
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
            //***********Power********************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Power task#>"}
            AxoPower_Task                           :   AXOpen.Components.Drives.Axo_Power;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Power status#>"}
            {#ix-attr:[ReadOnly()]}
            AxoPower_Status                         :   BOOL;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Power valid#>"}
            {#ix-attr:[ReadOnly()]}
            AxoPower_Valid                          :   BOOL;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Power error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoPower_Error                          :   BOOL;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Power error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoPower_ErrorID                        :   WORD;
            //***********Stop*********************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Stop task#>"}
            AxoStop_Task                            :   AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Stop decceleration#>"}
            AxoStop_Deceleration                    :   LREAL   :=  1.0;                     
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Stop jerk#>"}
            AxoStop_Jerk                            :   LREAL   :=  1.0;                      
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Stop done#>"}
            {#ix-attr:[ReadOnly()]}
            AxoStop_Done                            :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Stop busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoStop_Busy                            :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Stop active#>"}
            {#ix-attr:[ReadOnly()]}
            AxoStop_Active                          :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Stop aborted#>"}
            {#ix-attr:[ReadOnly()]}
            AxoStop_CommandAborted                  :   BOOL;                                 
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Stop error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoStop_Error                           :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Stop error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoStop_ErrorID                         :   WORD;                   
            //***********Halt*********************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Halt task#>"}
            AxoHalt_Task                            :   AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Halt decceleration#>"}
            AxoHalt_Deceleration                    :   LREAL   :=  1.0;                     
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Halt decceleration#>"}
            AxoHalt_Jerk                            :   LREAL   :=  1.0;     
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Halt done#>"}
            {#ix-attr:[ReadOnly()]}
            AxoHalt_Done                            :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Halt busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoHalt_Busy                            :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Halt active#>"}
            {#ix-attr:[ReadOnly()]}
            AxoHalt_Active                          :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Halt aborted#>"}
            {#ix-attr:[ReadOnly()]}
            AxoHalt_CommandAborted                  :   BOOL;                                 
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Halt error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoHalt_Error                           :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Halt error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoHalt_ErrorID                         :   WORD;                   
            //***********Home*********************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Homming task#>"}
            AxoHome_Task                            :   AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Homming position#>"}
            AxoHome_Position                        :   LREAL   :=  0.0;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Homming mode#>"}
            AxoHome_HommingMode                     :   INT     :=  0;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Homming velocity#>"}
            AxoHome_Velocity                        :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Homming acceleration#>"}
            AxoHome_Acceleration                    :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Homming decceleration#>"}
            AxoHome_Deceleration                    :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Home status#>"}
            {#ix-attr:[ReadOnly()]}
            AxoHome_Status                          :   BOOL;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Home valid#>"}
            {#ix-attr:[ReadOnly()]}
            AxoHome_Valid                           :   BOOL;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Home error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoHome_Error                           :   BOOL;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Home error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoHome_ErrorID                         :   WORD;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Home done#>"}
            {#ix-attr:[ReadOnly()]}
            AxoHome_Done                            :   BOOL;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Home busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoHome_Busy                            :   BOOL;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Home active#>"}
            {#ix-attr:[ReadOnly()]}
            AxoHome_Active                          :   BOOL;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Home aborted#>"}
            {#ix-attr:[ReadOnly()]}
            AxoHome_CommandAborted                  :   BOOL;
            //***********MoveAbsolute*************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move absolute task#>"}
            AxoMoveAbsolute_Task                    :   AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move absolute continous update#>"}
            AxoMoveAbsolute_ContinuousUpdate        :   BOOL;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move absolute position#>"}
            AxoMoveAbsolute_Position                :   LREAL   :=  0.0;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move absolute velocity#>"}
            AxoMoveAbsolute_Velocity                :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move absolute acceleration#>"}
            AxoMoveAbsolute_Acceleration            :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move absolute decceleration#>"}
            AxoMoveAbsolute_Deceleration            :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move absolute jerk#>"}
            AxoMoveAbsolute_Jerk                    :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move absolute direction#>"}
            AxoMoveAbsolute_Direction               :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection    := AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move absolute done#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveAbsolute_Done                    :   BOOL;                   
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move absolute busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveAbsolute_Busy                    :   BOOL;                   
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move absolute active#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveAbsolute_Active                  :   BOOL;                   
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move absolute aborted#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveAbsolute_CommandAborted          :   BOOL;                                 
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move absolute error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveAbsolute_Error                   :   BOOL;                   
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move absolute error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveAbsolute_ErrorID                 :   WORD;                   
            //***********MoveRelative*************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move relative task#>"}
            AxoMoveRelative_Task                    :   AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move relative continuous update#>"}
            AxoMoveRelative_ContinuousUpdate        :   BOOL;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move relative distance#>"}
            AxoMoveRelative_Distance                :   LREAL   :=  0.0;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move relative velocity#>"}
            AxoMoveRelative_Velocity                :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move relative acceleration#>"}
            AxoMoveRelative_Acceleration            :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move relative deceleration#>"}
            AxoMoveRelative_Deceleration            :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move relative jerk#>"}
            AxoMoveRelative_Jerk                    :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move relative done#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveRelative_Done                    :   BOOL;                   
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move relative busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveRelative_Busy                    :   BOOL;                   
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move relative active#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveRelative_Active                  :   BOOL;                   
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move relative aborted#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveRelative_CommandAborted          :   BOOL;                                 
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move relative error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveRelative_Error                   :   BOOL;                   
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move relative error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveRelative_ErrorID                 :   WORD;                   
            //***********MoveAdditive*************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move additive task#>"}
            AxoMoveAdditive_Task                    :   AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move additive continuous update#>"}
            AxoMoveAdditive_ContinuousUpdate        :   BOOL;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move additive distance#>"}
            AxoMoveAdditive_Distance                :   LREAL   :=  0.0;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move additive velocity#>"}
            AxoMoveAdditive_Velocity                :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move additive acceleration#>"}
            AxoMoveAdditive_Acceleration            :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move additive deceleration#>"}
            AxoMoveAdditive_Deceleration            :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move additive jerk#>"}
            AxoMoveAdditive_Jerk                    :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move additive done#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveAdditive_Done                    :   BOOL;                   
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move additive busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveAdditive_Busy                    :   BOOL;                   
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move additive active#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveAdditive_Active                  :   BOOL;                   
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move additive aborted#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveAdditive_CommandAborted          :   BOOL;                                 
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move additive error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveAdditive_Error                   :   BOOL;                   
            {#ix-attr:[ComponentDetails("Discrete motion")]}
            {#ix-set:AttributeName = "<#Move additive error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveAdditive_ErrorID                 :   WORD;                   
            //***********MoveVelocity*************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move velocity task#>"}
            AxoMoveVelocity_Task                    :   AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move velocity continuous update#>"}
            AxoMoveVelocity_ContinuousUpdate        :   BOOL;
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move velocity velocity#>"}
            AxoMoveVelocity_Velocity                :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move velocity acceleration#>"}
            AxoMoveVelocity_Acceleration            :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move velocity deceleration#>"}
            AxoMoveVelocity_Deceleration            :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move velocity jerk#>"}
            AxoMoveVelocity_Jerk                    :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move velocity #>"}
            AxoMoveVelocity_Direction               :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection    := AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection;
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move velocity in velocity#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveVelocity_InVelocity              :   BOOL;                   
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move velocity busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveVelocity_Busy                    :   BOOL;                   
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move velocity active#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveVelocity_Active                  :   BOOL;                   
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move velocity aborted#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveVelocity_CommandAborted          :   BOOL;                                 
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move velocity error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveVelocity_Error                   :   BOOL;                   
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move velocity error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoMoveVelocity_ErrorID                 :   WORD;                   
            //***********TorqueControl************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move torque task#>"}
            AxoTorqueControl_Task                   :   AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move torque continuous update#>"}
            AxoTorqueControl_ContinuousUpdate       :   BOOL;
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move torque torque#>"}
            AxoTorqueControl_Torque                 :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move torque torque ramp#>"}
            AxoTorqueControl_TorqueRamp             :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move torque velocity#>"}
            AxoTorqueControl_Velocity               :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move torque acceleration#>"}
            AxoTorqueControl_Acceleration           :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move torque deceleration#>"}
            AxoTorqueControl_Deceleration           :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move torque jerk#>"}
            AxoTorqueControl_Jerk                   :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move torque direction#>"}
            AxoTorqueControl_Direction              :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection    := AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection;
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move torque in torque#>"}
            {#ix-attr:[ReadOnly()]}
            AxoTorqueControl_InTorque               :   BOOL;                   
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move torque busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoTorqueControl_Busy                   :   BOOL;                   
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move torque active#>"}
            {#ix-attr:[ReadOnly()]}
            AxoTorqueControl_Active                 :   BOOL;                   
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move torque aborted#>"}
            {#ix-attr:[ReadOnly()]}
            AxoTorqueControl_CommandAborted         :   BOOL;                                 
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move torque error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoTorqueControl_Error                  :   BOOL;                   
            {#ix-attr:[ComponentDetails("Continuous motion")]}
            {#ix-set:AttributeName = "<#Move torque error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoTorqueControl_ErrorID                :   WORD;                   
            //***********SetPosition**************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set position task#>"}
            AxoSetPosition_Task                     :   AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set position position#>"}
            AxoSetPosition_Position                 :   LREAL   :=  1.0;                    
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set position relative#>"}
            AxoSetPosition_Relative                 :   BOOL;                    
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set position execution mode#>"}
            AxoSetPosition_ExecutionMode            :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode :=  AXOpen.Components.Abstractions.Drives.eAxoExecutionMode#Immediately;                  
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set position done#>"}
            {#ix-attr:[ReadOnly()]}
            AxoSetPosition_Done                     :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set position busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoSetPosition_Busy                     :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set position error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoSetPosition_Error                    :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set position error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoSetPosition_ErrorID                  :   WORD;                   
            //***********SetOverride**************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set override task#>"}
            AxoSetOverride_Task                     :   AXOpen.Core.AxoToggleTask;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set override velocity factor#>"}
            AxoSetOverride_VelFactor                :   LREAL   :=  1.0;                     
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set override acceleration factor#>"}
            AxoSetOverride_AccFactor                :   LREAL   :=  1.0;                     
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set override jerk factor#>"}
            AxoSetOverride_JerkFactor               :   LREAL   :=  1.0;        
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set override enabled#>"}
            {#ix-attr:[ReadOnly()]}
            AxoSetOverride_Enabled                  :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set override busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoSetOverride_Busy                     :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set override error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoSetOverride_Error                    :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Set override error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoSetOverride_ErrorID                  :   WORD;          
            //***********ReadParameter************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Read parameter task#>"}
            AxoReadParameter_Task                   :   AXOpen.Core.AxoToggleTask;
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Read parameter number#>"}
            AxoReadParameter_ParameterNumber        :   DINT;
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Read parameter valid#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadParameter_Valid                  :   BOOL;                   
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Read parameter busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadParameter_Busy                   :   BOOL;                   
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Read parameter error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadParameter_Error                  :   BOOL;                   
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Read parameter error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadParameter_ErrorID                :   WORD;          
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Read parameter value#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadParameter_Value                  :   DINT;          
            //***********ReadRealParameter************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Read real parameter task#>"}
            AxoReadRealParameter_Task               :   AXOpen.Core.AxoToggleTask;
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Read real parameter number#>"}
            AxoReadRealParameter_ParameterNumber    :   DINT;
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Read real parameter valid#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadRealParameter_Valid              :   BOOL;                   
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Read real parameter busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadRealParameter_Busy               :   BOOL;                   
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Read real parameter error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadRealParameter_Error              :   BOOL;                   
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Read real parameter error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadRealParameter_ErrorID            :   WORD;          
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Read real parameter value#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadRealParameter_Value              :   REAL;          
            //***********ReadBoolParameter********************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Read bool parameter task#>"}
            AxoReadBoolParameter_Task               :   AXOpen.Core.AxoToggleTask;
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Read bool parameter number#>"}
            AxoReadBoolParameter_ParameterNumber    :   DINT;
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Read bool parameter valid#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadBoolParameter_Valid              :   BOOL;                   
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Read bool parameter busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadBoolParameter_Busy               :   BOOL;                   
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Read bool parameter error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadBoolParameter_Error              :   BOOL;                   
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Read bool parameter error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadBoolParameter_ErrorID            :   WORD;          
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Read bool parameter value#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadBoolParameter_Value              :   BOOL;          
            //***********WriteParameter***********************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write parameter task#>"}
            AxoWriteParameter_Task                  :   AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write parameter number#>"}
            AxoWriteParameter_ParameterNumber       :   DINT;                    
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write parameter value#>"}
            AxoWriteParameter_Value                 :   DINT;                     
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write parameter execution mode#>"}
            AxoWriteParameter_ExecutionMode         :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode :=  AXOpen.Components.Abstractions.Drives.eAxoExecutionMode#Immediately;                  
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write parameter done#>"}
            {#ix-attr:[ReadOnly()]}
            AxoWriteParameter_Done                  :   BOOL;                   
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write parameter busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoWriteParameter_Busy                  :   BOOL;                   
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write parameter error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoWriteParameter_Error                 :   BOOL;                   
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write parameter error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoWriteParameter_ErrorID               :   WORD;          
            //***********WriteRealParameter*******************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write real parameter task#>"}
            AxoWriteRealParameter_Task              :   AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write real parameter number#>"}
            AxoWriteRealParameter_ParameterNumber   :   DINT;                    
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write real parameter value#>"}
            AxoWriteRealParameter_Value             :   REAL;                     
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write real parameter execution mode#>"}
            AxoWriteRealParameter_ExecutionMode     :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode :=  AXOpen.Components.Abstractions.Drives.eAxoExecutionMode#Immediately;                  
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write real parameter done#>"}
            {#ix-attr:[ReadOnly()]}
            AxoWriteRealParameter_Done              :   BOOL;                   
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write real parameter busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoWriteRealParameter_Busy              :   BOOL;                   
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write real parameter error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoWriteRealParameter_Error             :   BOOL;                   
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write real parameter error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoWriteRealParameter_ErrorID           :   WORD;          
            //***********WriteBoolParameter*******************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write bool parameter task#>"}
            AxoWriteBoolParameter_Task              :   AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write bool parameter number#>"}
            AxoWriteBoolParameter_ParameterNumber   :   DINT;                    
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write bool parameter value#>"}
            AxoWriteBoolParameter_Value             :   BOOL;                     
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write bool parameter execution mode#>"}
            AxoWriteBoolParameter_ExecutionMode     :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode :=  AXOpen.Components.Abstractions.Drives.eAxoExecutionMode#Immediately;                  
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write bool parameter done#>"}
            {#ix-attr:[ReadOnly()]}
            AxoWriteBoolParameter_Done              :   BOOL;                   
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write bool parameter busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoWriteBoolParameter_Busy              :   BOOL;                   
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write bool parameter error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoWriteBoolParameter_Error             :   BOOL;                   
            {#ix-attr:[ComponentDetails("Parametrization")]}
            {#ix-set:AttributeName = "<#Write bool parameter error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoWriteBoolParameter_ErrorID           :   WORD;          
            //***********ReadDigitalInput*********************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Drive IO")]}
            {#ix-set:AttributeName = "<#Read digital input task#>"}
            AxoReadDigitalInput_Task                :   AXOpen.Core.AxoToggleTask;
            {#ix-attr:[ComponentDetails("Drive IO")]}
            {#ix-set:AttributeName = "<#Read digital input number#>"}
            AxoReadDigitalInput_InputNumber         :   INT;
            {#ix-attr:[ComponentDetails("Drive IO")]}
            {#ix-set:AttributeName = "<#Read digital input valid#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadDigitalInput_Valid               :   BOOL;                   
            {#ix-attr:[ComponentDetails("Drive IO")]}
            {#ix-set:AttributeName = "<#Read digital input busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadDigitalInput_Busy                :   BOOL;                   
            {#ix-attr:[ComponentDetails("Drive IO")]}
            {#ix-set:AttributeName = "<#Read digital input error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadDigitalInput_Error               :   BOOL;                   
            {#ix-attr:[ComponentDetails("Drive IO")]}
            {#ix-set:AttributeName = "<#Read digital input error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadDigitalInput_ErrorID             :   WORD;          
            {#ix-attr:[ComponentDetails("Drive IO")]}
            {#ix-set:AttributeName = "<#Read digital input value#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadDigitalInput_Value               :   BOOL;          
            //***********ReadDigitalOutput********************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Drive IO")]}
            {#ix-set:AttributeName = "<#Read digital output task#>"}
            AxoReadDigitalOutput_Task               :   AXOpen.Core.AxoToggleTask;
            {#ix-attr:[ComponentDetails("Drive IO")]}
            {#ix-set:AttributeName = "<#Read digital output number#>"}
            AxoReadDigitalOutput_OutputNumber       :   INT;
            {#ix-attr:[ComponentDetails("Drive IO")]}
            {#ix-set:AttributeName = "<#Read digital output valid#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadDigitalOutput_Valid              :   BOOL;                   
            {#ix-attr:[ComponentDetails("Drive IO")]}
            {#ix-set:AttributeName = "<#Read digital output busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadDigitalOutput_Busy               :   BOOL;                   
            {#ix-attr:[ComponentDetails("Drive IO")]}
            {#ix-set:AttributeName = "<#Read digital output error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadDigitalOutput_Error              :   BOOL;                   
            {#ix-attr:[ComponentDetails("Drive IO")]}
            {#ix-set:AttributeName = "<#Read digital output error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadDigitalOutput_ErrorID            :   WORD;          
            {#ix-attr:[ComponentDetails("Drive IO")]}
            {#ix-set:AttributeName = "<#Read digital output value#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadDigitalOutput_Value              :   BOOL;          
            //***********WriteDigitalOutput*******************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Drive IO")]}
            {#ix-set:AttributeName = "<#Write digital output task#>"}
            AxoWriteDigitalOutput_Task              :   AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Drive IO")]}
            {#ix-set:AttributeName = "<#Write digital output number#>"}
            AxoWriteDigitalOutput_OutputNumber      :   INT;
            {#ix-attr:[ComponentDetails("Drive IO")]}
            {#ix-set:AttributeName = "<#Write digital output value#>"}
            AxoWriteDigitalOutput_Value             :   BOOL;                     
            {#ix-attr:[ComponentDetails("Drive IO")]}
            {#ix-set:AttributeName = "<#Write digital output execution mode#>"}
            AxoWriteDigitalOutput_ExecutionMode     :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode :=  AXOpen.Components.Abstractions.Drives.eAxoExecutionMode#Immediately;                  
            {#ix-attr:[ComponentDetails("Drive IO")]}
            {#ix-set:AttributeName = "<#Write digital output done#>"}
            {#ix-attr:[ReadOnly()]}
            AxoWriteDigitalOutput_Done              :   BOOL;                   
            {#ix-attr:[ComponentDetails("Drive IO")]}
            {#ix-set:AttributeName = "<#Write digital output busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoWriteDigitalOutput_Busy              :   BOOL;                   
            {#ix-attr:[ComponentDetails("Drive IO")]}
            {#ix-set:AttributeName = "<#Write digital output error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoWriteDigitalOutput_Error             :   BOOL;                   
            {#ix-attr:[ComponentDetails("Drive IO")]}
            {#ix-set:AttributeName = "<#Write digital output error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoWriteDigitalOutput_ErrorID           :   WORD;          
            //***********ReadActualPosition*******************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read actual position task#>"}
            AxoReadActualPosition_Task              :   AXOpen.Core.AxoToggleTask;
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read actual position valid#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadActualPosition_Valid             :   BOOL;                   
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read actual position busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadActualPosition_Busy              :   BOOL;                   
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read actual position error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadActualPosition_Error             :   BOOL;                   
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read actual position error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadActualPosition_ErrorID           :   WORD;          
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read actual position value#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadActualPosition_Value             :   LREAL;          
            //***********ReadActualVelocity*******************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read actual velocity task#>"}
            AxoReadActualVelocity_Task              :   AXOpen.Core.AxoToggleTask;
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read actual velocity valid#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadActualVelocity_Valid             :   BOOL;                   
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read actual velocity busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadActualVelocity_Busy              :   BOOL;                   
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read actual velocity error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadActualVelocity_Error             :   BOOL;                   
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read actual velocity error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadActualVelocity_ErrorID           :   WORD;          
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read actual velocity value#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadActualVelocity_Value             :   LREAL;          
            //***********ReadActualTorque*********************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read actual torque task#>"}
            AxoReadActualTorque_Task                :   AXOpen.Core.AxoToggleTask;
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read actual torque valid#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadActualTorque_Valid               :   BOOL;                   
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read actual torque busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadActualTorque_Busy                :   BOOL;                   
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read actual torque error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadActualTorque_Error               :   BOOL;                   
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read actual torque error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadActualTorque_ErrorID             :   WORD;          
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read actual torque value#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadActualTorque_Value               :   LREAL;          
            //***********ReadStatus***************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read status task#>"}
            AxoReadStatus_Task                      :   AXOpen.Core.AxoToggleTask;
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read status valid#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadStatus_Valid                     :   BOOL;                     
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read status busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadStatus_Busy                      :   BOOL;                     
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read status error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadStatus_Error                     :   BOOL;                     
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read status error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadStatus_ErrorID                   :   WORD;                     
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read status error stop#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadStatus_ErrorStop                 :   BOOL;                     
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read status disabled#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadStatus_Disabled                  :   BOOL;                     
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read status stopping#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadStatus_Stopping                  :   BOOL;                     
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read status homming#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadStatus_Homing                    :   BOOL;                     
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read status standstill#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadStatus_Standstill                :   BOOL;                     
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read status discrete motion#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadStatus_DiscreteMotion            :   BOOL;                     
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read status continuous motion#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadStatus_ContinuousMotion          :   BOOL;                     
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read status synchronized motion#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadStatus_SynchronizedMotion        :   BOOL;                       
            //***********ReadMotionState**********************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read motion state task#>"}
            AxoReadMotionState_Task                 :   AXOpen.Core.AxoToggleTask;
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read motion state source#>"}
            AxoReadMotionState_Source               :   AXOpen.Components.Abstractions.Drives.eAxoSource;
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read motion state valid#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadMotionState_Valid                :   BOOL;                     
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read motion state busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadMotionState_Busy                 :   BOOL;                     
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read motion state error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadMotionState_Error                :   BOOL;                     
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read motion state error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadMotionState_ErrorID              :   WORD;                     
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read motion state constant velocity#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadMotionState_ConstantVelocity     :   BOOL;                     
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read motion state accelerating#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadMotionState_Accelerating         :   BOOL;                      
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read motion state decelerating#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadMotionState_Decelerating         :   BOOL;                      
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read motion state direction positive#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadMotionState_DirectionPositive    :   BOOL;                      
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read motion state direction negative#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadMotionState_DirectionNegative    :   BOOL;                      
            //***********ReadAxisInfo*************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read axis info task#>"}
            AxoReadAxisInfo_Task                    :   AXOpen.Core.AxoToggleTask;
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read axis info valid#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadAxisInfo_Valid                   :   BOOL;                      
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read axis info busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadAxisInfo_Busy                    :   BOOL;                      
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read axis info error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadAxisInfo_Error                   :   BOOL;                      
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read axis info error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadAxisInfo_ErrorID                 :   WORD;                      
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read axis info home absolute switch#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadAxisInfo_HomeAbsSwitch           :   BOOL;                      
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read axis info limit switch positive#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadAxisInfo_LimitSwitchPos          :   BOOL;                      
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Read axis info limit switch negative#>"}
            AxoReadAxisInfo_LimitSwitchNeg          :   BOOL;                      
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Read axis info simulation#>"}
            AxoReadAxisInfo_Simulation              :   BOOL;                      
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Read axis info communication ready#>"}
            AxoReadAxisInfo_CommunicationReady      :   BOOL;                      
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Read axis info ready for power on#>"}
            AxoReadAxisInfo_ReadyForPowerOn         :   BOOL;                      
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Read axis info power on#>"}
            AxoReadAxisInfo_PowerOn                 :   BOOL;                      
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Read axis info is homed#>"}
            AxoReadAxisInfo_IsHomed                 :   BOOL;                      
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Read axis info warning#>"}
            AxoReadAxisInfo_AxisWarning             :   BOOL;                      
            //***********ReadAxisError************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read axis error task#>"}
            AxoReadAxisError_Task                   :   AXOpen.Core.AxoToggleTask;
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read axis error valid#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadAxisError_Valid                  :   BOOL;                      
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read axis error busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadAxisError_Busy                   :   BOOL;                      
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read axis error error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadAxisError_Error                  :   BOOL;                      
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read axis error error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadAxisError_ErrorID                :   WORD;         
            {#ix-attr:[ComponentDetails("Read values")]}
            {#ix-set:AttributeName = "<#Read axis error axis error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReadAxisError_AxisErrorID            :   DWORD;
            //***********Reset********************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Reset task#>"}
            AxoReset_Task                           :   AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Reset done#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReset_Done                           :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Reset busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReset_Busy                           :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Reset error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReset_Error                          :   BOOL;                   
            {#ix-attr:[ComponentDetails("Administrative")]}
            {#ix-set:AttributeName = "<#Reset error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoReset_ErrorID                        :   WORD;    
            //***********Jog**********************************
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Jog")]}
            {#ix-set:AttributeName = "<#Jog positive#>"}
            AxoJogPositive                          :   AXOpen.Components.Drives.AxoMotionJogTask;
            {#ix-attr:[ComponentDetails("Jog")]}
            {#ix-set:AttributeName = "<#Jog negative#>"}
            AxoJogNegative                          :   AXOpen.Components.Drives.AxoMotionJogTask;
            {#ix-attr:[ComponentDetails("Jog")]}
            {#ix-set:AttributeName = "<#Jog velocity#>"}
            AxoJog_Velocity                         :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Jog")]}
            {#ix-set:AttributeName = "<#Jog acceleration#>"}
            AxoJog_Acceleration                     :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Jog")]}
            {#ix-set:AttributeName = "<#Jog deceleration#>"}
            AxoJog_Deceleration                     :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Jog")]}
            {#ix-set:AttributeName = "<#Jog jerk#>"}
            AxoJog_Jerk                             :   LREAL   :=  1.0;
            {#ix-attr:[ComponentDetails("Jog")]}
            {#ix-set:AttributeName = "<#Jog direction#>"}
            AxoJog_Direction                        :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection    := AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection;
            {#ix-attr:[ComponentDetails("Jog")]}
            {#ix-set:AttributeName = "<#Jog velocity#>"}
            {#ix-attr:[ReadOnly()]}
            AxoJogInVelocity                        :   BOOL;
            {#ix-attr:[ComponentDetails("Jog")]}
            {#ix-set:AttributeName = "<#Jog active#>"}
            {#ix-attr:[ReadOnly()]}
            AxoJog_Active                           :   BOOL;
            {#ix-attr:[ComponentDetails("Jog")]}
            {#ix-set:AttributeName = "<#Jog done#>"}
            {#ix-attr:[ReadOnly()]}
            AxoJog_Done                             :   BOOL;                   
            {#ix-attr:[ComponentDetails("Jog")]}
            {#ix-set:AttributeName = "<#Jog busy#>"}
            {#ix-attr:[ReadOnly()]}
            AxoJog_Busy                             :   BOOL;                   
            {#ix-attr:[ComponentDetails("Jog")]}
            {#ix-set:AttributeName = "<#Jog error#>"}
            {#ix-attr:[ReadOnly()]}
            AxoJog_Error                            :   BOOL;                   
            {#ix-attr:[ComponentDetails("Jog")]}
            {#ix-set:AttributeName = "<#Jog error ID#>"}
            {#ix-attr:[ReadOnly()]}
            AxoJog_ErrorID                          :   WORD;    
            {#ix-attr:[ComponentDetails("Jog")]}
            {#ix-set:AttributeName = "<#Jog aborted#>"}
            {#ix-attr:[ReadOnly()]}
            AxoJog_CommandAborted                   :   BOOL;                                 
        END_VAR

        VAR PUBLIC //CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            DriveConfig         :   AxoDrive_Config;
        END_VAR

        VAR PUBLIC //STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            DriveStatus         :   AxoDrive_Status;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR
        
        VAR PRIVATE
            _AxisRef                                :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
            _movementDisabled                       :   BOOL;
            _messageCode                            :   ULINT;
            _lastMessageCode                        :   ULINT;
            _disabledDuringMovement                 :   BOOL;
            _error                                  :   BOOL;
            _warning                                :   BOOL;
            _category                               :   AXOpen.Messaging.eAxoMessageCategory;
            _movementInPositiveDirection            :   BOOL;
            _movementInNegativeDirection            :   BOOL;
            //***********Stop*********************************
            _AxoStop_Deceleration                   :   LREAL;                     
            _AxoStop_Jerk                           :   LREAL;                      
            //***********Halt*********************************
            _AxoHalt_Deceleration                   :   LREAL;                     
            _AxoHalt_Jerk                           :   LREAL;     
            //***********Home*********************************
            _AxoHome_Position                       :   LREAL;
            _AxoHome_HommingMode                    :   INT;
            _AxoHome_Velocity                       :   LREAL;
            _AxoHome_Acceleration                   :   LREAL;
            _AxoHome_Deceleration                   :   LREAL;
            //***********MoveAbsolute*************************
            _AxoMoveAbsolute_ContinuousUpdate       :   BOOL;
            _AxoMoveAbsolute_Position               :   LREAL;
            _AxoMoveAbsolute_Velocity               :   LREAL;
            _AxoMoveAbsolute_Acceleration           :   LREAL;
            _AxoMoveAbsolute_Deceleration           :   LREAL;
            _AxoMoveAbsolute_Jerk                   :   LREAL;
            _AxoMoveAbsolute_Direction              :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;
            //***********MoveRelative*************************
            _AxoMoveRelative_ContinuousUpdate       :   BOOL;
            _AxoMoveRelative_Distance               :   LREAL;
            _AxoMoveRelative_Velocity               :   LREAL;
            _AxoMoveRelative_Acceleration           :   LREAL;
            _AxoMoveRelative_Deceleration           :   LREAL;
            _AxoMoveRelative_Jerk                   :   LREAL;
            //***********MoveAdditive*************************
            _AxoMoveAdditive_ContinuousUpdate       :   BOOL;
            _AxoMoveAdditive_Distance               :   LREAL;
            _AxoMoveAdditive_Velocity               :   LREAL;
            _AxoMoveAdditive_Acceleration           :   LREAL;
            _AxoMoveAdditive_Deceleration           :   LREAL;
            _AxoMoveAdditive_Jerk                   :   LREAL;
            //***********MoveVelocity*************************
            _AxoMoveVelocity_ContinuousUpdate       :   BOOL;
            _AxoMoveVelocity_Velocity               :   LREAL;
            _AxoMoveVelocity_Acceleration           :   LREAL;
            _AxoMoveVelocity_Deceleration           :   LREAL;
            _AxoMoveVelocity_Jerk                   :   LREAL;
            _AxoMoveVelocity_Direction              :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;
            //***********TorqueControl************************
            _AxoTorqueControl_ContinuousUpdate      :   BOOL;
            _AxoTorqueControl_Torque                :   LREAL;
            _AxoTorqueControl_TorqueRamp            :   LREAL;
            _AxoTorqueControl_Velocity              :   LREAL;
            _AxoTorqueControl_Acceleration          :   LREAL;
            _AxoTorqueControl_Deceleration          :   LREAL;
            _AxoTorqueControl_Jerk                  :   LREAL;
            _AxoTorqueControl_Direction             :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;
            //***********SetPosition**************************
            _AxoSetPosition_Position                :   LREAL;                    
            _AxoSetPosition_Relative                :   BOOL;                    
            _AxoSetPosition_ExecutionMode           :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;       
            //***********SetOverride**************************
            _AxoSetOverride_VelFactor               :   LREAL;                     
            _AxoSetOverride_AccFactor               :   LREAL;                     
            _AxoSetOverride_JerkFactor              :   LREAL;        
            //***********ReadParameter************************
            _AxoReadParameter_ParameterNumber       :   DINT;
            //***********ReadReadParameter************************
            _AxoReadRealParameter_ParameterNumber   :   DINT;
            //***********ReadBoolParameter********************
            _AxoReadBoolParameter_ParameterNumber   :   DINT;
            //***********WriteParameter***********************
            _AxoWriteParameter_ParameterNumber      :   DINT;                    
            _AxoWriteParameter_Value                :   DINT;                     
            _AxoWriteParameter_ExecutionMode        :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;                  
            //***********WriteRealParameter***********************
            _AxoWriteRealParameter_ParameterNumber  :   DINT;                    
            _AxoWriteRealParameter_Value            :   REAL;                     
            _AxoWriteRealParameter_ExecutionMode    :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;                  
            //***********WriteBoolParameter*******************
            _AxoWriteBoolParameter_ParameterNumber  :   DINT;                    
            _AxoWriteBoolParameter_Value            :   BOOL;                     
            _AxoWriteBoolParameter_ExecutionMode    :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;                  
            //***********ReadDigitalInput*********************
            _AxoReadDigitalInput_InputNumber        :   INT;
            //***********ReadDigitalOutput********************
            _AxoReadDigitalOutput_OutputNumber      :   INT;
            //***********WriteDigitalOutput*******************
            _AxoWriteDigitalOutput_OutputNumber     :   INT;
            _AxoWriteDigitalOutput_Value            :   BOOL;                     
            _AxoWriteDigitalOutput_ExecutionMode    :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;                  
            //***********ReadMotionState**********************
            _AxoReadMotionState_Source              :   AXOpen.Components.Abstractions.Drives.eAxoSource;
            //***********Jog**********************************
            _AxoJog_Velocity                        :   LREAL;
            _AxoJog_Acceleration                    :   LREAL;
            _AxoJog_Deceleration                    :   LREAL;
            _AxoJog_Jerk                            :   LREAL;
            _AxoJog_Direction                       :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;
            _AxoJogInVelocity                       :   BOOL;
            _AxoJog_Active                          :   BOOL;
            //************************************************
        END_VAR

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent          :   IAxoObject; 
                refAxisIn       :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the axis
                refAxisOut      :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the axis
                Enable          :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
                EnablePositive  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in positive direction
                EnableNegative  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in negative direction
            END_VAR

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                DriveStatus.Error.Id := UINT#700;
                RETURN;
            END_IF;

            THIS.Initialize(parent);
            // IF THIS._context_ = NULL THEN
            //     THIS.Initialize(parent);
            //     THIS.InitializeTasks();
            // END_IF;

            IF NOT THIS.IsValidReferences(refAxisIn,refAxisOut) THEN
                RETURN;
            END_IF;
            
            THIS.Open();
            THIS.UpdateInputs(refAxisIn,_AxisRef);
            THIS.Execute(_AxisRef,Enable,EnablePositive,EnableNegative);
            THIS.UpdateOutputs(_AxisRef,refAxisIn);
            THIS.Close();            
        END_METHOD   

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent          :   IAxoContext; 
                refAxisIn       :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the axis
                refAxisOut      :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the axis
                Enable          :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
                EnablePositive  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in positive direction
                EnableNegative  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in negative direction
            END_VAR

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                DriveStatus.Error.Id := UINT#700;
                RETURN;
            END_IF;

            THIS.Initialize(parent);
            // IF THIS._context_ = NULL THEN
            //     THIS.Initialize(parent);
            //     THIS.InitializeTasks();
            // END_IF;

            IF NOT THIS.IsValidReferences(refAxisIn,refAxisOut) THEN
                RETURN;
            END_IF;
            
            THIS.Open();
            THIS.UpdateInputs(refAxisIn,_AxisRef);
            THIS.Execute(_AxisRef,Enable,EnablePositive,EnableNegative);
            THIS.UpdateOutputs(_AxisRef,refAxisIn);
            THIS.Close();            
        END_METHOD   

        METHOD PRIVATE InitializeTasks
                RestoreTask.Initialize(THIS);
                AxoPower_Task.Initialize(THIS);
                AxoStop_Task.Initialize(THIS);
                AxoHalt_Task.Initialize(THIS);
                AxoHome_Task.Initialize(THIS);
                AxoMoveAbsolute_Task.Initialize(THIS);
                AxoMoveRelative_Task.Initialize(THIS);
                AxoMoveAdditive_Task.Initialize(THIS);
                AxoMoveVelocity_Task.Initialize(THIS);
                AxoTorqueControl_Task.Initialize(THIS);
                AxoSetPosition_Task.Initialize(THIS);
                AxoSetOverride_Task.Initialize(THIS);
                AxoReadParameter_Task.Initialize(THIS);
                AxoReadRealParameter_Task.Initialize(THIS);
                AxoReadBoolParameter_Task.Initialize(THIS);
                AxoWriteParameter_Task.Initialize(THIS);
                AxoWriteRealParameter_Task.Initialize(THIS);
                AxoWriteBoolParameter_Task.Initialize(THIS);
                AxoReadDigitalInput_Task.Initialize(THIS);
                AxoReadDigitalOutput_Task.Initialize(THIS);
                AxoWriteDigitalOutput_Task.Initialize(THIS);
                AxoReadActualPosition_Task.Initialize(THIS);
                AxoReadActualVelocity_Task.Initialize(THIS);
                AxoReadActualTorque_Task.Initialize(THIS);
                AxoReadStatus_Task.Initialize(THIS);
                AxoReadMotionState_Task.Initialize(THIS);
                AxoReadAxisInfo_Task.Initialize(THIS);
                AxoReadAxisError_Task.Initialize(THIS);
                AxoReset_Task.Initialize(THIS);
                AxoJogPositive.Initialize(THIS);
                AxoJogNegative.Initialize(THIS);          
        END_METHOD

        METHOD PROTECTED Execute
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
                EnablePositive  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in positive direction
                EnableNegative  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in negative direction
            END_VAR

            Messenger.Serve(THIS);
            TaskMessenger.Serve(THIS);
            
            RestoreTask.Initialize(THIS);
            AxoPower_Task.Initialize(THIS);
            AxoStop_Task.Initialize(THIS);
            AxoHalt_Task.Initialize(THIS);
            AxoHome_Task.Initialize(THIS);
            AxoMoveAbsolute_Task.Initialize(THIS);
            AxoMoveRelative_Task.Initialize(THIS);
            AxoMoveAdditive_Task.Initialize(THIS);
            AxoMoveVelocity_Task.Initialize(THIS);
            AxoTorqueControl_Task.Initialize(THIS);
            AxoSetPosition_Task.Initialize(THIS);
            AxoSetOverride_Task.Initialize(THIS);
            AxoReadParameter_Task.Initialize(THIS);
            AxoReadRealParameter_Task.Initialize(THIS);
            AxoReadBoolParameter_Task.Initialize(THIS);
            AxoWriteParameter_Task.Initialize(THIS);
            AxoWriteRealParameter_Task.Initialize(THIS);
            AxoWriteBoolParameter_Task.Initialize(THIS);
            AxoReadDigitalInput_Task.Initialize(THIS);
            AxoReadDigitalOutput_Task.Initialize(THIS);
            AxoWriteDigitalOutput_Task.Initialize(THIS);
            AxoReadActualPosition_Task.Initialize(THIS);
            AxoReadActualVelocity_Task.Initialize(THIS);
            AxoReadActualTorque_Task.Initialize(THIS);
            AxoReadStatus_Task.Initialize(THIS);
            AxoReadMotionState_Task.Initialize(THIS);
            AxoReadAxisInfo_Task.Initialize(THIS);
            AxoReadAxisError_Task.Initialize(THIS);
            AxoReset_Task.Initialize(THIS);
            AxoJogPositive.Initialize(THIS);
            AxoJogNegative.Initialize(THIS);

            //*************RESTORE**********************
            RestoreTask.IsDisabled := FALSE;
            IF RestoreTask.Execute() THEN
                THIS.Restore();
            END_IF;
            //******************************************

            //******************************************
            IF _disabledDuringMovement THEN
                AxoHalt_Task.Invoke();
                IF AxoHalt_Task.IsDone() THEN
                    _disabledDuringMovement := FALSE;
                END_IF;
            END_IF;
            //******************************************

            //*************AXO_POWER********************
            AxoPower_Task.Run(Enable,EnablePositive,EnableNegative);
            THIS.MC_Power(AxisRef,
                          AxoPower_Task.IsSwitchedOn(),
                          AxoPower_Status,
                          AxoPower_Valid,
                          AxoPower_Error,
                          AxoPower_ErrorID);
            //******************************************
            _movementDisabled := NOT AxoPower_Status;
            //*************AXO_STOP*********************
            AxoStop_Task.SetIsDisabled(FALSE);
            THIS.MC_Stop(AxisRef, 
                        AxoStop_Task.Execute() OR AxoStop_Task.IsDone() AND AxoStop_Task.IsBusy(),
                        _AxoStop_Deceleration,
                        _AxoStop_Jerk,
                        AxoStop_Done,
                        AxoStop_Busy,
                        AxoStop_Active,
                        AxoStop_CommandAborted,          
                        AxoStop_Error,
                        AxoStop_ErrorID);
            IF AxoStop_Task.IsFirstExecutionCycle() THEN
                AxoStop_Deceleration    :=  _AxoStop_Deceleration;
                AxoStop_Jerk            :=  _AxoStop_Jerk;
            END_IF;
            //******************************************
            _movementDisabled := _movementDisabled OR AxoStop_Active OR AxoStop_Task.IsDone() AND AxoStop_Task.IsBusy();
            //*************AXO_HALT*********************
            AxoHalt_Task.SetIsDisabled(FALSE);
            THIS.MC_Halt(AxisRef, 
                        AxoHalt_Task.Execute(),
                        _AxoHalt_Deceleration,
                        _AxoHalt_Jerk,
                        AxoHalt_Done,
                        AxoHalt_Busy,
                        AxoHalt_Active,
                        AxoHalt_CommandAborted,          
                        AxoHalt_Error,
                        AxoHalt_ErrorID);            

            IF AxoHalt_Task.IsBusy() THEN
                AxoHalt_Task.DoneWhen(AxoHalt_Done);
                AxoHalt_Task.ThrowWhen(AxoHalt_Error,CONCAT('MC_Halt has thrown an error: ', ToString(AxoHalt_ErrorID)));
                IF AxoHalt_CommandAborted THEN
                    AxoHalt_Task.Abort();
                END_IF;
                IF AxoHalt_Task.IsFirstExecutionCycle() THEN
                    AxoHalt_Deceleration    :=  _AxoHalt_Deceleration;
                    AxoHalt_Jerk            :=  _AxoHalt_Jerk;
                    IF AxoHome_Task.IsBusy() THEN
                        AxoHome_Task.Restore();
                    END_IF;
                    IF AxoMoveAbsolute_Task.IsBusy() THEN
                        AxoMoveAbsolute_Task.Restore();
                    END_IF;
                    IF AxoMoveRelative_Task.IsBusy() THEN
                        AxoMoveRelative_Task.Restore();
                    END_IF;
                    IF AxoMoveAdditive_Task.IsBusy() THEN
                        AxoMoveAdditive_Task.Restore();
                    END_IF;
                    IF AxoMoveVelocity_Task.IsBusy() THEN
                        AxoMoveVelocity_Task.Restore();
                    END_IF;
                    IF AxoTorqueControl_Task.IsBusy() THEN
                        AxoTorqueControl_Task.Restore();
                    END_IF;
                END_IF;
            END_IF;
            //******************************************
            _movementDisabled := _movementDisabled OR AxoHalt_Active;

            //*************AXO_HOME*********************
            AxoHome_Task.SetIsDisabled(_movementDisabled);
            THIS.MC_Home(AxisRef, 
                        AxoHome_Task.Execute(),
                        _AxoHome_Position,
                        _AxoHome_HommingMode,
                        _AxoHome_Velocity, 
                        _AxoHome_Acceleration,
                        _AxoHome_Deceleration,
                        AxoHome_Done,
                        AxoHome_Busy,
                        AxoHome_Active,
                        AxoHome_CommandAborted,
                        AxoHome_Error,
                        AxoHome_ErrorID);

            IF AxoHome_Task.IsBusy() THEN
                IF AxoHome_Task.IsFirstExecutionCycle() THEN
                    AxoHome_Position        :=  _AxoHome_Position;
                    AxoHome_HommingMode     :=  _AxoHome_HommingMode;
                    AxoHome_Velocity        :=  _AxoHome_Velocity;
                    AxoHome_Acceleration    :=  _AxoHome_Acceleration;
                    AxoHome_Deceleration    :=  _AxoHome_Deceleration;
                END_IF;
                AxoHome_Task.DoneWhen(AxoHome_Done);
                AxoHome_Task.ThrowWhen(AxoHome_Error,CONCAT('MC_Home has thrown an error: ', ToString(AxoHome_ErrorID)));
                IF AxoHome_CommandAborted THEN
                    AxoHome_Task.Abort();
                END_IF;
            END_IF;
            IF AxoHome_Active OR DriveState = eAxoDriveState#Homing THEN
                IF (ActualVelocity > 0.5 AND NOT EnablePositive OR ActualVelocity < -0.5 AND NOT EnableNegative) THEN
                    _disabledDuringMovement := TRUE;
                    AxoHome_Task.Restore();
                END_IF;
            END_IF;
            //******************************************

            //*************AXO_MOVE_ABSOLUTE************
            _movementInPositiveDirection := _AxoMoveAbsolute_Position > ActualPosition;
            _movementInNegativeDirection := _AxoMoveAbsolute_Position < ActualPosition;
            AxoMoveAbsolute_Task.SetIsDisabled(_movementDisabled OR (_movementInPositiveDirection AND NOT EnablePositive)  OR (_movementInNegativeDirection AND NOT EnableNegative) );
            THIS.MC_MoveAbsolute(AxisRef, 
                        AxoMoveAbsolute_Task.Execute(),
                        _AxoMoveAbsolute_ContinuousUpdate,
                        _AxoMoveAbsolute_Position,
                        _AxoMoveAbsolute_Velocity, 
                        _AxoMoveAbsolute_Acceleration,
                        _AxoMoveAbsolute_Deceleration,
                        _AxoMoveAbsolute_Jerk,
                        _AxoMoveAbsolute_Direction,
                        AxoMoveAbsolute_Done,
                        AxoMoveAbsolute_Busy,
                        AxoMoveAbsolute_Active,
                        AxoMoveAbsolute_CommandAborted,
                        AxoMoveAbsolute_Error,
                        AxoMoveAbsolute_ErrorID);

            IF AxoMoveAbsolute_Task.IsBusy() THEN
                IF AxoMoveAbsolute_Task.IsFirstExecutionCycle() THEN
                    AxoMoveAbsolute_ContinuousUpdate    :=  _AxoMoveAbsolute_ContinuousUpdate;
                    AxoMoveAbsolute_Position            :=  _AxoMoveAbsolute_Position;
                    AxoMoveAbsolute_Velocity            :=  _AxoMoveAbsolute_Velocity;
                    AxoMoveAbsolute_Acceleration        :=  _AxoMoveAbsolute_Acceleration;
                    AxoMoveAbsolute_Deceleration        :=  _AxoMoveAbsolute_Deceleration;
                    AxoMoveAbsolute_Jerk                :=  _AxoMoveAbsolute_Jerk;
                    AxoMoveAbsolute_Direction           :=  _AxoMoveAbsolute_Direction;
                END_IF;
                AxoMoveAbsolute_Task.DoneWhen(AxoMoveAbsolute_Done);
                AxoMoveAbsolute_Task.ThrowWhen(AxoMoveAbsolute_Error,CONCAT('MC_MoveAbsolute has thrown an error: ', ToString(AxoMoveAbsolute_ErrorID)));
                IF AxoMoveAbsolute_CommandAborted THEN
                    AxoMoveAbsolute_Task.Abort();
                END_IF;
            END_IF;
            IF AxoMoveAbsolute_Active THEN
                IF (ActualVelocity > 0.5 AND NOT EnablePositive OR ActualVelocity < -0.5 AND NOT EnableNegative) THEN
                    _disabledDuringMovement := TRUE;
                    AxoMoveAbsolute_Task.Restore();
                END_IF;
            END_IF;
            //******************************************

            //*************AXO_MOVE_RELATIVE************
            _movementInPositiveDirection := _AxoMoveRelative_Distance > 0;
            _movementInNegativeDirection := _AxoMoveRelative_Distance < 0;
            AxoMoveRelative_Task.SetIsDisabled(_movementDisabled OR (_movementInPositiveDirection AND NOT EnablePositive)  OR (_movementInNegativeDirection AND NOT EnableNegative) );
            THIS.MC_MoveRelative(AxisRef, 
                        AxoMoveRelative_Task.Execute(),
                        _AxoMoveRelative_ContinuousUpdate,
                        _AxoMoveRelative_Distance,
                        _AxoMoveRelative_Velocity, 
                        _AxoMoveRelative_Acceleration,
                        _AxoMoveRelative_Deceleration,
                        _AxoMoveRelative_Jerk,
                        AxoMoveRelative_Done,
                        AxoMoveRelative_Busy,
                        AxoMoveRelative_Active,
                        AxoMoveRelative_CommandAborted,
                        AxoMoveRelative_Error,
                        AxoMoveRelative_ErrorID);

            IF AxoMoveRelative_Task.IsBusy() THEN
                IF AxoMoveRelative_Task.IsFirstExecutionCycle() THEN
                    AxoMoveRelative_ContinuousUpdate    :=  _AxoMoveRelative_ContinuousUpdate;
                    AxoMoveRelative_Distance            :=  _AxoMoveRelative_Distance;
                    AxoMoveRelative_Velocity            :=  _AxoMoveRelative_Velocity;
                    AxoMoveRelative_Acceleration        :=  _AxoMoveRelative_Acceleration;
                    AxoMoveRelative_Deceleration        :=  _AxoMoveRelative_Deceleration;
                    AxoMoveRelative_Jerk                :=  _AxoMoveRelative_Jerk;
                END_IF;
                AxoMoveRelative_Task.DoneWhen(AxoMoveRelative_Done);
                AxoMoveRelative_Task.ThrowWhen(AxoMoveRelative_Error,CONCAT('MC_MoveRelative has thrown an error: ', ToString(AxoMoveRelative_ErrorID)));
                IF AxoMoveRelative_CommandAborted THEN
                    AxoMoveRelative_Task.Abort();
                END_IF;
            END_IF;
            IF AxoMoveRelative_Active THEN
                IF (ActualVelocity > 0.5 AND NOT EnablePositive OR ActualVelocity < -0.5 AND NOT EnableNegative) THEN
                    _disabledDuringMovement := TRUE;
                    AxoMoveRelative_Task.Restore();
                END_IF;
            END_IF;
            //******************************************

            //*************AXO_MOVE_ADDITIVE************
            _movementInPositiveDirection := _AxoMoveAdditive_Distance > 0;
            _movementInNegativeDirection := _AxoMoveAdditive_Distance < 0;
            AxoMoveAdditive_Task.SetIsDisabled(_movementDisabled OR (_movementInPositiveDirection AND NOT EnablePositive)  OR (_movementInNegativeDirection AND NOT EnableNegative) );
            THIS.MC_MoveAdditive(AxisRef, 
                        AxoMoveAdditive_Task.Execute(),
                        _AxoMoveAdditive_ContinuousUpdate,
                        _AxoMoveAdditive_Distance,
                        _AxoMoveAdditive_Velocity, 
                        _AxoMoveAdditive_Acceleration,
                        _AxoMoveAdditive_Deceleration,
                        _AxoMoveAdditive_Jerk,
                        AxoMoveAdditive_Done,
                        AxoMoveAdditive_Busy,
                        AxoMoveAdditive_Active,
                        AxoMoveAdditive_CommandAborted,
                        AxoMoveAdditive_Error,
                        AxoMoveAdditive_ErrorID);

            IF AxoMoveAdditive_Task.IsBusy() THEN
                IF AxoMoveAdditive_Task.IsFirstExecutionCycle() THEN
                    AxoMoveAdditive_ContinuousUpdate    :=  _AxoMoveAdditive_ContinuousUpdate;
                    AxoMoveAdditive_Distance            :=  _AxoMoveAdditive_Distance;
                    AxoMoveAdditive_Velocity            :=  _AxoMoveAdditive_Velocity;
                    AxoMoveAdditive_Acceleration        :=  _AxoMoveAdditive_Acceleration;
                    AxoMoveAdditive_Deceleration        :=  _AxoMoveAdditive_Deceleration;
                    AxoMoveAdditive_Jerk                :=  _AxoMoveAdditive_Jerk;
                END_IF;
                AxoMoveAdditive_Task.DoneWhen(AxoMoveAdditive_Done);
                AxoMoveAdditive_Task.ThrowWhen(AxoMoveAdditive_Error,CONCAT('MC_MoveAdditive has thrown an error: ', ToString(AxoMoveAdditive_ErrorID)));
                IF AxoMoveAdditive_CommandAborted THEN
                    AxoMoveAdditive_Task.Abort();
                END_IF;
            END_IF;
            IF AxoMoveAdditive_Active THEN
                IF (ActualVelocity > 0.5 AND NOT EnablePositive OR ActualVelocity < -0.5 AND NOT EnableNegative) THEN
                    _disabledDuringMovement := TRUE;
                    AxoMoveAdditive_Task.Restore();
                END_IF;
            END_IF;
            //******************************************

            //*************AXO_MOVE_VELOCITY************
            _movementInPositiveDirection := _AxoMoveVelocity_Velocity > 0 AND _AxoMoveVelocity_Direction = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection OR 
                                            _AxoMoveVelocity_Velocity < 0 AND _AxoMoveVelocity_Direction = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#NegativeDirection;
            _movementInNegativeDirection := _AxoMoveVelocity_Velocity < 0 AND _AxoMoveVelocity_Direction = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection OR 
                                            _AxoMoveVelocity_Velocity > 0 AND _AxoMoveVelocity_Direction = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#NegativeDirection;
                                            AxoMoveVelocity_Task.SetIsDisabled(_movementDisabled OR (_movementInPositiveDirection AND NOT EnablePositive)  OR (_movementInNegativeDirection AND NOT EnableNegative) );
            THIS.MC_MoveVelocity(AxisRef, 
                        AxoMoveVelocity_Task.Execute(),
                        _AxoMoveVelocity_ContinuousUpdate,
                        _AxoMoveVelocity_Velocity, 
                        _AxoMoveVelocity_Acceleration,
                        _AxoMoveVelocity_Deceleration,
                        _AxoMoveVelocity_Jerk,
                        _AxoMoveVelocity_Direction,
                        AxoMoveVelocity_InVelocity,
                        AxoMoveVelocity_Busy,
                        AxoMoveVelocity_Active,
                        AxoMoveVelocity_CommandAborted,
                        AxoMoveVelocity_Error,
                        AxoMoveVelocity_ErrorID);

            IF AxoMoveVelocity_Task.IsBusy() THEN
                IF AxoMoveVelocity_Task.IsFirstExecutionCycle() THEN
                    AxoMoveVelocity_ContinuousUpdate    :=  _AxoMoveVelocity_ContinuousUpdate;
                    AxoMoveVelocity_Velocity            :=  _AxoMoveVelocity_Velocity;
                    AxoMoveVelocity_Acceleration        :=  _AxoMoveVelocity_Acceleration;
                    AxoMoveVelocity_Deceleration        :=  _AxoMoveVelocity_Deceleration;
                    AxoMoveVelocity_Jerk                :=  _AxoMoveVelocity_Jerk;
                    AxoMoveVelocity_Direction           :=  _AxoMoveVelocity_Direction;
                END_IF;
                AxoMoveVelocity_Task.DoneWhen(AxoMoveVelocity_InVelocity AND NOT _AxoMoveVelocity_ContinuousUpdate);
                AxoMoveVelocity_Task.ThrowWhen(AxoMoveVelocity_Error,CONCAT('MC_MoveVelocity has thrown an error: ', ToString(AxoMoveVelocity_ErrorID)));
                IF AxoMoveVelocity_CommandAborted THEN
                    AxoMoveVelocity_Task.Abort();
                END_IF;
            END_IF;
            //******************************************

            //*************AXO_TORQUE_CONTROL***********
            _movementInPositiveDirection := _AxoTorqueControl_Torque > 0 AND _AxoTorqueControl_Direction = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection OR 
                                            _AxoTorqueControl_Torque < 0 AND _AxoTorqueControl_Direction = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#NegativeDirection;
            _movementInNegativeDirection := _AxoTorqueControl_Torque < 0 AND _AxoTorqueControl_Direction = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection OR 
                                            _AxoTorqueControl_Torque > 0 AND _AxoTorqueControl_Direction = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#NegativeDirection;
            AxoTorqueControl_Task.SetIsDisabled(_movementDisabled OR (_movementInPositiveDirection AND NOT EnablePositive)  OR (_movementInNegativeDirection AND NOT EnableNegative) );
            THIS.MC_TorqueControl(AxisRef, 
                        AxoTorqueControl_Task.Execute(),
                        _AxoTorqueControl_ContinuousUpdate,
                        _AxoTorqueControl_Torque, 
                        _AxoTorqueControl_TorqueRamp,
                        _AxoTorqueControl_Velocity,
                        _AxoTorqueControl_Acceleration,
                        _AxoTorqueControl_Deceleration,
                        _AxoTorqueControl_Jerk,
                        _AxoTorqueControl_Direction,
                        AxoTorqueControl_InTorque,
                        AxoTorqueControl_Busy,
                        AxoTorqueControl_Active,
                        AxoTorqueControl_CommandAborted,
                        AxoTorqueControl_Error,
                        AxoTorqueControl_ErrorID);

            IF AxoTorqueControl_Task.IsBusy() THEN
                IF AxoTorqueControl_Task.IsFirstExecutionCycle() THEN
                    AxoTorqueControl_ContinuousUpdate   :=  _AxoTorqueControl_ContinuousUpdate;
                    AxoTorqueControl_Torque             :=  _AxoTorqueControl_Torque;
                    AxoTorqueControl_TorqueRamp         :=  _AxoTorqueControl_TorqueRamp;
                    AxoTorqueControl_Velocity           :=  _AxoTorqueControl_Velocity;
                    AxoTorqueControl_Acceleration       :=  _AxoTorqueControl_Acceleration;
                    AxoTorqueControl_Deceleration       :=  _AxoTorqueControl_Deceleration;
                    AxoTorqueControl_Jerk               :=  _AxoTorqueControl_Jerk;
                    AxoTorqueControl_Direction          :=  _AxoTorqueControl_Direction;
                END_IF;
                AxoTorqueControl_Task.DoneWhen(AxoTorqueControl_InTorque AND NOT _AxoTorqueControl_ContinuousUpdate);
                AxoTorqueControl_Task.ThrowWhen(AxoTorqueControl_Error,CONCAT('MC_TorqueControl has thrown an error: ', ToString(AxoTorqueControl_ErrorID)));
                IF AxoTorqueControl_CommandAborted THEN
                    AxoTorqueControl_Task.Abort();
                END_IF;
            END_IF;
            //******************************************
            IF DriveState = eAxoDriveState#ContinousMotion AND (ActualVelocity > 0.5 AND NOT EnablePositive OR ActualVelocity < -0.5 AND NOT EnableNegative) THEN
                _disabledDuringMovement := TRUE;
                IF AxoMoveVelocity_Task.IsBusy() THEN
                    AxoMoveVelocity_Task.Restore();
                END_IF;
                IF AxoTorqueControl_Task.IsBusy() THEN
                    AxoTorqueControl_Task.Restore();
                END_IF;
            END_IF;
            //*************AXO_SET_POSITION*************
            AxoSetPosition_Task.SetIsDisabled(FALSE); 
            THIS.MC_SetPosition(AxisRef, 
                        AxoSetPosition_Task.Execute(),
                        _AxoSetPosition_Position,
                        _AxoSetPosition_Relative,
                        _AxoSetPosition_ExecutionMode,
                        AxoSetPosition_Done,
                        AxoSetPosition_Busy,
                        AxoSetPosition_Error,
                        AxoSetPosition_ErrorID);

            IF AxoSetPosition_Task.IsBusy() THEN
                AxoSetPosition_Task.DoneWhen(AxoSetPosition_Done);
                AxoSetPosition_Task.ThrowWhen(AxoSetPosition_Error,CONCAT('MC_SetPosition has thrown an error: ', ToString(AxoSetPosition_ErrorID)));
            END_IF;
            //******************************************

            //*************AXO_SET_OVERRIDE*************
            AxoSetOverride_Task.SetIsDisabled(FALSE);
            AxoSetOverride_Task.Run();
            THIS.MC_SetOverride(AxisRef, 
                        AxoSetOverride_Task.IsSwitchedOn(),
                        _AxoSetOverride_VelFactor,
                        _AxoSetOverride_AccFactor,
                        _AxoSetOverride_JerkFactor,
                        AxoSetOverride_Enabled,
                        AxoSetOverride_Busy,
                        AxoSetOverride_Error,
                        AxoSetOverride_ErrorID);
            //******************************************

            //*************AXO_READ_PARAMETER***********
            AxoReadParameter_Task.SetIsDisabled(FALSE);
            AxoReadParameter_Task.Run();
            THIS.MC_ReadParameter(AxisRef, 
                        AxoReadParameter_Task.IsSwitchedOn(),
                        _AxoReadParameter_ParameterNumber,
                        AxoReadParameter_Valid,
                        AxoReadParameter_Busy,
                        AxoReadParameter_Error,
                        AxoReadParameter_ErrorID,
                        AxoReadParameter_Value);
            //******************************************

            //*************AXO_READ_REAL_PARAMETER******
            AxoReadRealParameter_Task.SetIsDisabled(FALSE);
            AxoReadRealParameter_Task.Run();
            THIS.MC_ReadRealParameter(AxisRef, 
                        AxoReadRealParameter_Task.IsSwitchedOn(),
                        _AxoReadRealParameter_ParameterNumber,
                        AxoReadRealParameter_Valid,
                        AxoReadRealParameter_Busy,
                        AxoReadRealParameter_Error,
                        AxoReadRealParameter_ErrorID,
                        AxoReadRealParameter_Value);
            //******************************************

            //*************AXO_READ_BOOL_PARAMETER******
            AxoReadBoolParameter_Task.SetIsDisabled(FALSE);
            AxoReadBoolParameter_Task.Run();
            THIS.MC_ReadBoolParameter(AxisRef, 
                        AxoReadBoolParameter_Task.IsSwitchedOn(),
                        _AxoReadBoolParameter_ParameterNumber,
                        AxoReadBoolParameter_Valid,
                        AxoReadBoolParameter_Busy,
                        AxoReadBoolParameter_Error,
                        AxoReadBoolParameter_ErrorID,
                        AxoReadBoolParameter_Value);
            //******************************************

            //*************AXO_WRITE_PARAMETER**********
            AxoWriteParameter_Task.SetIsDisabled(FALSE);
            THIS.MC_WriteParameter(AxisRef, 
                        AxoWriteParameter_Task.Execute(),
                        _AxoWriteParameter_ParameterNumber,
                        _AxoWriteParameter_Value,
                        _AxoWriteParameter_ExecutionMode,
                        AxoWriteParameter_Done,
                        AxoWriteParameter_Busy,
                        AxoWriteParameter_Error,
                        AxoWriteParameter_ErrorID);
            IF AxoWriteParameter_Task.IsBusy() THEN
                AxoWriteParameter_Task.DoneWhen(AxoWriteParameter_Done);
                AxoWriteParameter_Task.ThrowWhen(AxoWriteParameter_Error,CONCAT('MC_WriteParameter has thrown an error: ', ToString(AxoWriteParameter_ErrorID)));
            END_IF;
            //******************************************

            //*************AXO_WRITE_REAL_PARAMETER*****
            AxoWriteRealParameter_Task.SetIsDisabled(FALSE);
            THIS.MC_WriteRealParameter(AxisRef, 
                        AxoWriteRealParameter_Task.Execute(),
                        _AxoWriteRealParameter_ParameterNumber,
                        _AxoWriteRealParameter_Value,
                        _AxoWriteRealParameter_ExecutionMode,
                        AxoWriteRealParameter_Done,
                        AxoWriteRealParameter_Busy,
                        AxoWriteRealParameter_Error,
                        AxoWriteRealParameter_ErrorID);
            IF AxoWriteRealParameter_Task.IsBusy() THEN
                AxoWriteRealParameter_Task.DoneWhen(AxoWriteRealParameter_Done);
                AxoWriteRealParameter_Task.ThrowWhen(AxoWriteRealParameter_Error,CONCAT('MC_WriteRealParameter has thrown an error: ', ToString(AxoWriteRealParameter_ErrorID)));
            END_IF;
            //******************************************

            //*************AXO_WRITE_BOOL_PARAMETER*****
            AxoWriteBoolParameter_Task.SetIsDisabled(FALSE);
            THIS.MC_WriteBoolParameter(AxisRef, 
                        AxoWriteBoolParameter_Task.Execute(),
                        _AxoWriteBoolParameter_ParameterNumber,
                        _AxoWriteBoolParameter_Value,
                        _AxoWriteBoolParameter_ExecutionMode,
                        AxoWriteBoolParameter_Done,
                        AxoWriteBoolParameter_Busy,
                        AxoWriteBoolParameter_Error,
                        AxoWriteBoolParameter_ErrorID);
            IF AxoWriteBoolParameter_Task.IsBusy() THEN
                AxoWriteBoolParameter_Task.DoneWhen(AxoWriteBoolParameter_Done);
                AxoWriteBoolParameter_Task.ThrowWhen(AxoWriteBoolParameter_Error,CONCAT('MC_WriteBoolParameter has thrown an error: ', ToString(AxoWriteBoolParameter_ErrorID)));
            END_IF;
            //******************************************

            //*************AXO_READ_DIGITAL_INPUT*******
            AxoReadDigitalInput_Task.SetIsDisabled(FALSE);
            AxoReadDigitalInput_Task.Run();
            THIS.MC_ReadDigitalInput(AxisRef, 
                        AxoReadDigitalInput_Task.IsSwitchedOn(),
                        _AxoReadDigitalInput_InputNumber,
                        AxoReadDigitalInput_Valid,
                        AxoReadDigitalInput_Busy,
                        AxoReadDigitalInput_Error,
                        AxoReadDigitalInput_ErrorID,
                        AxoReadDigitalInput_Value);
            //******************************************

            //*************AXO_READ_DIGITAL_OUTPUT******
            AxoReadDigitalOutput_Task.SetIsDisabled(FALSE);
            AxoReadDigitalOutput_Task.Run();
            THIS.MC_ReadDigitalOutput(AxisRef, 
                        AxoReadDigitalOutput_Task.IsSwitchedOn(),
                        _AxoReadDigitalOutput_OutputNumber,
                        AxoReadDigitalOutput_Valid,
                        AxoReadDigitalOutput_Busy,
                        AxoReadDigitalOutput_Error,
                        AxoReadDigitalOutput_ErrorID,
                        AxoReadDigitalOutput_Value);
            //******************************************

            //*************AXO_WRITE_DIGITAL_OUTPUT*****
            AxoWriteDigitalOutput_Task.SetIsDisabled(FALSE);
            THIS.MC_WriteDigitalOutput(AxisRef, 
                        AxoWriteDigitalOutput_Task.Execute(),
                        _AxoWriteDigitalOutput_OutputNumber,
                        _AxoWriteDigitalOutput_Value,
                        _AxoWriteDigitalOutput_ExecutionMode,
                        AxoWriteDigitalOutput_Done,
                        AxoWriteDigitalOutput_Busy,
                        AxoWriteDigitalOutput_Error,
                        AxoWriteDigitalOutput_ErrorID);
            IF AxoWriteDigitalOutput_Task.IsBusy() THEN
                AxoWriteDigitalOutput_Task.DoneWhen(AxoWriteDigitalOutput_Done);
                AxoWriteDigitalOutput_Task.ThrowWhen(AxoWriteDigitalOutput_Error,CONCAT('MC_WriteDigitalOutput has thrown an error: ', ToString(AxoWriteDigitalOutput_ErrorID)));
            END_IF;
            //******************************************

            //*************AXO_READ_ACTUAL_POSITION*****
            AxoReadActualPosition_Task.SetIsDisabled(FALSE);
            AxoReadActualPosition_Task.Run();
            THIS.MC_ReadActualPosition(AxisRef, 
                        AxoReadActualPosition_Task.IsSwitchedOn(),
                        AxoReadActualPosition_Valid,
                        AxoReadActualPosition_Busy,
                        AxoReadActualPosition_Error,
                        AxoReadActualPosition_ErrorID,
                        AxoReadActualPosition_Value);
            //******************************************

            //*************AXO_READ_ACTUAL_VELOCITY*****
            AxoReadActualVelocity_Task.SetIsDisabled(FALSE);
            AxoReadActualVelocity_Task.Run();
            THIS.MC_ReadActualVelocity(AxisRef, 
                        AxoReadActualVelocity_Task.IsSwitchedOn(),
                        AxoReadActualVelocity_Valid,
                        AxoReadActualVelocity_Busy,
                        AxoReadActualVelocity_Error,
                        AxoReadActualVelocity_ErrorID,
                        AxoReadActualVelocity_Value);
            //******************************************

            //*************AXO_READ_ACTUAL_TORQUE*******
            AxoReadActualTorque_Task.SetIsDisabled(FALSE);
            AxoReadActualTorque_Task.Run();
            THIS.MC_ReadActualTorque(AxisRef, 
                        AxoReadActualTorque_Task.IsSwitchedOn(),
                        AxoReadActualTorque_Valid,
                        AxoReadActualTorque_Busy,
                        AxoReadActualTorque_Error,
                        AxoReadActualTorque_ErrorID,
                        AxoReadActualTorque_Value);
            //******************************************

            //*************AXO_READ_STATUS**************
            AxoReadStatus_Task.SetIsDisabled(FALSE);
            AxoReadStatus_Task.Run();
            THIS.MC_ReadStatus(AxisRef, 
                        AxoReadStatus_Task.IsSwitchedOn(),
                        AxoReadStatus_Valid,
                        AxoReadStatus_Busy,
                        AxoReadStatus_Error,
                        AxoReadStatus_ErrorID,
                        AxoReadStatus_ErrorStop,           
                        AxoReadStatus_Disabled,            
                        AxoReadStatus_Stopping,            
                        AxoReadStatus_Homing,              
                        AxoReadStatus_Standstill,          
                        AxoReadStatus_DiscreteMotion,      
                        AxoReadStatus_ContinuousMotion,    
                        AxoReadStatus_SynchronizedMotion);
            //******************************************

            //*************AXO_READ_MOTION_STATE********
            AxoReadMotionState_Task.SetIsDisabled(FALSE);
            AxoReadMotionState_Task.Run();
            THIS.MC_ReadMotionState(AxisRef, 
                        AxoReadMotionState_Task.IsSwitchedOn(),
                        _AxoReadMotionState_Source,
                        AxoReadMotionState_Valid,
                        AxoReadMotionState_Busy,
                        AxoReadMotionState_Error,
                        AxoReadMotionState_ErrorID,
                        AxoReadMotionState_ConstantVelocity,                      
                        AxoReadMotionState_Accelerating,                           
                        AxoReadMotionState_Decelerating,                           
                        AxoReadMotionState_DirectionPositive,                      
                        AxoReadMotionState_DirectionNegative);
            //******************************************

            //*************AXO_READ_AXIS_INFO***********
            AxoReadAxisInfo_Task.SetIsDisabled(FALSE);
            AxoReadAxisInfo_Task.Run();
            THIS.MC_ReadAxisInfo(AxisRef, 
                        AxoReadAxisInfo_Task.IsSwitchedOn(),
                        AxoReadAxisInfo_Valid,
                        AxoReadAxisInfo_Busy,
                        AxoReadAxisInfo_Error,
                        AxoReadAxisInfo_ErrorID,
                        AxoReadAxisInfo_HomeAbsSwitch,
                        AxoReadAxisInfo_LimitSwitchPos,
                        AxoReadAxisInfo_LimitSwitchNeg,
                        AxoReadAxisInfo_Simulation,
                        AxoReadAxisInfo_CommunicationReady,
                        AxoReadAxisInfo_ReadyForPowerOn,
                        AxoReadAxisInfo_PowerOn,
                        AxoReadAxisInfo_IsHomed,
                        AxoReadAxisInfo_AxisWarning);
            //******************************************

            //*************AXO_READ_AXIS_ERROR**********
            AxoReadAxisError_Task.SetIsDisabled(FALSE);
            AxoReadAxisError_Task.Run();
            THIS.MC_ReadAxisError(AxisRef, 
                        AxoReadAxisError_Task.IsSwitchedOn(),
                        AxoReadAxisError_Valid,
                        AxoReadAxisError_Busy,
                        AxoReadAxisError_Error,
                        AxoReadAxisError_ErrorID,
                        AxoReadAxisError_AxisErrorID);
            //******************************************

            //*************AXO_RESET********************
            AxoReset_Task.SetIsDisabled(FALSE);
            THIS.MC_Reset(AxisRef, 
                        AxoReset_Task.Execute(),
                        AxoReset_Done,
                        AxoReset_Busy,
                        AxoReset_Error,
                        AxoReset_ErrorID);
            IF AxoReset_Task.IsBusy() THEN
                AxoReset_Task.DoneWhen(AxoReset_Done);
                AxoReset_Task.ThrowWhen(AxoReset_Error,CONCAT('MC_Reset has thrown an error: ', ToString(AxoReset_ErrorID)));
            END_IF;
            //******************************************

            //*************AXO_JOG**********************
            AxoJogPositive.SetIsDisabled(_movementDisabled OR NOT EnablePositive OR AxoJogNegative.IsSwitchedOn());
            AxoJogNegative.SetIsDisabled(_movementDisabled OR NOT EnableNegative OR AxoJogPositive.IsSwitchedOn());
            AxoJogPositive.Run();
            AxoJogNegative.Run();
            AxoJogInVelocity                        :=  FALSE;
            AxoJog_Active                           :=  FALSE;
            AxoJog_Done                             :=  FALSE;                   
            AxoJog_Busy                             :=  FALSE;                   
            AxoJog_CommandAborted                   :=  FALSE;
            AxoJog_Error                            :=  FALSE;                   
            AxoJog_ErrorID                          :=  FALSE;    
            IF AxoJogPositive.IsSwitchedOn() THEN
                AxoJog_Direction := AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection;
            ELSIF AxoJogNegative.IsSwitchedOn() THEN
                AxoJog_Direction := AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#NegativeDirection;
            END_IF;

            IF AxoJogPositive.IsSwitchedOn() AND EnablePositive OR AxoJogNegative.IsSwitchedOn() AND EnableNegative THEN
                IF AxoJogPositive.StartMotion OR AxoJogNegative.StartMotion THEN
                    AxoJogPositive.StartMotion          :=  FALSE;
                    AxoJogNegative.StartMotion          :=  FALSE;
                    AxoHalt_Task.Restore();
                END_IF;
                AxoMoveVelocity_ContinuousUpdate       := FALSE;
                AxoMoveVelocity_Velocity               := AxoJog_Velocity;
                AxoMoveVelocity_Acceleration           := AxoJog_Acceleration;
                AxoMoveVelocity_Deceleration           := AxoJog_Deceleration;
                AxoMoveVelocity_Jerk                   := AxoJog_Jerk;
                AxoMoveVelocity_Direction              := AxoJog_Direction;

                THIS.AxoMoveVelocity();
                AxoJogInVelocity                        :=  AxoMoveVelocity_InVelocity;
                AxoJog_Active                           :=  AxoMoveVelocity_Active;
                AxoJog_Done                             :=  FALSE;                   
                AxoJog_Busy                             :=  AxoMoveVelocity_Busy;                   
                AxoJog_CommandAborted                   :=  AxoMoveVelocity_CommandAborted;
                AxoJog_Error                            :=  AxoMoveVelocity_Error;                   
                AxoJog_ErrorID                          :=  AxoMoveVelocity_ErrorID;    
            ELSIF AxoJogPositive.StopMotion OR AxoJogNegative.StopMotion THEN
                AxoMoveVelocity_Task.Restore();
                AxoHalt_Deceleration                   := AxoJog_Deceleration;
                AxoHalt_Jerk                           := AxoJog_Jerk;
                THIS.AxoHalt();
                AxoJogInVelocity                        :=  AxoMoveVelocity_InVelocity;
                AxoJog_Active                           :=  AxoHalt_Active;
                AxoJog_Done                             :=  TRUE;                   
                AxoJog_Busy                             :=  AxoHalt_Busy;                   
                AxoJog_CommandAborted                   :=  AxoHalt_CommandAborted;
                AxoJog_Error                            :=  AxoHalt_Error;                   
                AxoJog_ErrorID                          :=  AxoHalt_ErrorID;    
                AxoJogPositive.StopMotion := FALSE;
                AxoJogNegative.StopMotion := FALSE;
            END_IF;
            //******************************************
            _error := FALSE;
            _warning := FALSE;
            IF AxoPower_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoPower_ErrorID);
                END_IF;
            ELSIF AxoStop_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoStop_ErrorID);
                END_IF;
            ELSIF AxoHalt_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoHalt_ErrorID);
                END_IF;
            ELSIF AxoHome_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoHome_ErrorID);
                END_IF;
            ELSIF AxoMoveAbsolute_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoMoveAbsolute_ErrorID);
                END_IF;
            ELSIF AxoMoveRelative_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoMoveRelative_ErrorID);
                END_IF;
            ELSIF AxoMoveAdditive_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoMoveAdditive_ErrorID);
                END_IF;
            ELSIF AxoMoveVelocity_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoMoveVelocity_ErrorID);
                END_IF;
            ELSIF AxoTorqueControl_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoTorqueControl_ErrorID);
                END_IF;
            ELSIF AxoSetPosition_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoSetPosition_ErrorID);
                END_IF;
            ELSIF AxoSetOverride_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoSetOverride_ErrorID);
                END_IF;
            ELSIF AxoReadParameter_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoReadParameter_ErrorID);
                END_IF;
            ELSIF AxoReadRealParameter_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoReadRealParameter_ErrorID);
                END_IF;
            ELSIF AxoReadBoolParameter_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoReadBoolParameter_ErrorID);
                END_IF;
            ELSIF AxoWriteParameter_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoWriteParameter_ErrorID);
                END_IF;
            ELSIF AxoWriteRealParameter_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoWriteRealParameter_ErrorID);
                END_IF;
            ELSIF AxoWriteBoolParameter_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoWriteBoolParameter_ErrorID);
                END_IF;
            ELSIF AxoReadDigitalInput_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoReadDigitalInput_ErrorID);
                END_IF;
            ELSIF AxoReadDigitalOutput_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoReadDigitalOutput_ErrorID);
                END_IF;
            ELSIF AxoWriteDigitalOutput_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoWriteDigitalOutput_ErrorID);
                END_IF;
            ELSIF AxoReadActualPosition_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoReadActualPosition_ErrorID);
                END_IF;
            ELSIF AxoReadActualVelocity_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoReadActualVelocity_ErrorID);
                END_IF;
            ELSIF AxoReadActualTorque_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoReadActualTorque_ErrorID);
                END_IF;
            ELSIF AxoReadStatus_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoReadStatus_ErrorID);
                END_IF;
            ELSIF AxoReadMotionState_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoReadMotionState_ErrorID);
                END_IF;
            ELSIF AxoReadAxisInfo_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoReadAxisInfo_ErrorID);
                END_IF;
            ELSIF AxoReadAxisError_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoReadAxisError_ErrorID);
                END_IF;
            ELSIF AxoReset_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoReset_ErrorID);
                END_IF;
            ELSIF AxoJog_Error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(AxoJog_ErrorID);
                END_IF;
            ELSIF NOT EnablePositive THEN
                _warning := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := ULINT#300;
                END_IF;
            ELSIF NOT EnableNegative THEN
                _warning := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := ULINT#301;
                END_IF;
            END_IF;

            _category   :=  eAxoMessageCategory#Error;
            IF _warning AND NOT _error THEN
                _category   :=  eAxoMessageCategory#Warning;
            END_IF;
            Messenger.ActivateOnCondition(_messageCode, (_error OR _warning) AND _messageCode = _lastMessageCode ,_category);
            IF NOT Messenger.IsActive THEN
                IF _error OR _warning THEN
                    _lastMessageCode := _messageCode;
                ELSE
                    _messageCode := ULINT#0;
                END_IF;                          
            END_IF;                          

        END_METHOD

        ///<summary>
		/// Restores this instance . 
        ///</summary>   
        METHOD PROTECTED OVERRIDE Restore: IAxoTask 
            VAR
                _index : INT;
            END_VAR
            DriveStatus.Action.Id := UINT#0;
            DriveStatus.Error.Id  := UINT#0;
            Messenger.Restore();
            TaskMessenger.Restore();

            //AxoPower_Task.Restore();
            AxoStop_Task.Restore();
            AxoHalt_Task.Restore();
            AxoHome_Task.Restore();
            AxoMoveAbsolute_Task.Restore();
            AxoMoveRelative_Task.Restore();
            AxoMoveAdditive_Task.Restore();
            AxoMoveVelocity_Task.Restore();
            AxoTorqueControl_Task.Restore();
            AxoSetPosition_Task.Restore();
            AxoSetOverride_Task.SwitchOff();
            AxoReadParameter_Task.SwitchOff();
            AxoReadRealParameter_Task.SwitchOff();
            AxoReadBoolParameter_Task.SwitchOff();
            AxoWriteParameter_Task.Restore();
            AxoWriteRealParameter_Task.Restore();
            AxoWriteBoolParameter_Task.Restore();
            AxoReadDigitalInput_Task.SwitchOff();
            AxoReadDigitalOutput_Task.SwitchOff();
            AxoWriteDigitalOutput_Task.Restore();
            AxoReadActualPosition_Task.SwitchOff();
            AxoReadActualVelocity_Task.SwitchOff();
            AxoReadActualTorque_Task.SwitchOff();
            AxoReadStatus_Task.SwitchOff();
            AxoReadMotionState_Task.SwitchOff();
            AxoReadAxisInfo_Task.SwitchOff();
            AxoReadAxisError_Task.SwitchOff();
            AxoReset_Task.Restore();
            AxoJogPositive.RemoteSwitchOn := FALSE;
            AxoJogPositive.StartMotion := FALSE;
            AxoJogPositive.StopMotion := FALSE;
            AxoJogNegative.RemoteSwitchOn := FALSE;
            AxoJogNegative.StartMotion := FALSE;
            AxoJogNegative.StopMotion := FALSE;
             
            RestoreTask.DoneWhen(TRUE);
        END_METHOD

        ///<summary>
		/// Custom logic for the manual control.
        ///</summary>   
        METHOD PROTECTED OVERRIDE ManualControl
            //***********Stop*********************************
            _AxoStop_Deceleration                   := AxoStop_Deceleration;
            _AxoStop_Jerk                           := AxoStop_Jerk;
            //***********Halt*********************************
            _AxoHalt_Deceleration                   := AxoHalt_Deceleration;
            _AxoHalt_Jerk                           := AxoHalt_Jerk;
            //***********Home*********************************
            _AxoHome_Position                       := AxoHome_Position;
            _AxoHome_HommingMode                    := AxoHome_HommingMode;
            _AxoHome_Velocity                       := AxoHome_Velocity;
            _AxoHome_Acceleration                   := AxoHome_Acceleration;
            _AxoHome_Deceleration                   := AxoHome_Deceleration;
            //***********MoveAbsolute*************************
            _AxoMoveAbsolute_ContinuousUpdate       := AxoMoveAbsolute_ContinuousUpdate;
            _AxoMoveAbsolute_Position               := AxoMoveAbsolute_Position;
            _AxoMoveAbsolute_Velocity               := AxoMoveAbsolute_Velocity;
            _AxoMoveAbsolute_Acceleration           := AxoMoveAbsolute_Acceleration;
            _AxoMoveAbsolute_Deceleration           := AxoMoveAbsolute_Deceleration;
            _AxoMoveAbsolute_Jerk                   := AxoMoveAbsolute_Jerk;
            _AxoMoveAbsolute_Direction              := AxoMoveAbsolute_Direction;
            //***********MoveRelative*************************
            _AxoMoveRelative_ContinuousUpdate       := AxoMoveRelative_ContinuousUpdate;
            _AxoMoveRelative_Distance               := AxoMoveRelative_Distance;
            _AxoMoveRelative_Velocity               := AxoMoveRelative_Velocity;
            _AxoMoveRelative_Acceleration           := AxoMoveRelative_Acceleration;
            _AxoMoveRelative_Deceleration           := AxoMoveRelative_Deceleration;
            _AxoMoveRelative_Jerk                   := AxoMoveRelative_Jerk;
            //***********MoveAdditive*************************
            _AxoMoveAdditive_ContinuousUpdate       := AxoMoveAdditive_ContinuousUpdate;
            _AxoMoveAdditive_Distance               := AxoMoveAdditive_Distance;
            _AxoMoveAdditive_Velocity               := AxoMoveAdditive_Velocity;
            _AxoMoveAdditive_Acceleration           := AxoMoveAdditive_Acceleration;
            _AxoMoveAdditive_Deceleration           := AxoMoveAdditive_Deceleration;
            _AxoMoveAdditive_Jerk                   := AxoMoveAdditive_Jerk;
            //***********MoveVelocity*************************
            _AxoMoveVelocity_ContinuousUpdate       := AxoMoveVelocity_ContinuousUpdate;
            _AxoMoveVelocity_Velocity               := AxoMoveVelocity_Velocity;
            _AxoMoveVelocity_Acceleration           := AxoMoveVelocity_Acceleration;
            _AxoMoveVelocity_Deceleration           := AxoMoveVelocity_Deceleration;
            _AxoMoveVelocity_Jerk                   := AxoMoveVelocity_Jerk;
            _AxoMoveVelocity_Direction              := AxoMoveVelocity_Direction;
            //***********TorqueControl************************
            _AxoTorqueControl_ContinuousUpdate      := AxoTorqueControl_ContinuousUpdate;
            _AxoTorqueControl_Torque                := AxoTorqueControl_Torque;
            _AxoTorqueControl_TorqueRamp            := AxoTorqueControl_TorqueRamp;
            _AxoTorqueControl_Velocity              := AxoTorqueControl_Velocity;
            _AxoTorqueControl_Acceleration          := AxoTorqueControl_Acceleration;
            _AxoTorqueControl_Deceleration          := AxoTorqueControl_Deceleration;
            _AxoTorqueControl_Jerk                  := AxoTorqueControl_Jerk;
            _AxoTorqueControl_Direction             := AxoTorqueControl_Direction;
            //***********SetPosition**************************
            _AxoSetPosition_Position                := AxoSetPosition_Position;
            _AxoSetPosition_Relative                := AxoSetPosition_Relative;
            _AxoSetPosition_ExecutionMode           := AxoSetPosition_ExecutionMode;
            //***********SetOverride**************************
            _AxoSetOverride_VelFactor               := AxoSetOverride_VelFactor;
            _AxoSetOverride_AccFactor               := AxoSetOverride_AccFactor;
            _AxoSetOverride_JerkFactor              := AxoSetOverride_JerkFactor;
            //***********ReadParameter************************
            _AxoReadParameter_ParameterNumber       := AxoReadParameter_ParameterNumber;
            //***********ReadRealParameter************************
            _AxoReadRealParameter_ParameterNumber       := AxoReadRealParameter_ParameterNumber;
            //***********ReadBoolParameter********************
            _AxoReadBoolParameter_ParameterNumber   := AxoReadBoolParameter_ParameterNumber;
            //***********WriteParameter***********************
            _AxoWriteParameter_ParameterNumber      := AxoWriteParameter_ParameterNumber;
            _AxoWriteParameter_Value                := AxoWriteParameter_Value;
            _AxoWriteParameter_ExecutionMode        := AxoWriteParameter_ExecutionMode;
            //***********WriteRealParameter*******************
            _AxoWriteRealParameter_ParameterNumber  := AxoWriteRealParameter_ParameterNumber;
            _AxoWriteRealParameter_Value            := AxoWriteRealParameter_Value;
            _AxoWriteRealParameter_ExecutionMode    := AxoWriteRealParameter_ExecutionMode;
            //***********WriteBoolParameter*******************
            _AxoWriteBoolParameter_ParameterNumber  := AxoWriteBoolParameter_ParameterNumber;
            _AxoWriteBoolParameter_Value            := AxoWriteBoolParameter_Value;
            _AxoWriteBoolParameter_ExecutionMode    := AxoWriteBoolParameter_ExecutionMode;
            //***********ReadDigitalInput*********************
            _AxoReadDigitalInput_InputNumber        := AxoReadDigitalInput_InputNumber;
            //***********ReadDigitalOutput********************
            _AxoReadDigitalOutput_OutputNumber      := AxoReadDigitalOutput_OutputNumber;
            //***********WriteDigitalOutput*******************
            _AxoWriteDigitalOutput_OutputNumber     := AxoWriteDigitalOutput_OutputNumber;
            _AxoWriteDigitalOutput_Value            := AxoWriteDigitalOutput_Value;
            _AxoWriteDigitalOutput_ExecutionMode    := AxoWriteDigitalOutput_ExecutionMode;
            //***********ReadMotionState**********************
            _AxoReadMotionState_Source              := AxoReadMotionState_Source;
            //***********Jog**********************************
            _AxoJog_Velocity                        := AxoJog_Velocity;
            _AxoJog_Acceleration                    := AxoJog_Acceleration;
            _AxoJog_Deceleration                    := AxoJog_Deceleration;
            _AxoJog_Jerk                            := AxoJog_Jerk;
            _AxoJog_Direction                       := AxoJog_Direction;
            _AxoJogInVelocity                       := AxoJogInVelocity;
            _AxoJog_Active                          := AxoJog_Active;

            IF AxoJog_Active THEN
                _AxoMoveVelocity_ContinuousUpdate       := FALSE;
                _AxoMoveVelocity_Velocity               := AxoJog_Velocity;
                _AxoMoveVelocity_Acceleration           := AxoJog_Acceleration;
                _AxoMoveVelocity_Deceleration           := AxoJog_Deceleration;
                _AxoMoveVelocity_Jerk                   := AxoJog_Jerk;
                _AxoMoveVelocity_Direction              := AxoJog_Direction;

                _AxoHalt_Deceleration                   := AxoJog_Deceleration;
                _AxoHalt_Jerk                           := AxoJog_Jerk;
            END_IF;
            //************************************************
            AxoPower_Task.Manual();
        END_METHOD

        ///<summary>
        /// This method commands the axis to perform the «search home» sequence. The ‘Position’ input is used to set the absolute 
        /// position when reference signal is detected. This method completes at ‘Standstill’ if it was started in ‘Standstill’.
        ///</summary>
        METHOD PUBLIC AxoHome   : IAxoTaskState
            VAR_INPUT
                Position        :   LREAL;                      //  Absolute position when the reference signal is detected             
                HommingMode     :   INT;                        //  Required homming mode           
                Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Reference known and set sucessfully
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
             END_VAR

            _AxoHome_Position    :=  Position;
            _AxoHome_HommingMode :=  HommingMode;
            _AxoHome_Velocity    :=  Velocity;
            _AxoHome_Acceleration:=  Acceleration;
            _AxoHome_Deceleration:=  Deceleration;

            Done            :=  AxoHome_Done;
            Busy            :=  AxoHome_Busy;
            Active          :=  AxoHome_Active;
            CommandAborted  :=  AxoHome_CommandAborted;
            Error           :=  AxoHome_Error;
            ErrorID         :=  AxoHome_ErrorID;

            AxoHome := AxoHome_Task.Invoke();
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion stop and transfers the axis to the state ‘Stopping’. It aborts any
        /// ongoing method execution. While the axis is in state ‘Stopping’, no other method can perform any motion on this axis. 
        ///</summary>       
        METHOD PUBLIC AxoStop   : IAxoTaskState
            VAR_INPUT
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ [u/s2]
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Zero velocity reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by switching off power (only possibility to abort)                
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
             END_VAR

            _AxoStop_Deceleration   :=  Deceleration;
            _AxoStop_Jerk           :=  Jerk;                     
 
            Done            :=  AxoStop_Done;
            Busy            :=  AxoStop_Busy;
            Active          :=  AxoStop_Active;
            CommandAborted  :=  AxoStop_CommandAborted;
            Error           :=  AxoStop_Error;
            ErrorID         :=  AxoStop_ErrorID;

            AxoStop := AxoStop_Task.Invoke();
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion stop. The axis is moved to the state ‘DiscreteMotion’, until the
        /// velocity is zero. With the ‘Done’ output set, the state is transferred to ‘Standstill’.
        ///</summary>
        METHOD PUBLIC AxoHalt : IAxoTaskState
            VAR_INPUT
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ [u/s2]
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Zero velocity reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by switching off power (only possibility to abort)                
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
             END_VAR

            _AxoHalt_Deceleration   :=  Deceleration;
            _AxoHalt_Jerk           :=  Jerk;                     

            Done            :=  AxoHalt_Done;
            Busy            :=  AxoHalt_Busy;
            Active          :=  AxoHalt_Active;
            CommandAborted  :=  AxoHalt_CommandAborted;
            Error           :=  AxoHalt_Error;
            ErrorID         :=  AxoHalt_ErrorID;

            AxoHalt := AxoHalt_Task.Invoke();
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion to a specified absolute position.
        ///<summary>
        METHOD PUBLIC AxoMoveAbsolute : IAxoTaskState
            VAR_INPUT
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Position        :   LREAL;                      //  Commanded ‘Position’ for the motion (in technical unit [u]) (negative or positive)                             
                Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
                Direction       :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;         //  Enum type (1-of-4 values: PositiveDirection, ShortestWay, NegativeDirection, CurrentDirection)
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Commanded position finally reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
             END_VAR

            _AxoMoveAbsolute_ContinuousUpdate   := ContinuousUpdate;
            _AxoMoveAbsolute_Position           := Position;
            _AxoMoveAbsolute_Velocity           := Velocity;
            _AxoMoveAbsolute_Acceleration       := Acceleration;
            _AxoMoveAbsolute_Deceleration       := Deceleration;
            _AxoMoveAbsolute_Jerk               := Jerk;
            _AxoMoveAbsolute_Direction          := Direction;

            Done            :=  AxoMoveAbsolute_Done;
            Busy            :=  AxoMoveAbsolute_Busy;
            Active          :=  AxoMoveAbsolute_Active;
            CommandAborted  :=  AxoMoveAbsolute_CommandAborted;
            Error           :=  AxoMoveAbsolute_Error;
            ErrorID         :=  AxoMoveAbsolute_ErrorID;

            AxoMoveAbsolute := AxoMoveAbsolute_Task.Invoke();
        END_METHOD

        ///<summary>
        /// This method  commands a controlled motion of a specified distance relative to the set position at the time of the execution.
        ///<summary>
        METHOD PUBLIC AxoMoveRelative : IAxoTaskState
            VAR_INPUT
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Distance        :   LREAL;                      //  Relative distance for the motion (in technical unit [u]                             
                Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Commanded distance reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
             END_VAR

            _AxoMoveRelative_ContinuousUpdate   :=  ContinuousUpdate;
            _AxoMoveRelative_Distance           :=  Distance;
            _AxoMoveRelative_Velocity           :=  Velocity;
            _AxoMoveRelative_Acceleration       :=  Acceleration;
            _AxoMoveRelative_Deceleration       :=  Deceleration;
            _AxoMoveRelative_Jerk               :=  Jerk;

            Done            :=  AxoMoveRelative_Done;
            Busy            :=  AxoMoveRelative_Busy;
            Active          :=  AxoMoveRelative_Active;
            CommandAborted  :=  AxoMoveRelative_CommandAborted;
            Error           :=  AxoMoveRelative_Error;
            ErrorID         :=  AxoMoveRelative_ErrorID;

            AxoMoveRelative :=  AxoMoveRelative_Task.Invoke();
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion of a specified relative distance additional to the most recent 
        /// commanded position in the axis state ‘DiscreteMotion’. The most recent commanded position may be the result of a 
        /// previous MC_MoveAdditive motion which was aborted. If the method is activated in the axis state ‘ContinuousMotion’, the
        /// specified relative distance is added to the set position at the time of the execution.
        ///<summary>
        METHOD PUBLIC AxoMoveAdditive  : IAxoTaskState
            VAR_INPUT
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Distance        :   LREAL;                      //  Relative distance for the motion (in technical unit [u]                             
                Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Commanded distance reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
             END_VAR

             _AxoMoveAdditive_ContinuousUpdate   :=  ContinuousUpdate;
            _AxoMoveAdditive_Distance           :=  Distance;
            _AxoMoveAdditive_Velocity           :=  Velocity;
            _AxoMoveAdditive_Acceleration       :=  Acceleration;
            _AxoMoveAdditive_Deceleration       :=  Deceleration;
            _AxoMoveAdditive_Jerk               :=  Jerk;

            Done            :=  AxoMoveAdditive_Done;
            Busy            :=  AxoMoveAdditive_Busy;
            Active          :=  AxoMoveAdditive_Active;
            CommandAborted  :=  AxoMoveAdditive_CommandAborted;
            Error           :=  AxoMoveAdditive_Error;
            ErrorID         :=  AxoMoveAdditive_ErrorID;

            AxoMoveAdditive := AxoMoveAdditive_Task.Invoke();
        END_METHOD

        ///<summary>
        /// This method commands a never ending controlled motion at a specified velocity.
        ///<summary>
        METHOD PUBLIC AxoMoveVelocity  : IAxoTaskState
            VAR_INPUT
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Velocity        :   LREAL;                      //  Value of the maximum velocity [u/s]. Can be a signed value.
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
                Direction       :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;         //  Enum type (1-of-3 values: PositiveDirection, NegativeDirection, and CurrentDirection. Note: shortest way not applicable)
            END_VAR
            VAR_OUTPUT
                InVelocity      :   BOOL;                       // Commanded velocity reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
             END_VAR

            _AxoMoveVelocity_ContinuousUpdate   :=  ContinuousUpdate;
            _AxoMoveVelocity_Velocity           :=  Velocity;
            _AxoMoveVelocity_Acceleration       :=  Acceleration;
            _AxoMoveVelocity_Deceleration       :=  Deceleration;
            _AxoMoveVelocity_Jerk               :=  Jerk;
            _AxoMoveVelocity_Direction          :=  Direction;

            InVelocity      :=  AxoMoveVelocity_InVelocity;
            Busy            :=  AxoMoveVelocity_Busy;
            Active          :=  AxoMoveVelocity_Active;
            CommandAborted  :=  AxoMoveVelocity_CommandAborted;
            Error           :=  AxoMoveVelocity_Error;
            ErrorID         :=  AxoMoveVelocity_ErrorID;

            AxoMoveVelocity := AxoMoveVelocity_Task.Invoke();
        END_METHOD

        ///<summary>
        /// This method continuously exerts a torque or force of the specified magnitude. This magnitude is 
        /// approached using a defined ramp (‘TorqueRamp’), and the method sets the ‘InTorque’ output if the 
        /// commanded torque level is reached. This method is applicable for force and torque. When there is no external
        /// load, force is applicable. Positive torque is in the positive direction of velocity.
        ///<summary>
        METHOD PUBLIC AxoTorqueControl : IAxoTaskState
            VAR_INPUT
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Torque          :   LREAL;                      //  Value of the torque (Torque or force in technical unit [u])
                TorqueRamp      :   LREAL;                      //  The maximum time derivative of the set value of the torque or force (in technical unit per sec. [u/s]) 
                Velocity        :   LREAL;                      //  Absolute value of the maximum velocity.
                Acceleration    :   LREAL;                      //  Value of the maximum acceleration (acceleration is applicable with same sign of torque and velocity)
                Deceleration    :   LREAL;                      //  Value of the maximum deceleration (deceleration is applicable with opposite signs of torque and velocity)
                Jerk            :   LREAL;                      //  Value of the maximum jerk
                Direction       :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;         //  Enum type (1 of 2 values: PositiveDirection, NegativeDirection or CurrentDirection). Specifies the direction of the torque. (Note: Torque input can be signed value).            
            END_VAR
            VAR_OUTPUT
                InTorque        :   BOOL;                       //  Setpoint value of torque or force equals the commandedvalue
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Active          :   BOOL;                       //  Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       //  ‘Command’ is aborted by another command
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification             
            END_VAR

            _AxoTorqueControl_ContinuousUpdate  :=  ContinuousUpdate;
            _AxoTorqueControl_Torque            :=  Torque;
            _AxoTorqueControl_TorqueRamp        :=  TorqueRamp;
            _AxoTorqueControl_Velocity          :=  Velocity;
            _AxoTorqueControl_Acceleration      :=  Acceleration;
            _AxoTorqueControl_Deceleration      :=  Deceleration;
            _AxoTorqueControl_Jerk              :=  Jerk;
            _AxoTorqueControl_Direction         :=  Direction;

            InTorque        :=  AxoTorqueControl_InTorque;
            Busy            :=  AxoTorqueControl_Busy;
            Active          :=  AxoTorqueControl_Active;
            CommandAborted  :=  AxoTorqueControl_CommandAborted;
            Error           :=  AxoTorqueControl_Error;
            ErrorID         :=  AxoTorqueControl_ErrorID;

            AxoTorqueControl    := AxoTorqueControl_Task.Invoke();
        END_METHOD

        ///<summary>
        /// This method shifts the coordinate system of an axis by manipulating both the set-point position as well as the
        /// actual position of an axis with the same value without any movement caused. (Re-calibration with same following error). 
        /// This can be used for instance for a reference situation. This method can also be used during motion without changing 
        /// the commanded position, which is now positioned in the shifted coordinate system.
        ///<summary>
        METHOD PUBLIC AxoSetPosition   : IAxoTaskState
            VAR_INPUT
                Position        :   LREAL;                      //  Position unit [u] (Means ‘Distance’ if ‘Relative’= TRUE)
                Relative        :   BOOL;                       //  ‘Relative’ distance if True, ‘Absolute’ position if False (= Default)
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  ‘Position’ has new value
                Error           :   BOOL;                       //  Signals that an error has occurred within the FunctionBlock
                ErrorID         :   WORD;                       //  Error identification             
            END_VAR

            _AxoSetPosition_Position         :=  Position;
            _AxoSetPosition_Relative         :=  Relative;
            _AxoSetPosition_ExecutionMode    :=  ExecutionMode;

            Done            :=  AxoSetPosition_Done;
            Error           :=  AxoSetPosition_Error;
            ErrorID         :=  AxoSetPosition_ErrorID;

            AxoSetPosition := AxoSetPosition_Task.Invoke();
        END_METHOD

        ///<summary>
        /// This method sets the values of override for the whole axis, and all functions that are working on that axis. The override
        /// parameters contribute as a factor to the calculation of the commanded velocity, acceleration and jerk of the motion.
        ///<summary>
        METHOD PUBLIC AxoSetOverride   : IAxoToggleTask
            VAR_INPUT
                Enable          :   BOOL;                       //  If SET, it writes the value of the override factor continuously. If RESET it should keep the last value.
                VelFactor       :   LREAL;                      //  New override factor for the velocity
                AccFactor       :   LREAL;                      //  New override factor for the acceleration/deceleration
                JerkFactor      :   LREAL;                      //  New override factor for the jer            
            END_VAR
            VAR_OUTPUT
                Enabled         :   BOOL;                       //  Signals that the override factor(s) is (are) set successfully
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the FumethodnctionBlock
                ErrorID         :   WORD;                       //  Error identification             
            END_VAR

            IF Enable THEN
                _AxoSetOverride_VelFactor   :=  VelFactor;
                _AxoSetOverride_AccFactor   :=  AccFactor;
                _AxoSetOverride_JerkFactor  :=  JerkFactor;

                AxoSetOverride_Task.SwitchOn();
            ELSE
                AxoSetOverride_Task.SwitchOff();
            END_IF;

            AxoSetOverride  := AxoSetOverride_Task;
        END_METHOD

        ///<summary>
        /// This method returns the value of a vendor specific parameter. The returned Value has to be converted to Real
        /// if necessary. If not possible, the vendor has to supply a vendor specific method to read the parameter.
        ///<summary>
        METHOD PUBLIC AxoReadParameter : IAxoToggleTask
            VAR_INPUT
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
                ParameterNumber :   DINT;                       //  Number of the parameter. One can also use symbolic parameter names which are declared as VAR CONST.
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Value           :   DINT;                       //  Value of the specified parameter in the datatype, as specified by the vendor
            END_VAR

            IF Enable THEN
                _AxoReadParameter_ParameterNumber   :=  ParameterNumber;

                AxoReadParameter_Task.SwitchOn();
            ELSE
                AxoReadParameter_Task.SwitchOff();
            END_IF;

            Valid   := AxoReadParameter_Valid;
            Busy    := AxoReadParameter_Busy;
            Error   := AxoReadParameter_Error;
            ErrorID := AxoReadParameter_ErrorID;
            Value   := AxoReadParameter_Value;

            AxoReadParameter  := AxoReadParameter_Task;
        END_METHOD

        ///<summary>
        /// This method returns the value of a vendor specific parameter with datatype REAL
        ///<summary>
        METHOD PUBLIC AxoReadRealParameter : IAxoToggleTask
            VAR_INPUT
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
                ParameterNumber :   DINT;                       //  Number of the parameter. One can also use symbolic parameter names which are declared as VAR CONST.
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Value           :   REAL;                       //  Value of the specified parameter in the datatype, as specified by the vendor
            END_VAR

            IF Enable THEN
                _AxoReadRealParameter_ParameterNumber   :=  ParameterNumber;

                AxoReadRealParameter_Task.SwitchOn();
            ELSE
                AxoReadRealParameter_Task.SwitchOff();
            END_IF;

            Valid   := AxoReadRealParameter_Valid;
            Busy    := AxoReadRealParameter_Busy;
            Error   := AxoReadRealParameter_Error;
            ErrorID := AxoReadRealParameter_ErrorID;
            Value   := AxoReadRealParameter_Value;

            AxoReadRealParameter  := AxoReadRealParameter_Task;
        END_METHOD

        ///<summary>
        /// This method returns the value of a vendor specific parameter with datatype BOOL.
        ///<summary>
        METHOD PUBLIC AxoReadBoolParameter : IAxoToggleTask
            VAR_INPUT
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
                ParameterNumber :   DINT;                       //  Number of the parameter. One can also use symbolic parameter names which are declared as VAR CONST.
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Value           :   BOOL;                       //  Value of the specified parameter in the datatype, as specified by the vendor
            END_VAR

            IF Enable THEN
                _AxoReadBoolParameter_ParameterNumber   :=  ParameterNumber;

                AxoReadBoolParameter_Task.SwitchOn();
            ELSE
                AxoReadBoolParameter_Task.SwitchOff();
            END_IF;

            Valid   := AxoReadBoolParameter_Valid;
            Busy    := AxoReadBoolParameter_Busy;
            Error   := AxoReadBoolParameter_Error;
            ErrorID := AxoReadBoolParameter_ErrorID;
            Value   := AxoReadBoolParameter_Value;

            AxoReadBoolParameter  := AxoReadBoolParameter_Task;            
        END_METHOD

        ///<summary>
        /// This method modifies the value of a vendor specific parameter.
        ///<summary>
        METHOD PUBLIC AxoWriteParameter : IAxoTaskState
            VAR_INPUT
                ParameterNumber :   DINT;                       //  Number of the parameter (correspondence between number andparameter is specified in the table above)
                Value           :   DINT;                       //  New value of the specified parameter
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  Parameter successfully written
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
                Error           :   BOOL;                       //  Signals that an error has occurred within the method 
                ErrorID         :   WORD;                       //  Error identification
            END_VAR

            _AxoWriteParameter_ParameterNumber  :=  ParameterNumber;
            _AxoWriteParameter_Value            :=  Value;
            _AxoWriteParameter_ExecutionMode    :=  ExecutionMode;

            Done                :=  AxoWriteParameter_Done;
            Busy                :=  AxoWriteParameter_Busy;
            Error               :=  AxoWriteParameter_Error;
            ErrorID             :=  AxoWriteParameter_ErrorID;

            AxoWriteParameter   :=  AxoWriteParameter_Task.Invoke();
    END_METHOD

        ///<summary>
        /// This method modifies the value of a vendor specific parameter of type REAL.
        ///<summary>
        METHOD PUBLIC AxoWriteRealParameter    : IAxoTaskState
            VAR_INPUT
                ParameterNumber :   DINT;                       //  Number of the parameter (correspondence between number andparameter is specified in the table above)
                Value           :   REAL;                       //  New value of the specified parameter
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  Parameter successfully written
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
            END_VAR

            _AxoWriteRealParameter_ParameterNumber  :=  ParameterNumber;
            _AxoWriteRealParameter_Value            :=  Value;
            _AxoWriteRealParameter_ExecutionMode    :=  ExecutionMode;

            Done                    :=  AxoWriteRealParameter_Done;
            Busy                    :=  AxoWriteRealParameter_Busy;
            Error                   :=  AxoWriteRealParameter_Error;
            ErrorID                 :=  AxoWriteRealParameter_ErrorID;

            AxoWriteRealParameter   :=  AxoWriteRealParameter_Task.Invoke();
        END_METHOD

        ///<summary>
        /// This method modifies the value of a vendor specific parameter of type BOOL.
        ///<summary>
        METHOD PUBLIC AxoWriteBoolParameter    : IAxoTaskState
            VAR_INPUT
                ParameterNumber :   DINT;                       //  Number of the parameter (correspondence between number andparameter is specified in the table above)
                Value           :   BOOL;                       //  New value of the specified parameter
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  Parameter successfully written
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
            END_VAR

            _AxoWriteBoolParameter_ParameterNumber  :=  ParameterNumber;
            _AxoWriteBoolParameter_Value            :=  Value;
            _AxoWriteBoolParameter_ExecutionMode    :=  ExecutionMode;

            Done                    :=  AxoWriteBoolParameter_Done;
            Busy                    :=  AxoWriteBoolParameter_Busy;
            Error                   :=  AxoWriteBoolParameter_Error;
            ErrorID                 :=  AxoWriteBoolParameter_ErrorID;

            AxoWriteBoolParameter   :=  AxoWriteBoolParameter_Task.Invoke();
        END_METHOD

        ///<summary>
        /// This method gives access to the value of the input, referenced by the datatype MC_INPUT_REF. 
        /// It provides the value of the referenced input (BOOL).
        ///<summary>
        METHOD PUBLIC AxoReadDigitalInput  : IAxoToggleTask
            VAR_INPUT
                Enable          :   BOOL;                       //  Get the value of the selected input signal continuously while enabled
                InputNumber     :   INT;                        //  Selects the input. Can be part of MC_INPUT_REF, if only one single input is referenced.                
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Value           :   BOOL;                       //  The value of the selected input signal
            END_VAR

            IF Enable THEN
                _AxoReadDigitalInput_InputNumber   :=  InputNumber;

                AxoReadDigitalInput_Task.SwitchOn();
            ELSE
                AxoReadDigitalInput_Task.SwitchOff();
            END_IF;

            Valid               :=  AxoReadDigitalInput_Valid;
            Busy                :=  AxoReadDigitalInput_Busy;
            Error               :=  AxoReadDigitalInput_Error;
            ErrorID             :=  AxoReadDigitalInput_ErrorID;
            Value               :=  AxoReadDigitalInput_Value;

            AxoReadDigitalInput := AxoReadDigitalInput_Task;   
        END_METHOD

        ///<summary>
        /// This method provides access to the value of a digital output, referenced by the datatype MC_OUTPUT_REF. 
        /// It provides the value of the referenced output (BOOL).
        ///<summary>
        METHOD PUBLIC AxoReadDigitalOutput : IAxoToggleTask
            VAR_INPUT
                Enable          :   BOOL;                       //  Get the value of the selected output signal continuously while enabled
                OutputNumber    :   INT;                        //  Selects the output. Can be part of MC_OUTPUT_REF, if only one single output is referenced.                
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Value           :   BOOL;                       //  The value of the selected output signal
            END_VAR

            IF Enable THEN
                _AxoReadDigitalOutput_OutputNumber   :=  OutputNumber;

                AxoReadDigitalOutput_Task.SwitchOn();
            ELSE
                AxoReadDigitalOutput_Task.SwitchOff();
            END_IF;

            Valid   := AxoReadDigitalOutput_Valid;
            Busy    :=  AxoReadDigitalOutput_Busy;
            Error   :=  AxoReadDigitalOutput_Error;
            ErrorID :=  AxoReadDigitalOutput_ErrorID;
            Value   := AxoReadDigitalOutput_Value;

            AxoReadDigitalOutput  := AxoReadDigitalOutput_Task;   
        END_METHOD

        ///<summary>
        /// This method writes a value to the output referenced by the argument ‘Output’ once (with rising edge of Execute)
        ///<summary>
        METHOD PUBLIC AxoWriteDigitalOutput    : IAxoTaskState
            VAR_INPUT
                OutputNumber    :   INT;                        //  Selects the output. Can be part of MC_OUTPUT_REF, if only one single output is referenced.                
                Value           :   BOOL;                       //  The value of the selected output signal
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  Writing of the output signal value is done
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
            END_VAR

            _AxoWriteDigitalOutput_OutputNumber     :=  OutputNumber;
            _AxoWriteDigitalOutput_Value            :=  Value;
            _AxoWriteDigitalOutput_ExecutionMode    :=  ExecutionMode;

            Done        :=  AxoWriteDigitalOutput_Done;
            Busy        :=  AxoWriteDigitalOutput_Busy;
            Error       :=  AxoWriteDigitalOutput_Error;
            ErrorID     :=  AxoWriteDigitalOutput_ErrorID;

            AxoWriteDigitalOutput   := AxoWriteDigitalOutput_Task.Invoke();
        END_METHOD

        ///<summary>
        /// This method returns the actual position.
        ///<summary>
        METHOD PUBLIC AxoReadActualPosition : IAxoToggleTask
            VAR_INPUT
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Position        :   LREAL;                      //  New absolute position (in axis’ unit [u])
            END_VAR

            IF Enable THEN
                AxoReadActualPosition_Task.SwitchOn();
            ELSE
                AxoReadActualPosition_Task.SwitchOff();
            END_IF;

            Valid       := AxoReadActualPosition_Valid;
            Busy        :=  AxoReadActualPosition_Busy;
            Error       :=  AxoReadActualPosition_Error;
            ErrorID     :=  AxoReadActualPosition_ErrorID;
            Position    := AxoReadActualPosition_Value;

            AxoReadActualPosition  := AxoReadActualPosition_Task;
        END_METHOD

        ///<summary>
        /// This method returns the value of the actual velocity as long as ‘Enable’ is set. ‘Valid’ is true when the 
        /// dataoutput ‘Velocity’ is valid. If ‘Enable’ is Reset, the data loses its validity, and all outputs are reset,
        /// no matter if new data is available.
        ///<summary>
        METHOD PUBLIC AxoReadActualVelocity    : IAxoToggleTask
            VAR_INPUT
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Velocity        :   LREAL;                      //  The value of the actual velocity (in axis’ unit [u/s])
            END_VAR

            IF Enable THEN
                AxoReadActualVelocity_Task.SwitchOn();
            ELSE
                AxoReadActualVelocity_Task.SwitchOff();
            END_IF;

            Valid       :=  AxoReadActualVelocity_Valid;
            Busy        :=  AxoReadActualVelocity_Busy;
            Error       :=  AxoReadActualVelocity_Error;
            ErrorID     :=  AxoReadActualVelocity_ErrorID;
            Velocity    :=  AxoReadActualVelocity_Value;

            AxoReadActualVelocity  := AxoReadActualVelocity_Task;
        END_METHOD

        ///<summary>
        /// This method returns the value of the actual torque or force as long as ‘Enable’ is set. ‘Valid’ is true when the
        /// data-output ‘Torque’ is valid. If ‘Enable’ is Reset, the data loses its validity, and ‘Valid’ is also reset, 
        /// no matter if new data is available.        
        ///<summary>
        METHOD PUBLIC AxoReadActualTorque  : IAxoToggleTask
            VAR_INPUT
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Torque          :   LREAL;                      //  The value of the actual torque or force (in technical units)
            END_VAR

            IF Enable THEN
                AxoReadActualTorque_Task.SwitchOn();
            ELSE
                AxoReadActualTorque_Task.SwitchOff();
            END_IF;

            Valid   :=  AxoReadActualTorque_Valid;
            Busy    :=  AxoReadActualTorque_Busy;
            Error   :=  AxoReadActualTorque_Error;
            ErrorID :=  AxoReadActualTorque_ErrorID;
            Torque  :=  AxoReadActualTorque_Value;

            AxoReadActualTorque  := AxoReadActualTorque_Task;
        END_METHOD

        ///<summary>
        /// This method returns in detail the status of the state diagram of the axis
        ///<summary>
        METHOD PUBLIC AxoReadStatus    : IAxoToggleTask
            VAR_INPUT
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                ErrorStop       :   BOOL;                       //  See state diagram
                Disabled        :   BOOL;                       //  See state diagram
                Stopping        :   BOOL;                       //  See state diagram
                Homing          :   BOOL;                       //  See state diagram
                Standstill      :   BOOL;                       //  See state diagram
                DiscreteMotion  :   BOOL;                       //  See state diagram
                ContinuousMotion:   BOOL;                       //  See state diagram
                SynchronizedMotion: BOOL;                       //  See state diagram
            END_VAR

            IF Enable THEN
                AxoReadStatus_Task.SwitchOn();
            ELSE
                AxoReadStatus_Task.SwitchOff();
            END_IF;

            Valid               :=  AxoReadStatus_Valid;
            Busy                :=  AxoReadStatus_Busy;
            Error               :=  AxoReadStatus_Error;
            ErrorID             :=  AxoReadStatus_ErrorID;
            ErrorStop           :=  AxoReadStatus_ErrorStop;
            Disabled            :=  AxoReadStatus_Disabled;
            Stopping            :=  AxoReadStatus_Stopping;
            Homing              :=  AxoReadStatus_Homing;
            Standstill          :=  AxoReadStatus_Standstill;
            DiscreteMotion      :=  AxoReadStatus_DiscreteMotion;
            ContinuousMotion    :=  AxoReadStatus_ContinuousMotion;
            SynchronizedMotion  :=  AxoReadStatus_SynchronizedMotion;

            AxoReadStatus  := AxoReadStatus_Task;
        END_METHOD

        ///<summary>
        /// This method returns in detail the status of the axis with respect to the motion currently in progress. 
        ///<summary>
        METHOD PUBLIC AxoReadMotionState   : IAxoToggleTask
            VAR_INPUT
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
                Source          :   AXOpen.Components.Abstractions.Drives.eAxoSource;                 //  Defines the source of the relevant data: CommandedValue;SetValue, ActualValue.
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                ConstantVelocity:   BOOL;                       //  Velocity is constant. Velocity may be 0. For the actual value a window is applicable (window is vendor specific)
                Accelerating    :   BOOL;                       //  Increasing the absolute value of the velocity
                Decelerating    :   BOOL;                       //  Decreasing the absolute value of the velocity
                DirectionPositive:  BOOL;                       //  Signals that the position is increasing
                DirectionNegative:  BOOL;                       //  Signals that the position is decreasing
            END_VAR

            IF Enable THEN
                AxoReadMotionState_Task.SwitchOn();
            ELSE
                AxoReadMotionState_Task.SwitchOff();
            END_IF;

            Valid               :=  AxoReadMotionState_Valid;
            Busy                :=  AxoReadMotionState_Busy;
            Error               :=  AxoReadMotionState_Error;
            ErrorID             :=  AxoReadMotionState_ErrorID;
            ConstantVelocity    :=  AxoReadMotionState_ConstantVelocity;
            Accelerating        :=  AxoReadMotionState_Accelerating;
            Decelerating        :=  AxoReadMotionState_Decelerating;
            DirectionPositive   :=  AxoReadMotionState_DirectionPositive;
            DirectionNegative   :=  AxoReadMotionState_DirectionNegative;

            AxoReadMotionState  := AxoReadMotionState_Task;
        END_METHOD

        ///<summary>
        /// This method reads information concerning an axis, like modes, inputs directly related to the axis, 
        /// and certain status information.
        ///<summary>
        METHOD PUBLIC AxoReadAxisInfo  : IAxoToggleTask
            VAR_INPUT
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                HomeAbsSwitch   :   BOOL;                       //  Digital home switch input is active
                LimitSwitchPos  :   BOOL;                       //  Positive hardware end switch is active
                LimitSwitchNeg  :   BOOL;                       //  Negative hardware end switch is active
                Simulation      :   BOOL;                       //  Axis is in simulation mode (e.g. motor is simulated)
                CommunicationReady: BOOL;                       //  “Network” is initialized and ready for communication
                ReadyForPowerOn :   BOOL;                       //  Drive is ready to be enabled (power on)
                PowerOn         :   BOOL;                       //  If TRUE shows that the power stage is switched ON
                IsHomed         :   BOOL;                       //  The absolute reference position is known for the axis (axis is homed)
                AxisWarning     :   BOOL;                       //  Warning(s) on the axis is present
            END_VAR
            
            IF Enable THEN
                AxoReadAxisInfo_Task.SwitchOn();
            ELSE
                AxoReadAxisInfo_Task.SwitchOff();
            END_IF;

            Valid               :=  AxoReadAxisInfo_Valid;
            Busy                :=  AxoReadAxisInfo_Busy;
            Error               :=  AxoReadAxisInfo_Error;
            ErrorID             :=  AxoReadAxisInfo_ErrorID;
            HomeAbsSwitch       :=  AxoReadAxisInfo_HomeAbsSwitch;
            LimitSwitchPos      :=  AxoReadAxisInfo_LimitSwitchPos;
            LimitSwitchNeg      :=  AxoReadAxisInfo_LimitSwitchNeg;
            Simulation          :=  AxoReadAxisInfo_Simulation;
            CommunicationReady  :=  AxoReadAxisInfo_CommunicationReady;
            ReadyForPowerOn     :=  AxoReadAxisInfo_ReadyForPowerOn;
            PowerOn             :=  AxoReadAxisInfo_PowerOn;
            IsHomed             :=  AxoReadAxisInfo_IsHomed;
            AxisWarning         :=  AxoReadAxisInfo_AxisWarning;

            AxoReadAxisInfo  := AxoReadAxisInfo_Task;
        END_METHOD

        ///<summary>
        /// This method presents general axis errors not relating to the methods. 
        /// (for instance axis errors, drive errors, communication errors)
        ///<summary>
        METHOD PUBLIC AxoReadAxisError : IAxoToggleTask
            VAR_INPUT
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                AxisErrorID     :   DWORD;                      //  The value of the axis error. These values are vendor specific
            END_VAR
            
            IF Enable THEN
                AxoReadAxisError_Task.SwitchOn();
            ELSE
                AxoReadAxisError_Task.SwitchOff();
            END_IF;

            Valid           :=  AxoReadAxisError_Valid;
            Busy            :=  AxoReadAxisError_Busy;
            Error           :=  AxoReadAxisError_Error;
            ErrorID         :=  AxoReadAxisError_ErrorID;
            AxisErrorID     :=  AxoReadAxisError_AxisErrorID;

            AxoReadAxisError  := AxoReadAxisError_Task;
        END_METHOD

        ///<summary>
        /// This method makes the transition from the state ‘ErrorStop’ to ‘Standstill’ or ‘Disabled’ by resetting all 
        /// internal axis-related errors – it does not affect the output of the other methods.
        ///<summary>
        METHOD PUBLIC AxoReset : IAxoTaskState
            VAR_OUTPUT
                Done            :   BOOL;                       //  ‘Standstill’ or ‘Disabled’ state is reached
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
            END_VAR

            Done        :=  AxoReset_Done;
            Busy        :=  AxoReset_Busy;
            Error       :=  AxoReset_Error;
            ErrorID     :=  AxoReset_ErrorID;

            AxoReset    := AxoReset_Task.Invoke();
        END_METHOD


        METHOD PROTECTED IsValidReferences: BOOL
            VAR_INPUT
                refAxisIn       :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the axis
                refAxisOut      :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the axis
            END_VAR
            IsValidReferences := FALSE;
            IF refAxisIn = NULL THEN
                DriveStatus.Error.Id := UINT#701;
            ELSIF refAxisOut = NULL THEN
                DriveStatus.Error.Id := UINT#702;
            ELSE
                IsValidReferences := TRUE;
            END_IF;

            Messenger.ActivateOnCondition(ULINT#701,refAxisIn = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#702,refAxisOut = NULL, eAxoMessageCategory#ProgrammingError);
        END_METHOD

        ///<summary>
        /// Ensures swapping the hardware input data structure into the AxisRef data structure  
        /// This vendor specific method must be overridden in derived class.
        ///</summary>
        METHOD PROTECTED ABSTRACT UpdateInputs : BOOL
            VAR_INPUT
                refAxisIn       :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the axis
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
            END_VAR
        END_METHOD   

        ///<summary>
        /// Ensures swapping the AxisRef data structure into the hardware output data structure
        /// This vendor specific method must be overridden in derived class.
        ///</summary>
        METHOD PROTECTED ABSTRACT UpdateOutputs : BOOL
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                refAxisOut      :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the axis
            END_VAR
        END_METHOD   

        ///<summary>
        /// This method controls the power stage (On or Off).
        /// This vendor specific method must be overridden in derived class.
        ///</summary>
        METHOD PUBLIC ABSTRACT MC_Power 
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
            END_VAR
            VAR_OUTPUT
                Status          :   BOOL;                       //  Effective state of the power stage
                Valid           :   BOOL;                       //  If true, a valid set of outputs is available at the method
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification            
            END_VAR
        END_METHOD 

        ///<summary>
        /// This method commands the axis to perform the «search home» sequence. The details of this sequence are
        /// manufacturer dependent and can be set by the axis’ parameters. The ‘Position’ input is used to set the absolute 
        /// position when reference signal is detected. This method completes at ‘Standstill’ if it was started in ‘Standstill’.
        /// This vendor specific method must be overridden in the derived class.
        ///</summary>
        METHOD PUBLIC ABSTRACT MC_Home
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the motion at rising edge
                Position        :   LREAL;                      //  Absolute position when the reference signal is detected             
                HommingMode     :   INT;                        //  Required homming mode           
                Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Reference known and set sucessfully
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
             END_VAR
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion stop and transfers the axis to the state ‘Stopping’. It aborts any
        /// ongoing method execution. While the axis is in state ‘Stopping’, no other method can perform any motion on the
        /// same axis. 
        /// This vendor specific method must be overridden in the derived class.
        ///</summary>
        METHOD PUBLIC ABSTRACT MC_Stop 
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the action at rising edge
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ [u/s2]
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Zero velocity reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by switching off power (only possibility to abort)                
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
             END_VAR
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion stop. The axis is moved to the state ‘DiscreteMotion’, until the
        /// velocity is zero. With the ‘Done’ output set, the state is transferred to ‘Standstill’.
        /// This vendor specific method must be overridden in the derived class.
        ///</summary>
        METHOD PUBLIC ABSTRACT MC_Halt 
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the action at rising edge
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ [u/s2]
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Zero velocity reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by switching off power (only possibility to abort)                
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
             END_VAR
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion to a specified absolute position.
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_MoveAbsolute
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the motion at rising edge
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Position        :   LREAL;                      //  Commanded ‘Position’ for the motion (in technical unit [u]) (negative or positive)                             
                Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
                Direction       :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;         //  Enum type (1-of-4 values: PositiveDirection, ShortestWay, NegativeDirection, CurrentDirection)
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Commanded position finally reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
             END_VAR
        END_METHOD

        ///<summary>
        /// This method  commands a controlled motion of a specified distance relative to the set position at the time of the execution.
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_MoveRelative 
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the motion at rising edge
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Distance        :   LREAL;                      //  Relative distance for the motion (in technical unit [u]                             
                Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Commanded distance reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
             END_VAR
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion of a specified relative distance additional to the most recent 
        /// commanded position in the axis state ‘DiscreteMotion’. The most recent commanded position may be the result of a 
        /// previous MC_MoveAdditive motion which was aborted. If the method is activated in the axis state ‘ContinuousMotion’, the
        /// specified relative distance is added to the set position at the time of the execution.
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_MoveAdditive
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the motion at rising edge
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Distance        :   LREAL;                      //  Relative distance for the motion (in technical unit [u]                             
                Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Commanded distance reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
             END_VAR
        END_METHOD

        ///<summary>
        /// This method commands a never ending controlled motion at a specified velocity.
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_MoveVelocity
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the motion at rising edge
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Velocity        :   LREAL;                      //  Value of the maximum velocity [u/s]. Can be a signed value.
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
                Direction       :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;         //  Enum type (1-of-3 values: PositiveDirection, NegativeDirection, and CurrentDirection. Note: shortest way not applicable)
            END_VAR
            VAR_OUTPUT
                InVelocity      :   BOOL;                       // Commanded velocity reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   WORD;                       // Error identification           
             END_VAR
        END_METHOD

        ///<summary>
        /// This method continuously exerts a torque or force of the specified magnitude. This magnitude is 
        /// approached using a defined ramp (‘TorqueRamp’), and the method sets the ‘InTorque’ output if the 
        /// commanded torque level is reached. This method is applicable for force and torque. When there is no external
        /// load, force is applicable. Positive torque is in the positive direction of velocity.
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_TorqueControl
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the motion at rising edge
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Torque          :   LREAL;                      //  Value of the torque (Torque or force in technical unit [u])
                TorqueRamp      :   LREAL;                      //  The maximum time derivative of the set value of the torque or force (in technical unit per sec. [u/s]) 
                Velocity        :   LREAL;                      //  Absolute value of the maximum velocity.
                Acceleration    :   LREAL;                      //  Value of the maximum acceleration (acceleration is applicable with same sign of torque and velocity)
                Deceleration    :   LREAL;                      //  Value of the maximum deceleration (deceleration is applicable with opposite signs of torque and velocity)
                Jerk            :   LREAL;                      //  Value of the maximum jerk
                Direction       :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;         //  Enum type (1 of 2 values: PositiveDirection, NegativeDirection or CurrentDirection). Specifies the direction of the torque. (Note: Torque input can be signed value).            
            END_VAR
            VAR_OUTPUT
                InTorque        :   BOOL;                       //  Setpoint value of torque or force equals the commandedvalue
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Active          :   BOOL;                       //  Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       //  ‘Command’ is aborted by another command
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification             
            END_VAR
        END_METHOD

        ///<summary>
        /// This method shifts the coordinate system of an axis by manipulating both the set-point position as well as the
        /// actual position of an axis with the same value without any movement caused. (Re-calibration with same following error). 
        /// This can be used for instance for a reference situation. This method can also be used during motion without changing 
        /// the commanded position, which is now positioned in the shifted coordinate system.
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_SetPosition
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start setting position in axis
                Position        :   LREAL;                      //  Position unit [u] (Means ‘Distance’ if ‘Relative’= TRUE)
                Relative        :   BOOL;                       //  ‘Relative’ distance if True, ‘Absolute’ position if False (= Default)
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  ‘Position’ has new value
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification             
            END_VAR
        END_METHOD

        ///<summary>
        /// This method sets the values of override for the whole axis, and all functions that are working on that axis. The override
        /// parameters contribute as a factor to the calculation of the commanded velocity, acceleration and jerk of the motion.
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_SetOverride
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  If SET, it writes the value of the override factor continuously. If RESET it should keep the last value.
                VelocityFactor  :   LREAL;                      //  New override factor for the velocity
                AccelerationFactor:   LREAL;                      //  New override factor for the acceleration/deceleration
                JerkFactor      :   LREAL;                      //  New override factor for the jer            
            END_VAR
            VAR_OUTPUT
                Enabled         :   BOOL;                       //  Signals that the override factor(s) is (are) set successfully
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification             
            END_VAR
        END_METHOD

        ///<summary>
        /// This method returns the value of a vendor specific parameter. The returned Value has to be converted to Real
        /// if necessary. If not possible, the vendor has to supply a vendor specific method to read the parameter.
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_ReadParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
                ParameterNumber :   DINT;                       //  Number of the parameter. One can also use symbolic parameter names which are declared as VAR CONST.
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Value           :   DINT;                       //  Value of the specified parameter in the datatype, as specified by the vendor
            END_VAR
        END_METHOD

        ///<summary>
        /// This method returns the value of a vendor specific parameter with datatype REAL.
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_ReadRealParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
                ParameterNumber :   DINT;                       //  Number of the parameter. One can also use symbolic parameter names which are declared as VAR CONST.
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Value           :   REAL;                       //  Value of the specified parameter in the datatype, as specified by the vendor
            END_VAR
        END_METHOD

        ///<summary>
        /// This method returns the value of a vendor specific parameter with datatype BOOL.
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_ReadBoolParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
                ParameterNumber :   DINT;                       //  Number of the parameter. One can also use symbolic parameter names which are declared as VAR CONST.
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Value           :   BOOL;                       //  Value of the specified parameter in the datatype, as specified by the vendor
            END_VAR
        END_METHOD

        ///<summary>
        /// This method modifies the value of a vendor specific parameter.
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_WriteParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Write the value of the parameter at rising edge
                ParameterNumber :   DINT;                       //  Number of the parameter (correspondence between number andparameter is specified in the table above)
                Value           :   DINT;                       //  New value of the specified parameter
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  Parameter successfully written
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
            END_VAR
        END_METHOD

        ///<summary>
        /// This method modifies the value of a vendor specific parameter of type REAL.
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_WriteRealParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Write the value of the parameter at rising edge
                ParameterNumber :   DINT;                       //  Number of the parameter (correspondence between number andparameter is specified in the table above)
                Value           :   REAL;                       //  New value of the specified parameter
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  Parameter successfully written
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
            END_VAR
        END_METHOD

        ///<summary>
        /// This method modifies the value of a vendor specific parameter of type BOOL.
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_WriteBoolParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Write the value of the parameter at rising edge
                ParameterNumber :   DINT;                       //  Number of the parameter (correspondence between number andparameter is specified in the table above)
                Value           :   BOOL;                       //  New value of the specified parameter
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  Parameter successfully written
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
            END_VAR
        END_METHOD

        ///<summary>
        /// This method gives access to the value of the input, referenced by the datatype MC_INPUT_REF. 
        /// It provides the value of the referenced input (BOOL).
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_ReadDigitalInput
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the selected input signal continuously while enabled
                InputNumber     :   INT;                        //  Selects the input. Can be part of MC_INPUT_REF, if only one single input is referenced.                
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Value           :   BOOL;                       //  The value of the selected input signal
            END_VAR
        END_METHOD

        ///<summary>
        /// This method provides access to the value of a digital output, referenced by the datatype MC_OUTPUT_REF. 
        /// It provides the value of the referenced output (BOOL).
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_ReadDigitalOutput
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the selected output signal continuously while enabled
                OutputNumber    :   INT;                        //  Selects the output. Can be part of MC_OUTPUT_REF, if only one single output is referenced.                
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Value           :   BOOL;                       //  The value of the selected output signal
            END_VAR
        END_METHOD

        ///<summary>
        /// This method writes a value to the output referenced by the argument ‘Output’ once (with rising edge of Execute)
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_WriteDigitalOutput
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Write the value of the selected output
                OutputNumber    :   INT;                        //  Selects the output. Can be part of MC_OUTPUT_REF, if only one single output is referenced.                
                Value           :   BOOL;                       //  The value of the selected output signal
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  Writing of the output signal value is done
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
            END_VAR
        END_METHOD

        ///<summary>
        /// This method returns the actual position.
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_ReadActualPosition 
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Position        :   LREAL;                       //  New absolute position (in axis’ unit [u])
            END_VAR
        END_METHOD

        ///<summary>
        /// This method returns the value of the actual velocity as long as ‘Enable’ is set. ‘Valid’ is true when the 
        /// dataoutput ‘Velocity’ is valid. If ‘Enable’ is Reset, the data loses its validity, and all outputs are reset,
        /// no matter if new data is available.
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_ReadActualVelocity
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Velocity        :   LREAL;                       //  The value of the actual velocity (in axis’ unit [u/s])
            END_VAR
        END_METHOD

        ///<summary>
        /// This method returns the value of the actual torque or force as long as ‘Enable’ is set. ‘Valid’ is true when the
        /// data-output ‘Torque’ is valid. If ‘Enable’ is Reset, the data loses its validity, and ‘Valid’ is also reset, 
        /// no matter if new data is available.        
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_ReadActualTorque
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                Torque          :   LREAL;                       //  The value of the actual torque or force (in technical units)
            END_VAR
        END_METHOD

        ///<summary>
        /// This method returns in detail the status of the state diagram of the axis
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_ReadStatus
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                ErrorStop       :   BOOL;                       //  See state diagram
                Disabled        :   BOOL;                       //  See state diagram
                Stopping        :   BOOL;                       //  See state diagram
                Homing          :   BOOL;                       //  See state diagram
                Standstill      :   BOOL;                       //  See state diagram
                DiscreteMotion  :   BOOL;                       //  See state diagram
                ContinuousMotion:   BOOL;                       //  See state diagram
                SynchronizedMotion: BOOL;                       //  See state diagram
            END_VAR
        END_METHOD

        ///<summary>
        /// This method returns in detail the status of the axis with respect to the motion currently in progress. 
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_ReadMotionState
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
                Source          :   AXOpen.Components.Abstractions.Drives.eAxoSource;                 //  Defines the source of the relevant data: CommandedValue;SetValue, ActualValue.
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                ConstantVelocity:   BOOL;                       //  Velocity is constant. Velocity may be 0. For the actual value a window is applicable (window is vendor specific)
                Accelerating    :   BOOL;                       //  Increasing the absolute value of the velocity
                Decelerating    :   BOOL;                       //  Decreasing the absolute value of the velocity
                DirectionPositive:  BOOL;                       //  Signals that the position is increasing
                DirectionNegative:  BOOL;                       //  Signals that the position is decreasing
            END_VAR
        END_METHOD

        ///<summary>
        /// This method reads information concerning an axis, like modes, inputs directly related to the axis, 
        /// and certain status information.
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_ReadAxisInfo
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                HomeAbsSwitch   :   BOOL;                       //  Digital home switch input is active
                LimitSwitchPos  :   BOOL;                       //  Positive hardware end switch is active
                LimitSwitchNeg  :   BOOL;                       //  Negative hardware end switch is active
                Simulation      :   BOOL;                       //  Axis is in simulation mode (e.g. motor is simulated)
                CommunicationReady: BOOL;                       //  “Network” is initialized and ready for communication
                ReadyForPowerOn :   BOOL;                       //  Drive is ready to be enabled (power on)
                PowerOn         :   BOOL;                       //  If TRUE shows that the power stage is switched ON
                IsHomed         :   BOOL;                       //  The absolute reference position is known for the axis (axis is homed)
                AxisWarning     :   BOOL;                       //  Warning(s) on the axis is present
            END_VAR
        END_METHOD

        ///<summary>
        /// This method presents general axis errors not relating to the methods. 
        /// (for instance axis errors, drive errors, communication errors)
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_ReadAxisError
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
                AxisErrorID     :   DWORD;                      //  The value of the axis error. These values are vendor specific
            END_VAR
        END_METHOD

        ///<summary>
        /// This method makes the transition from the state ‘ErrorStop’ to ‘Standstill’ or ‘Disabled’ by resetting all 
        /// internal axis-related errors – it does not affect the output of the other methods.
        /// This vendor specific method must be overridden in the derived class.
        ///<summary>
        METHOD PUBLIC ABSTRACT MC_Reset
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Resets all internal axis-related error
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  ‘Standstill’ or ‘Disabled’ state is reached
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   WORD;                       //  Error identification
            END_VAR
        END_METHOD
    END_CLASS
END_NAMESPACE
