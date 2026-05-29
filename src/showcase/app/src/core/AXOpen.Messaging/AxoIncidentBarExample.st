USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

NAMESPACE AxoIncidentBarExample

    // Demonstrates AxoCauseAnalyzer + AxoIncidentBarView with a nested twin-tree topology.
    // Operator toggles condition BOOLs to fire Error/Critical messengers at multiple
    // tree levels. The bar ranks the upper messenger as 'top cause' because it
    // owns more downstream alarms (Symbol-prefix heuristic) and shares the burst window.
    {S7.extern=ReadWrite}
    CLASS IncidentTopology EXTENDS AXOpen.Core.AxoObject
        //<TopologyDeclaration>
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Station (top of the topology)#>"}
            station : Station;
        END_VAR
        //</TopologyDeclaration>

        VAR PRIVATE
            _rootObject : AxoObject;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            station.Run(_rootObject);
        END_METHOD
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC Station EXTENDS AXOpen.Core.AxoObject
        //<StationDeclaration>
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Station-level alarm (Error)#>"}
            {#ix-set:PlcTextList = "[1]:'<#Station emergency stop active#>':'<#Station has tripped the safety chain. Resolve all downstream issues before resetting.#>'"}
            _station_messenger : AXOpen.Messaging.Static.AxoMessenger;
            {#ix-set:AttributeName = "<#Trigger Station error#>"}
            _station_error : BOOL;

            {#ix-attr:[Container(Layout.Stack)]}
            drive : Drive;

            {#ix-attr:[Container(Layout.Stack)]}
            conveyor : Conveyor;
        END_VAR
        //</StationDeclaration>

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR
            SUPER.Run(inParent);
            _station_messenger.Serve(THIS);
            //<StationActivate>
            _station_messenger.ActivateOnCondition(ULINT#1, _station_error, eAxoMessageCategory#Error)
                              .RequireAcknowledgement();
            //</StationActivate>
            drive.Run(THIS);
            conveyor.Run(THIS);
        END_METHOD
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC Drive EXTENDS AXOpen.Core.AxoObject
        //<DriveDeclaration>
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Drive over-current (Critical)#>"}
            {#ix-set:PlcTextList = "[1]:'<#Drive over-current trip#>':'<#Inverter detected current above the safety limit. Check load and wiring.#>'"}
            _drive_messenger : AXOpen.Messaging.Static.AxoMessenger;
            {#ix-set:AttributeName = "<#Trigger Drive over-current#>"}
            _drive_error : BOOL;

            {#ix-attr:[Container(Layout.Stack)]}
            encoder : Encoder;
        END_VAR
        //</DriveDeclaration>

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR
            SUPER.Run(inParent);
            _drive_messenger.Serve(THIS);
            _drive_messenger.ActivateOnCondition(ULINT#1, _drive_error, eAxoMessageCategory#Critical)
                            .RequireAcknowledgement();
            encoder.Run(THIS);
        END_METHOD
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC Encoder EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Encoder signal lost (Error)#>"}
            {#ix-set:PlcTextList = "[1]:'<#Encoder signal lost#>':'<#The drive lost feedback from the encoder. Check cable continuity and connector seating.#>'"}
            _encoder_messenger : AXOpen.Messaging.Static.AxoMessenger;
            {#ix-set:AttributeName = "<#Trigger Encoder signal lost#>"}
            _encoder_error : BOOL;
        END_VAR

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR
            SUPER.Run(inParent);
            _encoder_messenger.Serve(THIS);
            _encoder_messenger.ActivateOnCondition(ULINT#1, _encoder_error, eAxoMessageCategory#Error)
                              .RequireAcknowledgement();
        END_METHOD
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC Conveyor EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Conveyor jammed (Error)#>"}
            {#ix-set:PlcTextList = "[1]:'<#Conveyor jammed#>':'<#Detected motor stall while pulley still commanded. Clear the obstruction and reset.#>'"}
            _conveyor_messenger : AXOpen.Messaging.Static.AxoMessenger;
            {#ix-set:AttributeName = "<#Trigger Conveyor jam#>"}
            _conveyor_error : BOOL;

            {#ix-attr:[Container(Layout.Stack)]}
            sensor : Sensor;
        END_VAR

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR
            SUPER.Run(inParent);
            _conveyor_messenger.Serve(THIS);
            _conveyor_messenger.ActivateOnCondition(ULINT#1, _conveyor_error, eAxoMessageCategory#Error)
                               .RequireAcknowledgement();
            sensor.Run(THIS);
        END_METHOD
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC Sensor EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Sensor disconnected (Error)#>"}
            {#ix-set:PlcTextList = "[1]:'<#Sensor disconnected#>':'<#Photo-eye lost present feedback. Verify alignment and 24V supply.#>'"}
            _sensor_messenger : AXOpen.Messaging.Static.AxoMessenger;
            {#ix-set:AttributeName = "<#Trigger Sensor disconnect#>"}
            _sensor_error : BOOL;
        END_VAR

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR
            SUPER.Run(inParent);
            _sensor_messenger.Serve(THIS);
            _sensor_messenger.ActivateOnCondition(ULINT#1, _sensor_error, eAxoMessageCategory#Error)
                             .RequireAcknowledgement();
        END_METHOD
    END_CLASS

END_NAMESPACE
