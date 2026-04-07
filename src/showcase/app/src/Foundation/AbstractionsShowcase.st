USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Logging;

// Showcase reference for AXOpen.Abstractions — documents the core interfaces
// and enum types that all AXOpen libraries build upon.
// Since Abstractions contains only interfaces and enums (no concrete classes),
// this showcase provides a reference context with example type usage.
NAMESPACE AXOpen.Showcase.Abstractions

    {S7.extern=ReadWrite}
    CLASS DocumentationContext EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject : AxoObject;
            _interfaceDoc : InterfaceUsageDoc;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            _interfaceDoc.Run(_rootObject);
        END_METHOD
    END_CLASS

    // Demonstrates how AXOpen.Abstractions interfaces are used in practice.
    // All AXOpen objects implement IAxoObject; contexts implement IAxoContext.
    {S7.extern=ReadWrite}
    CLASS PUBLIC InterfaceUsageDoc EXTENDS AXOpen.Core.AxoObject
        //<AbstractionsDeclarations>
        VAR PUBLIC
            _exampleObject : AXOpen.Core.AxoObject;
            _objectIdentity : ULINT;
            _messageCategory : AXOpen.Messaging.eAxoMessageCategory;
            _logLevel : AXOpen.Logging.eLogLevel;
        END_VAR
        //</AbstractionsDeclarations>

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR
            SUPER.Run(inParent);

            //<IAxoObjectUsage>
            // Every AXOpen object implements IAxoObject, providing:
            // - GetIdentity()  : unique numeric identity
            // - GetContext()    : reference to the parent AxoContext
            // - GetParent()    : reference to the immediate parent object
            _exampleObject.Run(inParent);
            _objectIdentity := _exampleObject.GetIdentity();
            //</IAxoObjectUsage>

            //<MessageCategoryUsage>
            // eAxoMessageCategory defines severity levels for messaging:
            // None, Info, Potential, Warning, Error, ProgrammingError, Critical
            _messageCategory := AXOpen.Messaging.eAxoMessageCategory#Info;
            //</MessageCategoryUsage>

            //<LogLevelUsage>
            // eLogLevel defines logging verbosity levels:
            // NoCat, Verbose, Debug, Information, Warning, Error, Fatal
            _logLevel := AXOpen.Logging.eLogLevel#Information;
            //</LogLevelUsage>
        END_METHOD
    END_CLASS

END_NAMESPACE
