NAMESPACE sandboxtest.StandardControlUnit

   USING AXOpen.Core;
   USING System.Strings;
   USING AXOpen.Cognex.Vision.v_6_0_0_0;

   ///<summary>
   /// Groups components of this controller unit.
   ///</summary>
   CLASS Components EXTENDS AXOpen.Core.AxoObject

       VAR PUBLIC
            {#ix-attr:[Container(Layout.Tabs)]}
           // HERE DECLARE COMPONENTS USED BY THIS CONTROLLED UNIT
           {#ix-set:AttributeName = "<#Cylinder 1#>"} 
           Cylinder_1 : AXOpen.Components.Pneumatics.AxoCylinder; 
           {#ix-set:AttributeName = "<#Cylinder 2#>"} 
           Cylinder_2 : AXOpen.Components.Pneumatics.AxoCylinder;
           {#ix-set:AttributeName = "<#Cylinder 3#>"} 
           Cylinder_3 : AXOpen.Components.Pneumatics.AxoCylinder;
           {#ix-set:AttributeName = "<#Cylinder 4#>"} 
           Cylinder_4 : AXOpen.Components.Pneumatics.AxoCylinder;
           {#ix-set:AttributeName = "<#Cylinder 5#>"} 
           Cylinder_5 : AXOpen.Components.Pneumatics.AxoCylinder;
           {#ix-set:AttributeName = "<#Cylinder 6#>"} 
           Cylinder_6 : AXOpen.Components.Pneumatics.AxoCylinder;
           {#ix-set:AttributeName = "<#Cylinder 7#>"} 
           Cylinder_7 : AXOpen.Components.Pneumatics.AxoCylinder;
           {#ix-set:AttributeName = "<#Cylinder 8#>"} 
           Cylinder_8 : AXOpen.Components.Pneumatics.AxoCylinder;

            {#ix-set:AttributeName = "Camera 1"}
            Camera_1 : AXOpen.Cognex.Vision.v_6_0_0_0.AxoInsight; 

            {#ix-set:AttributeName = "Reader 1"}
            Reader_1 : AXOpen.Cognex.Vision.v_6_0_0_0.AxoDataman;  
            
            {#ix-set:AttributeName = "Reader 2"}
            Reader_2 : AXOpen.Cognex.Vision.v_6_0_0_0.AxoDataman;  
            
       END_VAR

       METHOD PUBLIC Update
           VAR_INPUT
               parent : IAxoObject;
           END_VAR
           VAR_IN_OUT
               Inputs : sandboxtest.Inputs;
               Outputs : sandboxtest.Outputs;
           END_VAR
               THIS.Initialize(parent);

               // HERE INITIALIZE YOUR COMPONENTS
            Cylinder_1.Run(THIS,
            Inputs.  B0[1], 
            Inputs.  B1[1],
            Outputs. B0[1], 
            Outputs. B1[1]
            );

            // HERE INITIALIZE YOUR COMPONENTS
            Cylinder_2.Run(THIS,
            Inputs.  B0[2], 
            Inputs.  B1[2],
            Outputs. B0[2], 
            Outputs. B1[2]
            );


                        // HERE INITIALIZE YOUR COMPONENTS
            Cylinder_3.Run(THIS,
            Inputs.  B0[3], 
            Inputs.  B1[3],
            Outputs. B0[3], 
            Outputs. B1[3]
            );


            // HERE INITIALIZE YOUR COMPONENTS
            Cylinder_4.Run(THIS,
            Inputs.  B0[4], 
            Inputs.  B1[4],
            Outputs. B0[4], 
            Outputs. B1[4]
            );


                        // HERE INITIALIZE YOUR COMPONENTS
            Cylinder_5.Run(THIS,
            Inputs.  B0[5], 
            Inputs.  B1[5],
            Outputs. B0[5], 
            Outputs. B1[5]
            );

            Cylinder_6.Run(THIS,
            Inputs.  B0[6], 
            Inputs.  B1[6],
            Outputs. B0[6], 
            Outputs. B1[6]
            );

            Cylinder_7.Run(THIS,
            Inputs.  B0[7], 
            Inputs.  B1[7],
            Outputs. B0[7], 
            Outputs. B1[7]
            );

            Cylinder_8.Run(THIS,
            Inputs.  B0[0], 
            Inputs.  B1[0],
            Outputs. B0[0], 
            Outputs. B1[0]
            );
               
            // Reader_1.Run( parent            :=  THIS,  
            //     refAcquisitionStatus        :=  REF(Inputs._Reader_1_Acquisition_Status_1),
            //     refSoftEventStatus          :=  REF(Inputs._Reader_1_Soft_Event_Control_1),
            //     refResultsStatus            :=  REF(Inputs._Reader_1_Results_Status_1),
            //     refResultData               :=  REF(Inputs._Reader_1_Result_Data_128_bytes_1),
 
            //     refUserData                 :=  REF(Outputs._Reader_1_User_Data_128_bytes_1),
            //     refAcquisitionControl       :=  REF(Outputs._Reader_1_Acquisition_Control_1),
            //     refResultsControl           :=  REF(Outputs._Reader_1_Results_Control_1),
            //     refSoftEventControl         :=  REF(Outputs._Reader_1_Soft_Event_Control_1)
            // );


       END_METHOD
   END_CLASS
   
   
   {#ix-attr:[Container(Layout.Tabs)]}
   CLASS FragmentProcessData EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC

            {#ix-set:AttributeName = "<#CounterDelay. #>"} 
            CounterDelay : ULINT;
            
            // {#ix-set:AttributeName = "Primitive Hierarchy"} 
            // {#ix-attr:[Container(Layout.Stack)]}
            // {#ix-attr:[Group(GroupLayout.GroupBox)]}
            // hierarchy : hierarchy_2;
            
            {#ix-set:AttributeName = "<#Kontrola 1.#>"} 
            Check_1 :  AXOpen.Inspectors.AxoDigitalInspector;
            {#ix-set:AttributeName = "<#Kontrola 2.#>"} 
            Check_2 :  AXOpen.Inspectors.AxoDigitalInspector;
            {#ix-set:AttributeName = "<#Kontrola 3.#>"} 
            Check_3 :  AXOpen.Inspectors.AxoDigitalInspector;
            {#ix-set:AttributeName = "<#Kontrola 4.#>"} 
            Check_4 :  AXOpen.Inspectors.AxoDigitalInspector;
            {#ix-set:AttributeName = "<#Kontrola 5.#>"} 
            Check_5 :  AXOpen.Inspectors.AxoDigitalInspector;
            {#ix-set:AttributeName = "<#Kontrola 6.#>"} 
            Check_6 : AXOpen.Inspectors.AxoAnalogueInspector;
            {#ix-set:AttributeName = "<#Kontrola 7.#>"} 
            Check_7 : AXOpen.Inspectors.AxoAnalogueInspector;
            {#ix-set:AttributeName = "<#Kontrola 8.#>"} 
            Check_8 : AXOpen.Inspectors.AxoDataInspector;


           

        END_VAR    
    END_CLASS 


    // just prepared but not used -> reason -> Exist task not exist yet
INTERFACE PUBLIC ITestIdGenerator
    METHOD  GetSize : Int
    END_METHOD

    METHOD Increment : BOOL
    END_METHOD

    METHOD  GetRootRecordName : STRING
    END_METHOD

    METHOD GetNext : STRING
    END_METHOD

    METHOD  InitializeWithPrefix 
        VAR_INPUT
            Prefix : STRING;
        END_VAR
    END_METHOD
END_INTERFACE


 {#ix-attr:[RenderIgnore()]}
     CLASS PUBLIC TestIdGenerator EXTENDS AXOpen.Core.AxoObject IMPLEMENTS ITestIdGenerator 
        // VAR  CONSTANT PUBLIC
        //     {#ix-attr:[RenderIgnore()]}
        //     MAX_SIZE : INT := 1000; (* Comment *)
        //     {#ix-attr:[RenderIgnore()]}
        //     ROOT_RECORD_NAME : STRING := 'process_set'; (* Comment *)
        // END_VAR 

        VAR 

            {#ix-attr:[RenderIgnore()]}
            _Names : ARRAY[0..10] OF STRING;
            CurrentIndex : INT ;
            LastId : STRING; 
        END_VAR    
        


        METHOD PUBLIC GetNext : STRING

            IF CurrentIndex < 0 THEN
                CurrentIndex := 0;
            END_IF; 

            IF CurrentIndex > 10 THEN
                CurrentIndex := 0;
            END_IF; 

            LastId := _Names[CurrentIndex];

            GetNext := LastId;
        END_METHOD

        METHOD PUBLIC Increment  : BOOL
            CurrentIndex := CurrentIndex + 1;

            Increment := CurrentIndex <= 10;
        END_METHOD

        METHOD PUBLIC GetSize : Int
            GetSize := 10;
        END_METHOD

        METHOD PUBLIC GetRootRecordName : STRING
            GetRootRecordName := 'process_set';
        END_METHOD

    
    METHOD PUBLIC InitializeWithPrefix
        VAR_INPUT
            Prefix : STRING;
        END_VAR

       VAR
        index: INT := 0; (* LOCAL INDEX *)
       END_VAR

       THIS.CurrentIndex := 0;

        FOR index := 0 TO 10 BY 1 DO
            _Names[index] := Concat( Prefix ,'_' , ToString(index) );
        END_FOR;

    END_METHOD
END_CLASS


   CLASS FragmentProcessDataManger EXTENDS AXOpen.Data.AxoDataExchange
       VAR PUBLIC
            {#ix-generic:TOnline}
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}        
            {#ix-attr:[Container(Layout.Stack)]} 
            {#ix-set:AttributeName = "Cux"} 
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
   CLASS CU EXTENDS AXOpen.Core.AxoObject

       VAR PUBLIC
           ///<summary>
           /// Handles and intializes components used by this unit.
           ///</summary>
           Components : Components;
           
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

           StationName : STRING;

           Ids : TestIdGenerator;
           SettingSourceManager : AXOpen.DATA.IAxoDataExchange;
           SettingSourceData : REF_TO FragmentProcessData;

           ProcessData : REF_TO ProcessDataManger;

       END_VAR


        METHOD PUBLIC InvokeMode : Int
        VAR_INPUT
            iMode : int;
        END_VAR
        ;
        InvokeMode  := 0;

        CASE iMode  OF
            10: 
            AutomatSequence.Invoke();

            IF AutomatSequence.IsBusy() THEN
                InvokeMode := iMode;
            END_IF;

            20: 
            GroundSequence.Invoke();

            IF GroundSequence.IsDone() THEN
                InvokeMode := iMode;
            END_IF;

            30: 
            ServiceMode.Invoke();

            IF ServiceMode.IsBusy() THEN
                InvokeMode := iMode;
            END_IF;

        END_CASE;

       END_METHOD


       ///<summary>
       /// Runs this unit.
       ///</summary>
       METHOD PUBLIC Run
           VAR_INPUT
               _parent : AXOpen.Core.IAxoContext;
               _stationName : STRING;
               _settingSourceManager : AXOpen.DATA.IAxoDataExchange;
               _settingSourceData : REF_TO FragmentProcessData;
               
           END_VAR

           VAR_IN_OUT
               ///<summary>
               /// Hardware input structure
               ///</summary>
               _Inputs : sandboxtest.Inputs;
               ///<summary>
               /// Hardware output structure
               ///</summary>
               _Outputs : sandboxtest.Outputs;
           END_VAR

                StationName := _stationName;
                SettingSourceManager :=  _settingSourceManager;
                SettingSourceData := _settingSourceData;
                
               THIS.Initialize(_parent);
               THIS.Execute(_Inputs, _Outputs);
           END_METHOD

       METHOD PRIVATE Execute
           VAR_IN_OUT
               Inputs : sandboxtest.Inputs;
               Outputs : sandboxtest.Outputs;
           END_VAR

           // Component I/O immange and management handling.
           Components.Update(THIS,Inputs, Outputs);          

           // Process data manager
           ProcessData^.Run(THIS);

           // Handles ground sequence
           GroundSequence.Run(
                            THIS,
                            REF(Components), 
                            ProcessData, 
                            SettingSourceData, 
                            SettingSourceManager,
                            Ids
            );  

           // Restores other states when Ground executes
           IF(GroundSequence.IsBusy()) THEN
               AutomatSequence.Restore();
               ServiceMode.Restore();
           END_IF;

           // Handles automatic sequence (ground must be previously done)           
           AutomatSequence.IsDisabled := GroundSequence.Status <> eAxoTaskState#Done;  

           AutomatSequence.Run( 
                                THIS,
                                REF(Components), 
                                ProcessData, 
                                SettingSourceData, 
                                SettingSourceManager,
                                Ids,
                                REF(StationName)
                                );                  

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
   CLASS PUBLIC AutomatSequence EXTENDS AXOpen.Core.AxoSequencerContainer
       VAR PUBLIC
           Steps : ARRAY[0..80] OF AxoStep;        
       END_VAR
        VAR PRIVATE
            Components : REF_TO Components;
            ProcessData : REF_TO ProcessDataManger;
            SettingSourceData : REF_TO FragmentProcessData;
            SettingSourceManager : AXOpen.DATA.IAxoDataExchange;

            StationName : REF_TO STRING;

            Ids : ITestIdGenerator;
            
            LastGeneratedId : ARRAY[0..80] of STRING;


        END_VAR  
       
        METHOD INTERNAL Run
            VAR_INPUT     
                _parent : IAxoObject;
                _components : REF_TO Components;
                _processData : REF_TO ProcessDataManger;
                _SettingSourceData : REF_TO FragmentProcessData;
                
                _SettingSourceManager : AXOpen.DATA.IAxoDataExchange;
                _ids :  ITestIdGenerator;
                _StationName : REF_TO STRING;

            END_VAR     
            
           
            Components := _components;
            ProcessData := _processData;
            StationName := _StationName;

            Ids := _ids;

            SettingSourceData := _SettingSourceData; 
            SettingSourceManager := _SettingSourceManager;  

            SUPER.Run(_parent);
        END_METHOD

       
        ///<summary>
        /// Contains logic of the steps of this sequence
        ///</summary>
       METHOD OVERRIDE Main 

            VAR
                ForIndex : INT;
            END_VAR;


            IF (Components = NULL OR ProcessData = NULL) THEN                
                RETURN;
            END_IF;    

            // This sequecner executes the steps in cycles from top to bottom
            // in the same order they are written in the program
            // Each step in the sequence must can be used only once.

            // This sets the sequence to run in cycles (top-botton-top and again).
            //THIS.SequenceMode := eAxoSequenceMode#Cyclic;

            // IF (Steps[1].Execute(THIS, TRUE, 'reading produced')) THEN
            //     //-------------------------------------------------------            
            //         IF (ProcessData^.Read('produced').IsDone()) THEN 
            //             THIS.MoveNext(); 
            //             ProcessData^.Restore();
            //         END_IF;
            //     //-------------------------------------------------------
            // END_IF;

            // IF (Steps[2].Execute(THIS, TRUE, 'continue')) THEN
         
            //     THIS.MoveNext(); 
            // END_IF;


            FOR ForIndex := 1 TO 14 DO
                THIS.CallStepsReadCreateUpdate(5*ForIndex, ForIndex);
            //    THIS.CallStepsReadCreateUpdate(5*1, 1);
            //    THIS.CallStepsReadCreateUpdate(5*2, 2);
            //    THIS.CallStepsReadCreateUpdate(5*3, 3);
            END_FOR;

            // This will close the sequence and will return to the first step.
          
            THIS.Close(Steps[80]);
           
       END_METHOD
    
       METHOD INTERNAL DataStep 
            VAR_INPUT
                StepIndex : INT;
                IdIndex : INT;
                operation : INT ; // create 10, read 20, update 30 delete 40
            END_VAR

            CASE operation OF

                10: 
                    IF (Steps[StepIndex].Execute(THIS, TRUE, 'creating')) THEN
                    //IF (Steps[StepIndex].Execute(THIS, TRUE, Concat('Step ', ToString(StepIndex),', creating ', LastGeneratedId[IdIndex] ))) THEN
                        //-------------------------------------------------------            
                            IF (ProcessData^.CreateOrUpdate(LastGeneratedId[IdIndex] ).IsDone()) THEN 
                                THIS.MoveNext(); 
                                ProcessData^.Restore();
                            END_IF;
                        //-------------------------------------------------------
                    END_IF;

                20: 
                IF (Steps[StepIndex].Execute(THIS, TRUE, 'reading')) THEN
                   // IF (Steps[StepIndex].Execute(THIS, TRUE, Concat('Step ', ToString(StepIndex),', reading ', LastGeneratedId[IdIndex] ))) THEN
                        //-------------------------------------------------------            
                            IF (ProcessData^.Read(LastGeneratedId[IdIndex] ).IsDone()) THEN 
                                THIS.MoveNext(); 
                                ProcessData^.Restore();
                            END_IF;
                        //-------------------------------------------------------
                    END_IF;

                30: 
                IF (Steps[StepIndex].Execute(THIS, TRUE, 'updating')) THEN
                   // IF (Steps[StepIndex].Execute(THIS, TRUE, Concat('Step ', ToString(StepIndex),', updating ', LastGeneratedId[IdIndex] ))) THEN
                        //-------------------------------------------------------            
                            IF (ProcessData^.Update(LastGeneratedId[IdIndex] ).IsDone()) THEN 
                                THIS.MoveNext(); 
                                ProcessData^.Restore();
                            END_IF;
                        //-------------------------------------------------------
                    END_IF;

                    
                40: 
                IF (Steps[StepIndex].Execute(THIS, TRUE, 'deleting')) THEN
                //IF (Steps[StepIndex].Execute(THIS, TRUE, Concat('Step ', ToString(StepIndex),', deleting ', LastGeneratedId[IdIndex] ))) THEN
                    //-------------------------------------------------------            
                        IF (ProcessData^.Delete(LastGeneratedId[IdIndex] ).IsDone()) THEN 
                            THIS.MoveNext(); 
                            ProcessData^.Restore();
                        END_IF;
                    //-------------------------------------------------------
                END_IF;

            END_CASE;

       END_METHOD
    
       METHOD INTERNAL CreateId 
        VAR_INPUT
            StepIndex : INT;
            IdIndex : INT;
        END_VAR
            IF (Steps[StepIndex].Execute(THIS, TRUE, 'Generating Id : ')) THEN
        
             //IF (Steps[StepIndex].Execute(THIS, TRUE, Concat('Step ', ToString(StepIndex),', Generating Id on index: ', ToString( IdIndex) ))) THEN
                LastGeneratedId[IdIndex] := Concat(StationName^,'_',ToString(THIS.GetContext().OpenCycleCount()));
                THIS.MoveNext();
            END_IF; 
       END_METHOD

       METHOD INTERNAL CallStepsReadCreateUpdate 
            VAR_INPUT
                FromStepIndex : INT;
                IdIndex : INT;
            END_VAR
            
            THIS.CreateId((FromStepIndex + 0), IdIndex); // generate id

            THIS.DataStep((FromStepIndex + 1), IdIndex, 10); // create...

            THIS.DataStep((FromStepIndex + 2), IdIndex, 20); // read...

            THIS.DataStep((FromStepIndex + 3), IdIndex, 30); // update...

           // THIS.DataStep((FromStepIndex + 4), IdIndex, 40); // delete...

    END_METHOD

    


    END_CLASS

   ///<summary>
   /// Provides ground mode sequence.
   ///</summary>
   {#ix-set:AttributeName = "<#GROUND#>"}
   CLASS PUBLIC GroundSequence EXTENDS AXOpen.Core.AxoSequencerContainer
       VAR PUBLIC
           Steps : ARRAY[0..20] OF AxoStep;
       END_VAR

       VAR PRIVATE
            Components : REF_TO Components;
            ProcessData : REF_TO ProcessDataManger;

            Ids :  StandardControlUnit.ITestIdGenerator;
            SettingSourceManager : AXOpen.DATA.IAxoDataExchange;
            SettingSourceData : REF_TO FragmentProcessData;
            StationName : REF_TO STRING;
       END_VAR 
       
        METHOD INTERNAL Run
            VAR_INPUT               
                _parent : IAxoObject;
                _components : REF_TO Components;
                _processData : REF_TO ProcessDataManger;
                _SettingSourceData : REF_TO FragmentProcessData;
                
                _SettingSourceManager : AXOpen.DATA.IAxoDataExchange;
                _ids :  StandardControlUnit.ITestIdGenerator;
                _StationName : REF_TO STRING;

            END_VAR     
            
            Components := _components;
            ProcessData := _processData;

            Ids := _ids;
            SettingSourceData := _SettingSourceData; 
            SettingSourceManager := _SettingSourceManager;  
            StationName := _StationName;

            SUPER.Run(_parent);
        END_METHOD
        
        ///<summary>
        /// Contains logic of the steps of this sequence
        ///</summary>
        METHOD PROTECTED OVERRIDE Main

            IF(Components = NULL OR ProcessData = NULL) THEN                
                RETURN;
            END_IF; 

           // This sequecner executes the steps in cycles from top to botton
           // in the same order they are written in the program
           // Each step in the sequence must can be used only once.

           // This sets the sequence to run once (top-botton) and stops with done after closing.
           THIS.SequenceMode := eAxoSequenceMode#RunOnce;

        //    IF (Steps[0].Execute(THIS, TRUE, 'RESET COMPONENTOV')) THEN
        //     //-------------------------------------------------------   
        //         Ids.InitializeWithPrefix( THIS.StationName^);
        //         THIS.MoveNext(); // <- This will move to the next step in the sequence.
        //     //-------------------------------------------------------
        //     END_IF; 

           IF (Steps[0].Execute(THIS, TRUE, 'NACITANIE NASTAVENI-process_set')) THEN
            //-------------------------------------------------------   
            ;
            //Ids.GetRootRecordName();
                IF (SettingSourceManager.Read( 'process_set' ).IsDone()) THEN // <- waits for the task to be done.
                        THIS.MoveNext(); // <- This will move to the next step in the sequence.
                END_IF;
            //-------------------------------------------------------
            END_IF; 


            // IF (Steps[2].Execute(THIS, TRUE,  Concat('VYTVORENIE ZAZNAMU ',Ids.GetNext() ))) THEN
            //     //-------------------------------------------------------   
            //         IF (THIS.ProcessData^.Create( Ids.GetRootRecordName()).IsDone()) THEN // <- waits for the task to be done.
            //                 THIS.MoveNext(); // <- This will move to the next step in the sequence.
                          
            //         END_IF;
            //     //-------------------------------------------------------
            // END_IF; 

            // IF (Steps[3].Execute(THIS, TRUE,  'KONTROLA VYTVORENIA POSLEDNEHO ZAZNAMU')) THEN
            //     //-------------------------------------------------------   
            //         IF  Ids.Increment() THEN 
            //             THIS.RequestStep(RequestedStep := Steps[2]); 
            //         ELSE
            //             THIS.MoveNext(); 
            //         END_IF;
            //     //-------------------------------------------------------
            // END_IF; 

           THIS.Close(Steps[20]);

       END_METHOD
      

       METHOD INTERNAL FillProcessData 
        VAR_INPUT
            Header : REF_TO SharedProductionData;
            tData : REF_TO FragmentProcessData;
        END_VAR
        Header^.GoesTo :=  Header^.ComesFrom;
        Header^.ComesFrom :=  TO_INT(  THIS.GetContext().OpenCycleCount());

        tData^.CounterDelay :=  THIS.GetContext().OpenCycleCount();

        // tData^.hierarchy.item_member_property_1.item_member_property_2.myULINT :=  tData^.hierarchy.item_member_property_1.item_member_property_1.myULINT;
        // tData^.hierarchy.item_member_property_1.item_member_property_1.myULINT :=  THIS.GetContext().OpenCycleCount();

        // tData^.hierarchy.item_member_property_2.item_member_property_2.myULINT :=  tData^.hierarchy.item_member_property_1.item_member_property_1.myULINT;
        // tData^.hierarchy.item_member_property_2.item_member_property_1.myULINT :=  THIS.GetContext().OpenCycleCount();


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

            components.Cylinder_1.ActivateManualControl();
            components.Cylinder_2.ActivateManualControl();
            components.Cylinder_3.ActivateManualControl();
            components.Cylinder_4.ActivateManualControl();
            components.Cylinder_5.ActivateManualControl();
            components.Cylinder_6.ActivateManualControl();
            components.Cylinder_7.ActivateManualControl();
            components.Cylinder_8.ActivateManualControl();

       END_METHOD
   END_CLASS

END_NAMESPACE
