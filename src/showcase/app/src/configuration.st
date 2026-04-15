USING AXOpen.Core;
USING AXOpen.Data;

// ============================================================
// Showcase unified configuration
// Includes representative examples from every library.
//
// Variable naming convention:
//   - Core / Data / Foundation-lib examples keep their
//     original names where those names are globally unique.
//   - Component-library sandbox/documentation contexts are
//     prefixed with the short library name to avoid conflicts,
//     because each library defines types of the same name in
//     its own namespace.
// ============================================================

CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: ShowcaseProgram;

    VAR_GLOBAL
        // ---- Shared RTC / RTM ----
        {S7.extern=ReadWrite}
        _rtc : AXOpen.S71500.Rtc;
        {S7.extern=ReadWrite}
        _rtm : AXOpen.S71500.Rtm;

        // ---- PLC alive counter ----
        {#ix-set:AttributeName = "PLC alive counter"}
        {S7.extern=ReadWrite}
        I_am_alive : ULINT;

        // ---- Single unified context ----
        {S7.extern=ReadWrite}
        Ctx : ShowcaseContext;
    END_VAR
END_CONFIGURATION

