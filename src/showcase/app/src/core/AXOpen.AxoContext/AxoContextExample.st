USING AXOpen.Core;
USING AXOpen.Logging;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

//<Implementation>
    PROGRAM ProgramExample
        VAR
            MyContext : AxoContextExample;
        END_VAR

        MyContext.Run();

    END_PROGRAM
//</Implementation>

//<Declaration>
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoContextExample EXTENDS AXOpen.Core.AxoContext
        METHOD PROTECTED OVERRIDE Main
            // Here goes all your logic for given AxoContext.
            ;
        END_METHOD
    END_CLASS
//</Declaration>

//<ContextWithServices>
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoContextWithServicesExample EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            // Service instances declared as PUBLIC for .NET twin visibility
            Lgr : AXOpen.Logging.AxoLogger;
            MsgSvc : AXOpen.Messaging.AxoMessengerService;
            Root : AXOpen.Core.AxoObject;
        END_VAR

        METHOD PROTECTED OVERRIDE Main
            // 1. Inject services into the context (called every cycle, idempotent)
            THIS.InjectLogger(Lgr);
            THIS.InjectMessengerService(MsgSvc);

            // 2. Set minimum log level
            THIS.GetLogger().SetMinimumLevel(eLogLevel#Information);

            // 3. Initialize root object — establishes the object tree
            THIS.InitializeRootObject(Root);

            // 4. All application logic starts from here
            // Objects call Run(Root) or Run(THIS) to join the context tree
        END_METHOD
    END_CLASS
//</ContextWithServices>

//<InitializeRootObject>
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoContextInitExample EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            _unit1 : AXOpen.Core.AxoObject;
            _unit2 : AXOpen.Core.AxoObject;
        END_VAR

        METHOD PROTECTED OVERRIDE Main
            // InitializeRootObject wires the object into this context's tree.
            // Must be called before any other method on the object.
            THIS.InitializeRootObject(_unit1);
            THIS.InitializeRootObject(_unit2);

            // After initialization, objects can use GetContext() to access
            // context services (logger, messenger, RTC, RTM).
        END_METHOD
    END_CLASS
//</InitializeRootObject>
