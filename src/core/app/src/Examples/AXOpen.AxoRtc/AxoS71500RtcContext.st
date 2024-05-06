{S7.extern=ReadWrite}
CLASS AxoS71500RtcContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
       _rtc : AXOpen.S71500.Rtc;
        {#ix-set:AttributeName = "<#Actual date and time#>"}
        {#ix-attr:[ReadOnly()]}
        ActualDateTime : LDATE_AND_TIME;
        {#ix-set:AttributeName = "<#Setup date and time#>"}
        SetupDateTime : LDATE_AND_TIME;
        {#ix-set:AttributeName = "<#Click to set the date and time#>"}
        SetUTC : AxoTask;
    END_VAR
   

    METHOD PROTECTED OVERRIDE Main
        VAR
            retval : WORD;
        END_VAR;    
        
        ActualDateTime := _rtc.NowUTC();
        
        SetUTC.Initialize(THIS);

        IF(SetUTC.Execute()) THEN
            retval := _rtc.SetUTC(SetupDateTime);
            SetUTC.ThrowWhen(retval>WORD#0);
            SetUTC.DoneWhen(retval=WORD#0);
        END_IF;

        THIS.InjectRtc(_rtc);

    END_METHOD
END_CLASS
