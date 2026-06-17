USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

// Tests for AxoVisionProNet (Cognex VisionPro over a TCP/.NET remote-task channel).
//
// Unlike the PROFINET variants, Run(inParent) performs NO hardware-slot introspection, so the
// component runs end-to-end on the LLVM simulator. Its data-exchange tasks are AxoRemoteTasks
// whose handlers live on the .NET twin, which is not present under `apax test`; therefore these
// tests cover only twin-independent, deterministic behaviour:
//   * a clean cyclic Run leaves the component error-free (Status.ErrorCode = 0),
//   * Restore() clears Status (ErrorCode/Accepted/descriptions) per the docs,
//   * manual control gates the commissioning task (IsManuallyControllable after activation).
// Remote-task busy/done/exception states (which depend on the missing twin handler) are not
// asserted.
NAMESPACE Cognex.Vision.Tests.VisionProNet
    {S7.extern=ReadWrite}
    CLASS TestContext EXTENDS AXOpen.Core.Dummies.MockAxoContext
        METHOD PROTECTED OVERRIDE Main
            ;
        END_METHOD
    END_CLASS

    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoVisionProNetTests
        VAR
            context : TestContext;
            sut     : AXOpen.Components.Cognex.Vision.AxoVisionProNet;
            parent  : AXOpen.Core.AxoObject;
            _rtc    : AXOpen.Core.Dummies.MockAxoRtc;
            _rtm    : AXOpen.Core.Dummies.MockAxoRtm;
        END_VAR

        VAR
            contextBlank : TestContext;
            sutBlank     : AXOpen.Components.Cognex.Vision.AxoVisionProNet;
            parentBlank  : AXOpen.Core.AxoObject;
        END_VAR

        {TestSetup}
        METHOD PUBLIC TestSetup
            context := contextBlank;
            sut     := sutBlank;
            parent  := parentBlank;
            _rtm.SetElapsed(LTIME#2s);
            context.InjectRtm(_rtm);
            _rtc.SetNowUTC(LDATE_AND_TIME#2012-01-12-15:58:12.123);
            context.InjectRtc(_rtc);
            context.InitializeRootObject(parent);
        END_METHOD

        METHOD PRIVATE Cycle
            context.Open();
            context.InitializeRootObject(parent);
            sut.Run(parent);
            context.Close();
        END_METHOD

        // A clean cyclic run with nothing invoked leaves the component free of error.
        {Test}
        METHOD PUBLIC Run_WhenIdle_KeepsErrorCodeZero
            VAR i : INT; END_VAR
            FOR i := 0 TO 3 DO
                THIS.Cycle();
            END_FOR;

            AxUnit.Assert.Equal(INT#0, sut.Status.ErrorCode);
        END_METHOD

        // Restore() clears the status fields back to their initial state.
        {Test}
        METHOD PUBLIC Restore_ClearsStatus
            THIS.Cycle();

            // dirty the status, then restore
            sut.Status.ErrorCode := INT#42;
            sut.Status.Accepted  := TRUE;

            context.Open();
            context.InitializeRootObject(parent);
            sut.Restore();
            sut.Run(parent);
            context.Close();

            AxUnit.Assert.Equal(INT#0, sut.Status.ErrorCode);
            AxUnit.Assert.Equal(FALSE, sut.Status.Accepted);
        END_METHOD

        // After ActivateManualControl(), the component reports itself manually controllable
        // for the activating context cycle (and the next), per AxoComponent semantics.
        {Test}
        METHOD PUBLIC ManualControl_WhenActivated_IsManuallyControllable
            THIS.Cycle();              // bind the component to the context

            sut.ActivateManualControl();
            THIS.Cycle();              // evaluate manual-control state within the window

            AxUnit.Assert.Equal(TRUE, sut.IsManuallyControllable());
        END_METHOD
    END_CLASS
END_NAMESPACE
