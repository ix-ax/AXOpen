USING AXOpen.Core;
USING AXOpen.Logging;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

// ============================================================
// TestContext — Documentation AxoContext for the test app.
// Contains documentation examples and core objects.
// Sandbox/testing objects have been moved to src/sandbox/app.
// ============================================================

{S7.extern=ReadWrite}
CLASS TestContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        // ---- Components.Rexroth.Drives ----
        rexroth_drives_documentation : AXOpen.Components.Rexroth.Drives.RexrothDrives;

    END_VAR

    METHOD PROTECTED OVERRIDE Main
        THIS.InitializeRootObject(rexroth_drives_documentation);
        rexroth_drives_documentation.Execute();

    END_METHOD
END_CLASS
