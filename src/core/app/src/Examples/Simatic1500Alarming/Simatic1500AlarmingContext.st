USING Siemens.Simatic.S71500.Alarming;

{S7.extern=ReadWrite}
CLASS Simatic1500AlarmingContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC

        {resource=alarming?refid:7c6140ac}
        alarm1 : ProgramAlarm;                   
        {#ix-set:AttributeName = "<#Alarm 1 activate#>"}
        alarm1_Sig : BOOL;
        {#ix-set:AttributeName = "<#Alarm 1 state#>"}
        alarm1_Stat : WORD;

        {resource=alarming?refid:94b21ab4}
        alarm2 : ProgramAlarm;                   
        {#ix-set:AttributeName = "<#Alarm 2 activate#>"}
        alarm2_Sig : BOOL;
        {#ix-set:AttributeName = "<#Alarm 2 state#>"}
        alarm2_Stat : WORD;

        {resource=alarming?refid:d9c769a7}
        alarm3 : ProgramAlarm;      
        {#ix-set:AttributeName = "<#Alarm 3 activate#>"}
        alarm3_Sig : BOOL;
        {#ix-set:AttributeName = "<#Alarm 3 state#>"}
        alarm3_Stat : INT;
        alarm3_AssocValues : AssocValues;



        {S7.Alarm = NoAck, "Alarm 4. SD_1=@1%u@  SD_2=@2%X@"}
        alarm4 : ProgramAlarm;                   
        {#ix-set:AttributeName = "<#Alarm 4 activate#>"}
        alarm4_Sig : BOOL;
        {#ix-set:AttributeName = "<#Alarm 4 state#>"}
        alarm4_Stat : WORD;
        alarm4_SD1    : UINT;
        alarm4_SD2 : WORD;


        {S7.Alarm = NoAck, "Alarm 5. text1=@1%t#alarm5-list1@ text2=@2%t#alarm5-list2@"}
        alarm5 : ProgramAlarm;                   
        {#ix-set:AttributeName = "<#Alarm 5 activate#>"}
        alarm5_Sig : BOOL;
        {#ix-set:AttributeName = "<#Alarm 5 state#>"}
        alarm5_Stat : WORD;
        alarm5_SD1    : UINT;
        alarm5_SD2 : WORD;
    END_VAR

    METHOD PROTECTED OVERRIDE Main
         alarm1(SIG := alarm1_Sig, Status => alarm1_Stat);
         alarm2(SIG := alarm2_Sig, Status => alarm2_Stat);

         alarm3_AssocValues.Value[1] := UINT#10;
         alarm3_AssocValues.Value[2] := UINT#20;
         alarm3_AssocValues.Value[3] := UINT#30;
         alarm3_AssocValues.Value[4] := UINT#40;
         alarm3_AssocValues.Value[5] := UINT#50;
         alarm3_AssocValues.Value[6] := UINT#60;
         alarm3_AssocValues.Value[7] := UINT#70;
         alarm3_AssocValues.Value[8] := UINT#80;

        IF alarm3_Sig THEN
            alarm3_Stat := GenUserMessage(Mode := GenUserMessageMode#IncomingAlarm, TextID := UINT#5, TextListID := UINT#15, AssocValues := alarm3_AssocValues);
        END_IF;

        alarm4(       SIG := alarm4_Sig, 
                SD_1 := pass(alarm4_SD1), 
                SD_2 := pass(alarm4_SD2), 
                   Status => alarm4_Stat);

        alarm5(       SIG := alarm5_Sig, 
                SD_1 := pass(alarm5_SD1), 
                SD_2 := pass(alarm5_SD2), 
                   Status => alarm5_Stat);


    END_METHOD
END_CLASS
