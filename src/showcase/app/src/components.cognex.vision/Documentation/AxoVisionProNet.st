USING AXOpen.Core;

NAMESPACE AXOpen.Components.Cognex.Vision

    {S7.extern=ReadWrite}
    CLASS AxoVisionProNet_Example EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC
            VisionProNet : AXOpen.Components.Cognex.Vision.AxoVisionProNet;
        END_VAR
        //</ComponentDeclaration>

        //<InitializationArgumentsDeclaration>
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Activate manual control#>"}
            ActivateManualControl : BOOL;
        END_VAR
        //</InitializationArgumentsDeclaration>

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR

            SUPER.Run(inParent);

            IF ActivateManualControl THEN
                //<VisionProNetManualControl>
                VisionProNet.ActivateManualControl();
                //</VisionProNetManualControl>
            END_IF;

            //<Initialization>
            // AxoVisionProNet talks to the Vision PC over TCP via its .NET twin.
            // The socket is opened from Program.cs (InitializeVisionClientAsync);
            // here we only configure timeouts and run the component cyclically.
            VisionProNet.Config.InfoTime    := LTIME#5S;
            VisionProNet.Config.ErrorTime   := LTIME#10S;
            VisionProNet.Config.TaskTimeout := LTIME#50S;
            VisionProNet.Run(inParent := THIS);
            //</Initialization>

            THIS.UseInSequencer();
        END_METHOD

        //<Usage>
        VAR PUBLIC
            Sequencer : AxoSequencer;
            Steps : ARRAY[0..10] OF AXOpen.Core.AxoStep;
        END_VAR

        METHOD PRIVATE UseInSequencer
            IF Sequencer.GetContext().OpenCycleCount() <= ULINT#10 THEN
                Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;
            END_IF;

            Sequencer.Run(THIS);
            Sequencer.Open();

            // Restore clears all remote tasks and seeds the recipe / part
            // identification carried in every Vision PC request.
            IF(Steps[0].Execute(Sequencer, 'Restore and set part identification')) THEN
                VisionProNet.Control.VariantId := 'VARIANT-A';
                VisionProNet.Control.PartId    := 'PART-0001';
                VisionProNet.Control.TriggerId := INT#1;
                VisionProNet.Restore();
                Sequencer.MoveNext();
            END_IF;

            // Select the inspection recipe / job on the Vision PC.
            IF(Steps[1].Execute(Sequencer, 'Select recipe on Vision PC')) THEN
                IF(VisionProNet.SetRecipe().IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            // Fire an inspection for the configured TriggerId / PartId.
            IF(Steps[2].Execute(Sequencer, 'Trigger inspection')) THEN
                IF(VisionProNet.Trigger().IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            // Pull the inspection verdict back from the Vision PC.
            IF(Steps[3].Execute(Sequencer, 'Read inspection result')) THEN
                IF(VisionProNet.InspectionResult().IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            // Combined path: send application-specific payload AND trigger in one
            // gated task (disabled by the component while Trigger/SetRecipe run).
            IF(Steps[4].Execute(Sequencer, 'Trigger with specific data')) THEN
                IF(VisionProNet.TriggerWithSpecificData().IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            // Receive the typed result payload into the specific-data container.
            IF(Steps[5].Execute(Sequencer, 'Receive specific data')) THEN
                IF(VisionProNet.ReceiveSpecificData().IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            // Error recovery: a remote task that faulted (e.g. Vision PC offline,
            // request rejected) raises HasRemoteException. Restore() clears every
            // task back to idle so the sequence can be re-run.
            IF(Steps[6].Execute(Sequencer, 'Error recovery')) THEN
                //<VisionProNetErrorRecovery>
                IF VisionProNet.TriggerTask.HasRemoteException
                    OR VisionProNet.SetRecipeTask.HasRemoteException
                    OR VisionProNet.InspectionResultTask.HasRemoteException
                    OR VisionProNet.TriggerWithSpecificDataTask.HasRemoteException
                    OR VisionProNet.ReceiveSpecificDataTask.HasRemoteException THEN
                    VisionProNet.Restore();
                END_IF;
                //</VisionProNetErrorRecovery>
                Sequencer.CompleteSequence();
            END_IF;
        END_METHOD
        //</Usage>

        // Commissioning-only task. The component gates SendSpecificDataAndTypes on
        // manual mode, so it is invoked from a manual-control helper rather than the
        // automatic sequence. Activate manual control (ActivateManualControl) first.
        METHOD PUBLIC CommissioningSendData : IAxoTaskState
            //<VisionProNetCommissioning>
            CommissioningSendData := VisionProNet.SendSpecificDataAndTypes();
            //</VisionProNetCommissioning>
        END_METHOD

    END_CLASS
END_NAMESPACE
