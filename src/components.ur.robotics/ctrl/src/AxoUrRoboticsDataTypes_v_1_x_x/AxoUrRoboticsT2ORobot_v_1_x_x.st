NAMESPACE AXOpen.Components.Ur.Robotics
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoUrRoboticsT2ORobot_v_1_x_x
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Controller major version#>"}
            ControllerMajorVersion : USINT;
            {#ix-set:AttributeName = "<#Controller minor version#>"}    
            ControllerMinorVersion : USINT;
            {#ix-set:AttributeName = "<#Reserved#>"}
            Reserved : UINT;
            {#ix-set:AttributeName = "<#Robot mode#>"}
            RobotMode : USINT;
            {#ix-set:AttributeName = "<#Real time machine seconds#>"}
            RealtimeMachineSeconds : USINT;
            {#ix-set:AttributeName = "<#Real time machine milliseconds#>"}
            RealtimeMachineMilliseconds : UINT;
            {#ix-set:AttributeName = "<#Real time machine minutes#>"}
            RealtimeMachineMinutes : USINT;
            {#ix-set:AttributeName = "<#Real time machine hours#>"}
            RealtimeMachineHours : USINT;
            {#ix-set:AttributeName = "<#Real time machine days#>"}
            RealtimeMachineDays : UINT;
            {#ix-set:AttributeName = "<#Robot current [A]#>"}
            RobotCurrent : REAL;
            {#ix-set:AttributeName = "<#PW: Is power on#>"}
            PW_IsPowerOn : BOOL;
            {#ix-set:AttributeName = "<#PR: Is program running#>"}
            PR_IsProgramRunning : BOOL;
            {#ix-set:AttributeName = "<#TB: Is teach button pressed#>"}
            TB_IsTeachButtonPressed : BOOL;
            {#ix-set:AttributeName = "<#PB: Is power button pressed#>"}
            PB_IsPowerButtonPressed : BOOL;
            {#ix-set:AttributeName = "<#Speed slider fraction#>"}
            SpeedSliderFraction : REAL;
        END_VAR 
    END_CLASS    
END_NAMESPACE