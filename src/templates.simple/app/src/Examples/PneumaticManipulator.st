USING axosimple;
USING AXOpen.Data;

NAMESPACE examples.PneumaticManipulator
    USING AXOpen.Core;
    USING System.Strings;

    ///<summary>
    /// Groups components of this controller unit.
    ///</summary>
    CLASS Components
        EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            // HERE DECLARE COMPONENTS USED BY THIS CONTROLLED UNIT
            HorizontalCylinder : AXOpen.Components.Pneumatics.AxoCylinder;
            VerticalCylinder : AXOpen.Components.Pneumatics.AxoCylinder;
            GripperCylinder : AXOpen.Components.Pneumatics.AxoCylinder;
            DMCReader : AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoDataman;
            PartPresenceSensor : AXOpen.Elements.AxoDi;
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
            HorizontalCylinder.Run(THIS, Inputs.B0[0], Inputs.B0[1], Outputs.B0[0], Outputs.B0[1]);
            VerticalCylinder.Run(THIS, Inputs.B0[2], Inputs.B0[3], Outputs.B0[2], Outputs.B0[3]);
            GripperCylinder.Run(THIS, Inputs.B0[4], Inputs.B0[5], Outputs.B0[4], Outputs.B0[5]);
                        
        END_METHOD
    END_CLASS

    CLASS FragmentProcessData
        EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            CounterDelay : ULINT;
            _presenceInspector: AXOpen.Inspectors.AxoDigitalInspector;
            _valueInspector: AXOpen.Inspectors.AxoAnalogueInspector;
            _dataInspector: AXOpen.Inspectors.AxoDataInspector;
        END_VAR
    END_CLASS

    CLASS FragmentProcessDataManger
        EXTENDS AXOpen.Data.AxoDataExchange
        VAR PUBLIC
            {#ix-generic:TOnline}
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}        
            {#ix-attr:[Container(Layout.Stack)]}        
            Set : FragmentProcessData;
        END_VAR
    END_CLASS

    CLASS ProcessDataManger
        EXTENDS AXOpen.Data.AxoDataFragmentExchange
        VAR PUBLIC
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Shared : SharedProductionDataManager;
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            DataManger : FragmentProcessDataManger;
        END_VAR        
    END_CLASS

    ///<summary>
    /// Represents controlled units and high level task coordination.
    ///</summary>
    CLASS CU
        EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            ///<summary>
            /// Handles and intializes components used by this unit.
            ///</summary>
            Components : Components;

            ProcessData : REF_TO ProcessDataManger;

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
            Components.Update(THIS, Inputs, Outputs);
            // Process data manager
            ProcessData^.Run(THIS);
            // Handles ground sequence
            GroundSequence.Run(REF(Components), ProcessData, THIS);
            // Restores other states when Ground executes
            IF (GroundSequence.IsBusy()) THEN
                AutomatSequence.Restore();
                ServiceMode.Restore();
            END_IF;
            // Handles automatic sequence (ground must be previously done)           
            AutomatSequence.IsDisabled := GroundSequence.Status <> eAxoTaskState#Done;
            AutomatSequence.Run(REF(Components), ProcessData, THIS);
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
    CLASS PUBLIC AutomatSequence
        EXTENDS AXOpen.Core.AxoSequencerContainer
        VAR PUBLIC
            Steps : ARRAY[0..150] OF AxoStep;
            _dialog : AXOpen.Core.AxoDialog;
            _dialog1 : AXOpen.Core.AxoDialog;
            _dialog2 : AXOpen.Core.AxoDialog;
            _dialog3 : AXOpen.Core.AxoDialog;
            _alertDialog : AXOpen.Core.AxoAlertDialog;
            _presenceInspector: AXOpen.Inspectors.AxoDigitalInspector;
            _valueInspector: AXOpen.Inspectors.AxoAnalogueInspector;
            _dataInspector: AXOpen.Inspectors.AxoDataInspector;
            _data: AXOpen.Inspectors.AxoDigitalInspectorData;
            _comprehensiveResult: AXOpen.Inspectors.AxoComprehensiveResult;
            _inspectionResult:BOOL;
            _inspectionValue:LREAL;
            _inspectionData: STRING;
            _externalClose : BOOL;
        END_VAR
        VAR PRIVATE
            Components : REF_TO Components;
            ProcessData : REF_TO ProcessDataManger;
            
        END_VAR

        METHOD INTERNAL Run
            VAR_INPUT
                _components : REF_TO Components;
                _processData : REF_TO ProcessDataManger;
                _parent : IAxoObject;
            END_VAR
            Components := _components;
            ProcessData := _processData;
            SUPER.Run(_parent);
        END_METHOD
        ///<summary>
        /// Contains logic of the steps of this sequence
        ///</summary>

        METHOD OVERRIDE Main
            IF (Components = NULL OR ProcessData = NULL) THEN
                RETURN;
            END_IF;
            // This sequecner executes the steps in cycles from top to bottom
            // in the same order they are written in the program
            // Each step in the sequence must can be used only once.
            // This sets the sequence to run in cycles (top-botton-top and again).
            THIS.SequenceMode := eAxoSequenceMode#Cyclic;
            // This is more verbose but also more versatile way of executing step logic.
            IF (Steps[0].Execute(THIS, TRUE, 'Move vertical cyclinder down.')) THEN
                //-------------------------------------------------------
                IF (components^.VerticalCylinder._MoveToHomeTask.Invoke().IsDone()) THEN // <- waits for the task to be done.
                    THIS.MoveNext(); // <- This will move to the next step in the sequence.
                END_IF;
//-------------------------------------------------------
            END_IF;
            // This is more concise way of writing steps when we execute only single task.
            THIS.AndThen(Steps[1], components^.GripperCylinder._MoveToWorkTask);
            THIS.AndThen(Steps[2], components^.VerticalCylinder._MoveToHomeTask);
            THIS.AndThen(Steps[3], components^.HorizontalCylinder._MoveToWorkTask);
            THIS.AndThen(Steps[4], components^.VerticalCylinder._MoveToWorkTask);
            THIS.AndThen(Steps[5], components^.GripperCylinder._MoveToHomeTask);
            THIS.AndThen(Steps[6], components^.VerticalCylinder._MoveToHomeTask);
            THIS.AndThen(Steps[7], components^.HorizontalCylinder._MoveToHomeTask);
            THIS.AndThen(Steps[8], components^.GripperCylinder._MoveToHomeTask);
            
            IF(Steps[9].Execute(THIS, TRUE, 'Create data id')) THEN

                ProcessData^.DataManger.Set.CounterDelay := THIS.GetContext().OpenCycleCount();
                THIS.MoveNext(); 

            END_IF;    

            IF (Steps[10].Execute(THIS, TRUE, 'Save data.')) THEN
                //-------------------------------------------------------            
                IF (ProcessData^.Create(ToString(ProcessData^.DataManger.Set.CounterDelay)).IsDone()) THEN // <- waits for the task to be done.
                    THIS.MoveNext(); // <- This will move to the next step in the sequence.
                END_IF;
                THIS.MoveNext();
                //-------------------------------------------------------
            END_IF;


            IF (Steps[15].Execute(THIS, TRUE, 'Show alert from plc.')) THEN
                //-------------------------------------------------------        
                   IF(_alertDialog.Show(THIS)
                        .WithTitle('Plc alert')
                        .WithType(eDialogType#Success)
                        .WithMessage('This is alert invoked from plc!')
                        .WithTimeToBurn(UINT#5).IsShown() = true) THEN
                        THIS.MoveNext(); 
                    END_IF;	


            //-------------------------------------------------------
            END_IF;

            IF (Steps[16].Execute(THIS, TRUE, 'Set inpsection times')) THEN
                //--------------------------------------------

                _valueInspector.Data()^.FailTime := TIME#3s;
                _presenceInspector.Data()^.FailTime := TIME#3s;
                _dataInspector.Data()^.FailTime := TIME#3s;

                _valueInspector.Data()^.PassTime := TIME#2s;
                _presenceInspector.Data()^.PassTime := TIME#2s;
                _dataInspector.Data()^.PassTime := TIME#2s;
            
                _valueInspector.Data()^.NumberOfAllowedRetries := UINT#3;

                THIS.MoveNext(); 
                //--------------------------------------------	
            END_IF;
        

            IF (Steps[20].Execute(THIS, TRUE, 'RETRY STEP 90')) THEN
                
                IF(Steps[20].Duration > T#2000ms) THEN
                    THIS.MoveNext(); 
                END_IF;	
             
                
            END_IF;


            IF (Steps[30].Execute(THIS, TRUE, 'Example Digital inspection')) THEN
                //-------------------------------------------------------

                _presenceInspector.WithCoordinator(THIS).Inspect(THIS,_inspectionResult).UpdateComprehensiveResult(_comprehensiveResult).OnFail().Dialog(Steps[20], Steps[145]);

                //-------------------------------------------------------
             END_IF;

             IF (Steps[40].Execute(THIS, TRUE, 'Example Analog inspection')) THEN
                //-------------------------------------------------------
             

                _valueInspector.WithCoordinator(THIS).Inspect(THIS,_inspectionValue).UpdateComprehensiveResult(_comprehensiveResult).OnFail().Dialog(Steps[20], Steps[145]);

                //-------------------------------------------------------
             END_IF;


             IF (Steps[50].Execute(THIS, TRUE, 'Example Data inspection')) THEN
                //-------------------------------------------------------
              
                _dataInspector.WithCoordinator(THIS).Inspect(THIS,_inspectionData).UpdateComprehensiveResult(_comprehensiveResult).OnFail().Dialog(Steps[20], Steps[145]);

                //-------------------------------------------------------
            END_IF;



            IF (Steps[60].Execute(THIS, TRUE, 'Show dialog 0')) THEN
                //------------------------------------------------------- 
            
                    IF(_dialog.Show(THIS)
                        .WithOk()
                        .WithType(eDialogType#Success)
                        .WithCaption('What`s next?')
                        .WithText('To continue click OK?').Answer() = eDialogAnswer#OK) THEN

                        
                        THIS.RequestStep(Steps[149]);
                //-------------------------------------------------------
                END_IF;	
            END_IF;

            IF (Steps[145].Execute(THIS, TRUE, 'Restore origin step')) THEN
                //-------------------------------------------------------
 
                ;

            // //-------------------------------------------------------
            END_IF;


            IF (Steps[149].Execute(THIS, TRUE, 'Dummy end')) THEN
                //-------------------------------------------------------
                THIS.MoveNext();

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
    CLASS PUBLIC GroundSequence
        EXTENDS AXOpen.Core.AxoSequencerContainer
        VAR PUBLIC
            Steps : ARRAY[0..20] OF AxoStep;      
            MoveToWork : AxoTask;
        END_VAR
        VAR PRIVATE
            Components : REF_TO Components;
            ProcessData : REF_TO ProcessDataManger;
        END_VAR

        METHOD INTERNAL Run
            VAR_INPUT
                _components : REF_TO Components;
                _processData : REF_TO ProcessDataManger;
                _parent : IAxoObject;
            END_VAR            
            Components := _components;
            ProcessData := _processData;
            SUPER.Run(_parent);
            
            // MoveToWork.Initialize(THIS);

        END_METHOD
        ///<summary>
        /// Contains logic of the steps of this sequence
        ///</summary>

        METHOD PROTECTED OVERRIDE Main
            // IF (Components = NULL OR ProcessData = NULL) THEN
            //     RETURN;
            // END_IF;
            // This sequecner executes the steps in cycles from top to bottom
            // in the same order they are written in the program
            // Each step in the sequence must can be used only once.
            // This sets the sequence to run once (top-botton) and stops with done after closing.
            THIS.SequenceMode := eAxoSequenceMode#RunOnce;
            // This is more verbose but also more versatile way of executing step logic.
            IF (Steps[0].Execute(THIS, TRUE, 'Move vertical cyclinder down.')) THEN
                //-------------------------------------------------------                  
                IF (components^.VerticalCylinder._MoveToHomeTask.Invoke().IsDone()) THEN // <- waits for the task to be done.                
                    THIS.MoveNext(); // <- This will move to the next step in the sequence.                    
                END_IF;                       
            //-------------------------------------------------------
            END_IF;
            
            IF (Steps[4].Execute(THIS, TRUE, 'This will break down')) THEN
                //-------------------------------------------------------                    
                    THIS.MoveNext();                                   
                //-------------------------------------------------------
            END_IF;

            // This is more concise way of writing steps when we execute only single task.
            THIS.AndThen(Steps[1], components^.GripperCylinder._MoveToHomeTask);
            THIS.AndThen(Steps[2], components^.VerticalCylinder._MoveToHomeTask);
            THIS.AndThen(Steps[3], components^.HorizontalCylinder._MoveToHomeTask);
           
            // This will close the sequence and will return to the first step.
            THIS.Close(Steps[20]);
        END_METHOD
    END_CLASS

    ///<summary>
    /// Provides logic for service/manual/maintenance mode.
    ///</summary>
    {#ix-set:AttributeName = "<#SERVICE#>"}
    CLASS PUBLIC ServiceMode
        EXTENDS AXOpen.Core.AxoTask
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