USING AXOpen.Core;
USING AXOpen.Messaging.Static;
USING AXOpen.Messaging;
USING AXOpen.Core;
USING AXOpen.Components.Abstractions;
USING AXOpen.Components.Abstractions.Drives;
USING System.Math;
USING System.BitAccess;

NAMESPACE AXOpen.Components.Desoutter.Tightening
    CLASS PUBLIC AxoCVIC_II EXTENDS AXOpen.Core.AxoComponent
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

        VAR PUBLIC //CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Screwing program min")]}
            {#ix-attr:[ReadOnly()]}
            ScrewingProgramMin         :   BYTE := BYTE#0;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Screwing program max")]}
            {#ix-attr:[ReadOnly()]}
            ScrewingProgramMax         :   BYTE := BYTE#255;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Program change timeout")]}
            {#ix-attr:[ReadOnly()]}
            ProgramChangeTimeout         :   TIME := TIME#2S;
            {#ix-attr:[ComponentDetails("Screwing cycle timeout")]}
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

        VAR PUBLIC //HardwareSignals
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("HardwareSignals")]}
            {#ix-attr:[ReadOnly()]}
            Inputs              :   AxoCVIC_II_In;
            {#ix-attr:[ComponentDetails("HardwareSignals")]}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   AxoCVIC_II_Out;
        END_VAR    

        METHOD PUBLIC OVERRIDE Restore
            ;
        END_METHOD
    
        METHOD PROTECTED OVERRIDE ManualControl
            ;
        END_METHOD
    END_CLASS
END_NAMESPACE