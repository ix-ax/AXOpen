PROGRAM MyProgram
    VAR_EXTERNAL
        _rtc : AXOpen.S71500.Rtc;
        _rtm : AXOpen.S71500.Rtm;
        AxoDataExchangeContext : AxoDataExchangeExample.Context;
        AxoDataFragmentsExchangeContext : AxoDataFramentsExchangeExample.Context;
        AxoDataPersistentContext : AxoDataPersistentExchangeExample.Context;
        AxoDataDistributedContext : AxoDataDistributedExample.Context;
    END_VAR
    

    AxoDataExchangeContext.InjectRtc(_rtc);
    AxoDataExchangeContext.InjectRtm(_rtm);
    AxoDataExchangeContext.Run();  

    AxoDataFragmentsExchangeContext.InjectRtc(_rtc);
    AxoDataFragmentsExchangeContext.InjectRtm(_rtm);
    AxoDataFragmentsExchangeContext.Run();   

    AxoDataPersistentContext.InjectRtc(_rtc);
    AxoDataPersistentContext.InjectRtm(_rtm);
    AxoDataPersistentContext.Run(); 
  
    AxoDataDistributedContext.InjectRtc(_rtc);
    AxoDataDistributedContext.InjectRtm(_rtm);
    AxoDataDistributedContext.Run();  
END_PROGRAM
