USING AXOpen.Core;

PROGRAM TestProgram
    VAR_EXTERNAL
        _rtc : AXOpen.S71500.Rtc;
        _rtm : AXOpen.S71500.Rtm;
        {#ix-set:AttributeName = "PLC alive counter"}
        I_am_alive : ULINT;
        Ctx : TestContext;
    END_VAR

    I_am_alive := I_am_alive + ULINT#1;

    // Inject shared services into the single unified context
    Ctx.InjectRtc(_rtc);
    Ctx.InjectRtm(_rtm);

    // Run the single context — orchestrates all examples
    Ctx.Run();
END_PROGRAM
