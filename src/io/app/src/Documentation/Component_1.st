USING AXOpen.Core;
{S7.extern=ReadWrite}
CLASS Component_1 EXTENDS AXOpen.Core.AxoObject
    //<InitializationArgumentsDeclaration>
    VAR PUBLIC        
        {#ix-set:AttributeName = "<#Activate manual control#>"}
        ActivateManualControl : BOOL;         
        {#ix-set:AttributeName = "<#Hardware ID#>"}
        _hwID : UINT;
        _geoAddr_HardwareType   :	UINT;
        _geoAddr_AreaID         :	UINT;
        _geoAddr_IOSystem       :	UINT;
        _geoAddr_Station        :	UINT;
        _geoAddr_Slot           :	UINT;
        _geoAddr_Subslot        :	UINT;
    END_VAR
    //</InitializationArgumentsDeclaration>       
    
    //<ComponentDeclaration>
    VAR PUBLIC                
        ExampleComponent : AXOpen.Io.AxoIoComponent;      
    END_VAR
    //</ComponentDeclaration>                          

    VAR PRIVATE
        _retval                 :   WORD;
        _geoAddr                :   Siemens.Simatic.Hardware.Utilities.GeoAddr;
    END_VAR

    METHOD PUBLIC OVERRIDE Run
        VAR_INPUT
            inParent : IAxoObject;
        END_VAR     

        SUPER.Run(inParent);
        
        IF ActivateManualControl THEN
            ExampleComponent.ActivateManualControl();
        END_IF;

        //<Initialization>        
        ExampleComponent.Run(THIS, _hwID);        
        //</Initialization>

        _retval := Siemens.Simatic.Hardware.Utilities.ReadSlotFromHardwareID(hardwareID := _hwID, geoAddr :=_geoAddr);   

        _geoAddr_HardwareType   :=          _geoAddr.HardwareType;
        _geoAddr_AreaID         :=          _geoAddr.AreaID;
        _geoAddr_IOSystem       :=          _geoAddr.IOSystem;
        _geoAddr_Station        :=          _geoAddr.Station;
        _geoAddr_Slot           :=          _geoAddr.Slot;
        _geoAddr_Subslot        :=          _geoAddr.Subslot;

        RETURN;
       THIS.UseInSequencer();
    END_METHOD

    //<Usage>    
    VAR PUBLIC                       
        Sequencer : AxoSequencer;       
        Steps : ARRAY[0..3] OF AXOpen.Core.AxoStep;
    END_VAR

    METHOD PRIVATE UseInSequencer   

        Sequencer.Run(THIS);
        Sequencer.Open();

        IF(Steps[0].Execute(Sequencer, 'Update diagnostic task')) THEN
            IF(ExampleComponent.HardwareDiagnosticsTask.Invoke().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;
      
    END_METHOD
    
    //</Usage>
END_CLASS
