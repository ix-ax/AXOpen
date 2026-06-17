USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

// Tests for AxoDataman (Cognex Dataman v6.0.0 code reader).
//
// AxoDataman.Run(inParent, hwID) performs PROFINET hardware-slot introspection
// (ReadSlotFromHardwareID / ReadHardwareIDFromSlot / ReadHardwareIOAddress) before any
// inspection logic. On the LLVM unit-test simulator there is no real PROFINET device, so
// the "settled inspection" happy path is not reachable here (it requires real hardware).
// What IS deterministic on the simulator is the input-guard / hardware-resolution error
// path: those branches set a fixed Status.Error.Id and are exercised below. Expected IDs
// are the component's own documented guard constants (TROUBLES.md is a stub).
NAMESPACE Cognex.Vision.Tests.Dataman
    {S7.extern=ReadWrite}
    CLASS TestContext EXTENDS AXOpen.Core.Dummies.MockAxoContext
        METHOD PROTECTED OVERRIDE Main
            ;
        END_METHOD
    END_CLASS

    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoDatamanTests
        VAR
            context : TestContext;
            sut     : AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoDataman;
            parent  : AXOpen.Core.AxoObject;
            _rtc    : AXOpen.Core.Dummies.MockAxoRtc;
            _rtm    : AXOpen.Core.Dummies.MockAxoRtm;
            _nullParent : IAxoObject;   // unassigned interface reference == NULL
        END_VAR

        VAR
            contextBlank : TestContext;
            sutBlank     : AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoDataman;
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

        // inParent == NULL is a programming error -> Status.Error.Id := 700.
        {Test}
        METHOD PUBLIC Run_WithNullParent_RaisesError700
            context.Open();
            sut.Run(_nullParent, UINT#16);
            context.Close();

            AxUnit.Assert.Equal(UINT#700, sut.Status.Error.Id);
        END_METHOD

        // hwID == 0 (no device hardware identifier) is a programming error -> 701.
        {Test}
        METHOD PUBLIC Run_WithZeroHardwareId_RaisesError701
            context.Open();
            context.InitializeRootObject(parent);
            sut.Run(parent, UINT#0);
            context.Close();

            AxUnit.Assert.Equal(UINT#701, sut.Status.Error.Id);
        END_METHOD

        // A non-zero hwID resolves the device, but slot 1 (AcquisitionControl) cannot be
        // resolved on the simulator (the unmocked hardware reads return default 0) -> 710.
        {Test}
        METHOD PUBLIC Run_WithoutHardwarePresent_RaisesSlotError710
            context.Open();
            context.InitializeRootObject(parent);
            sut.Run(parent, UINT#16);
            context.Close();

            AxUnit.Assert.Equal(UINT#710, sut.Status.Error.Id);
        END_METHOD
    END_CLASS
END_NAMESPACE
