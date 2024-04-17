NAMESPACE AXOpen.Components.Ur.Robotics
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoUrRoboticsT2OTool_v_1_x_x
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Tool mode#>"}
            ToolMode : USINT;
            {#ix-set:AttributeName = "<#TDI: Tool Digital Inputs#>"}
            TDI_ToolDigitalInputs : USINT;
            {#ix-set:AttributeName = "<#TDO: Tool Digital Outputs#>"}
            TDO_ToolDigitalOutputs : USINT;
            {#ix-set:AttributeName = "<#TAIT: Tool Analog Input Types#>"}
            TAIT_ToolAnalogInputTypes : USINT;
            {#ix-set:AttributeName = "<#Tool analog input 0 [A OR V]#>"}
            ToolAnalogInput_0: REAL;
            {#ix-set:AttributeName = "<#Tool analog input 1 [A OR V]#>"}
            ToolAnalogInput_1: REAL;
            {#ix-set:AttributeName = "<#Tool output voltage [V]#>"}
            ToolOutputVoltage : REAL;
            {#ix-set:AttributeName = "<#Tool current [A]#>"}
            ToolCurrent : REAL;
        END_VAR 
    END_CLASS    
END_NAMESPACE