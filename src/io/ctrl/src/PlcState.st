NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    CLASS PlcState
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            ModuleDisabled              :   BOOL;   //	Submodule or module disabled.
            ConfigurationInRunActive    :   BOOL;   //	Configuration in Run (CiR) operation is active.
            InputNotAvailable           :   BOOL;   //	Input not available.
            OutputNotAvailable          :   BOOL;   //	Output not available.
            DiagnosticsBufferOverflow   :   BOOL;   //	Overflow of diagnostic buffer.
            DiagnosticsNotAvailable     :   BOOL;   //	Diagnostics not available.
            PartialDeviceFailure        :   BOOL;   //	Partial device failure (with PNIO for Shared iDevices).
        END_VAR
    END_CLASS
END_NAMESPACE
