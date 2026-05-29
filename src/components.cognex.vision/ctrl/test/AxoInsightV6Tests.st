USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

// Tests for AxoInsight v6.0.0 (Cognex In-Sight vision sensor).
//
// AxoInsight.Run(inParent, hwID) performs PROFINET hardware-slot introspection before any
// vision logic. On the LLVM unit-test simulator there is no real PROFINET device, so the
// settled inspection happy path is not reachable here. The deterministic, simulator-runnable
// behaviour is the input-guard / hardware-resolution error path; expected IDs are the
// component's own guard constants.
NAMESPACE Cognex.Vision.Tests.InsightV6
    {S7.extern=ReadWrite}
    CLASS TestContext EXTENDS AXOpen.Core.Dummies.MockAxoContext
        METHOD PROTECTED OVERRIDE Main
            ;
        END_METHOD
    END_CLASS

    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoInsightV6Tests
        VAR
            context : TestContext;
            sut     : AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoInsight;
            parent  : AXOpen.Core.AxoObject;
            _rtc    : AXOpen.Core.Dummies.MockAxoRtc;
            _rtm    : AXOpen.Core.Dummies.MockAxoRtm;
            _nullParent : IAxoObject;
        END_VAR

        VAR
            contextBlank : TestContext;
            sutBlank     : AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoInsight;
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

        {Test}
        METHOD PUBLIC Run_WithNullParent_RaisesError700
            context.Open();
            sut.Run(_nullParent, UINT#16);
            context.Close();

            AxUnit.Assert.Equal(UINT#700, sut.Status.Error.Id);
        END_METHOD

        {Test}
        METHOD PUBLIC Run_WithZeroHardwareId_RaisesError701
            context.Open();
            context.InitializeRootObject(parent);
            sut.Run(parent, UINT#0);
            context.Close();

            AxUnit.Assert.Equal(UINT#701, sut.Status.Error.Id);
        END_METHOD

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
