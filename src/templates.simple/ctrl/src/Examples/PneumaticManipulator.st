USING AXOpen.Core;
USING System.Strings;

NAMESPACE examples.PneumaticManipulator
   ///<summary>
   /// Groups components of this controller unit.
   ///</summary>
   CLASS Components EXTENDS AXOpen.Core.AxoObject
       VAR PUBLIC
           // HERE DECLARE COMPONENTS USED BY THIS CONTROLLED UNIT
           HorizontalCylinder : AXOpen.Pneumatics.Cylinder;
           VerticalCylinder : AXOpen.Pneumatics.Cylinder;
           GripperCylinder : AXOpen.Pneumatics.Cylinder;
       END_VAR

       METHOD PUBLIC Update
           VAR_INPUT
               parent : IAxoObject;
           END_VAR
           VAR_IN_OUT
               Inputs : axosimple.Inputs;
               Outputs : axosimple.Outputs;
           END_VAR
               THIS.Initialize(parent);
               // HERE INITIALIZE YOUR COMPONENTS
               HorizontalCylinder.Update(THIS,Inputs.B0[0], Inputs.B0[1], Outputs.B0[0], Outputs.B0[1]);
               VerticalCylinder.Update(THIS,Inputs.B0[2], Inputs.B0[3], Outputs.B0[2], Outputs.B0[3]);
               GripperCylinder.Update(THIS,Inputs.B0[4], Inputs.B0[5], Outputs.B0[4], Outputs.B0[5]);
       END_METHOD
   END_CLASS

   CLASS ProcessData EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            CounterDelay : ULINT;
        END_VAR    
    END_CLASS 

   CLASS ProcessDataManger EXTENDS AXOpen.Data.AxoDataExchange
       VAR PUBLIC
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}
           Set : ProcessData;
       END_VAR       
   END_CLASS

   ///<summary>
   /// Represents controlled units and high level task coordination.
   ///</summary>
   CLASS CU EXTENDS AXOpen.Core.AxoObject
       VAR PUBLIC
           ///<summary>
           /// Handles and intializes components used by this unit.
           ///</summary>
           Components : Components;

           ProcessData : ProcessDataManger; 

           ///<summary>
           /// Ground sequence. Contains logic that brings the unit into initial state.
           ///</summary>
           GroundSequence : GroundSequence;
           ///<summary>
           /// Automatic sequence. Contains logic for automatic operations of this unit.
           ///</summary>
           AutomatSequence : AutomatSequence;

           ///<summary>
           /// Service mode contains logic for service/manual operations.
           ///</summary>
           ServiceMode : ServiceMode;
       END_VAR

       ///<summary>
       /// Runs this unit.
       ///</summary>
       METHOD PUBLIC Run
           VAR_INPUT
               parent : IAxoContext;
           END_VAR
           VAR_IN_OUT
               ///<summary>
               /// Hardware input structure
               ///</summary>
               Inputs : axosimple.Inputs;
               ///<summary>
               /// Hardware output structure
               ///</summary>
               Outputs : axosimple.Outputs;
           END_VAR
               THIS.Initialize(parent);
               THIS.Execute(Inputs, Outputs);
           END_METHOD

       METHOD PRIVATE Execute
           VAR_IN_OUT
               Inputs : axosimple.Inputs;
               Outputs : axosimple.Outputs;
           END_VAR

           // Component I/O immange and management handling.
           Components.Update(THIS,Inputs, Outputs);          

           // Process data manager
           ProcessData.Run(THIS);

           // Handles ground sequence
           GroundSequence.Run(THIS, Components, ProcessData);

           // Restores other states when Ground executes
           IF(GroundSequence.IsBusy()) THEN
               AutomatSequence.Restore();
               ServiceMode.Restore();
           END_IF;

           // Handles automatic sequence (ground must be previously done)
           AutomatSequence.IsDisabled := GroundSequence.Status <> eAxoTaskState#Done;           
           AutomatSequence.Run(THIS, Components, ProcessData);
           

           // Handles service/manual mode
           ServiceMode.Run(THIS, Components);
           IF ServiceMode.IsBusy() THEN
               GroundSequence.Restore();
               AutomatSequence.Restore();
           END_IF;
          
       END_METHOD
   END_CLASS

   ///<summary>
   /// Provides automatic mode sequence.
   ///</summary>
   {#ix-set:AttributeName = "<#AUTOMAT#>"}
   CLASS PUBLIC AutomatSequence EXTENDS AXOpen.Core.AxoSequencer
       VAR PUBLIC
           Steps : ARRAY[0..150] OF AxoStep;
       END_VAR
       
       ///<summary>
       /// Runs automatic mode sequence. This method must be called cyclically.
       ///</summary>
       METHOD PUBLIC Run
           VAR_INPUT
               parent : IAxoObject;
           END_VAR
           VAR_IN_OUT
               Components : Components;
               ProcessData : ProcessDataManger;
           END_VAR
               
               // Never remove this!
               THIS.Initialize(parent);
                              
               // This sequecner executes the steps in cycles from top to bottom
               // in the same order they are written in the program
               // Each step in the sequence must can be used only once.

               // This sets the sequence to run in cycles (top-botton-top and again).
               THIS.SequenceMode := eAxoSequenceMode#Cyclic;

               // We need to open sequence by calling Open method.
               THIS.Open();
                              
               // This is more verbose but also more versatile way of executing step logic.
               IF(Steps[0].Execute(THIS, TRUE, 'Move vertical cyclinder down.')) THEN
                   //-------------------------------------------------------
                   IF(components.VerticalCylinder.MoveToWork.Invoke().IsDone()) THEN // <- waits for the task to be done.
                       THIS.MoveNext(); // <- This will move to the next step in the sequence.
                   END_IF;
                   //-------------------------------------------------------
               END_IF;
               // This is more concise way of writing steps when we execute only single task.
               THIS.AndThen(Steps[1],components.GripperCylinder.MoveToWork);
               THIS.AndThen(Steps[2],components.VerticalCylinder.MoveToHome);
               THIS.AndThen(Steps[3],components.HorizontalCylinder.MoveToWork);
               THIS.AndThen(Steps[4],components.VerticalCylinder.MoveToWork);
               THIS.AndThen(Steps[5],components.GripperCylinder.MoveToHome);
               THIS.AndThen(Steps[6],components.VerticalCylinder.MoveToHome);
               THIS.AndThen(Steps[7],components.HorizontalCylinder.MoveToHome);
               THIS.AndThen(Steps[8],components.GripperCylinder.MoveToHome);
               ProcessData.Set.CounterDelay :=  THIS.GetContext().OpenCycleCount();              

               IF(Steps[9].Execute(THIS, TRUE, 'Save data.')) THEN
                //-------------------------------------------------------            
                    IF(ProcessData.Create(ToString(THIS.GetContext().OpenCycleCount())).IsDone()) THEN // <- waits for the task to be done.
                        THIS.MoveNext(); // <- This will move to the next step in the sequence.
                    END_IF;
                //-------------------------------------------------------
                END_IF;               
               // This will close the sequence and will return to the first step.
               THIS.Close(Steps[150]);
       END_METHOD
   END_CLASS

   ///<summary>
   /// Provides ground mode sequence.
   ///</summary>
   {#ix-set:AttributeName = "<#GROUND#>"}
   CLASS PUBLIC GroundSequence EXTENDS AXOpen.Core.AxoSequencer
       VAR PUBLIC
           Steps : ARRAY[0..20] OF AxoStep;
       END_VAR

       ///<summary>
       /// Runs ground mode sequence. This method must be called cyclically.
       ///</summary>
       METHOD PUBLIC Run
           VAR_INPUT
               parent : IAxoObject;
           END_VAR
           VAR_IN_OUT
               Components : Components;
               ProcessData : ProcessDataManger;
           END_VAR

           // Never remove this!
           THIS.Initialize(parent);

           // This sequecner executes the steps in cycles from top to botton
           // in the same order they are written in the program
           // Each step in the sequence must can be used only once.

           // This sets the sequence to run once (top-botton) and stops with done after closing.
           THIS.SequenceMode := eAxoSequenceMode#RunOnce;

           // We need to open sequence by calling Open method.
           THIS.Open();

           // This is more verbose but also more versatile way of executing step logic.
           IF(Steps[0].Execute(THIS, TRUE, 'Move vertical cyclinder down.')) THEN
               //-------------------------------------------------------
               IF(components.VerticalCylinder.MoveToHome.Invoke().IsDone()) THEN // <- waits for the task to be done.
                   THIS.MoveNext(); // <- This will move to the next step in the sequence.
               END_IF;
               //-------------------------------------------------------
           END_IF;

           // This is more concise way of writing steps when we execute only single task.
           THIS.AndThen(Steps[1],components.GripperCylinder.MoveToHome);
           THIS.AndThen(Steps[2],components.VerticalCylinder.MoveToHome);
           THIS.AndThen(Steps[3],components.HorizontalCylinder.MoveToHome);

           // This will close the sequence and will return to the first step.
           THIS.Close(Steps[20]);
       END_METHOD
   END_CLASS

   ///<summary>
   /// Provides logic for service/manual/maintenance mode.
   ///</summary>
   {#ix-set:AttributeName = "<#SERVICE#>"}
   CLASS PUBLIC ServiceMode EXTENDS AXOpen.Core.AxoTask
       ///<summary>
       /// Runs service mode logic. This method must be called cyclically.
       ///</summary>
       METHOD PUBLIC Run
           VAR_INPUT
               parent : IAxoObject;
           END_VAR
           VAR_IN_OUT
               components : Components;
           END_VAR

           THIS.Initialize(parent);

           IF THIS.Execute() THEN
               THIS.Handle(components);
           END_IF;
       END_METHOD

       METHOD PRIVATE Handle
           VAR_IN_OUT
               components : Components;
           END_VAR
           ;
           // HERE CALL LOGIC FOR MANUAL/SERICE OPERATIONS
           components.HorizontalCylinder.ActivateManualControl();
           components.VerticalCylinder.ActivateManualControl();
           components.GripperCylinder.ActivateManualControl();
       END_METHOD
   END_CLASS

END_NAMESPACE