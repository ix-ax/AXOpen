USING AXOpen.Core;
{S7.extern=ReadWrite}
CLASS DocumentationContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _rootObject  : AxoObject;
        componentOne : Component_1;
        componentTwo : Component_2;
        componentThree : Component_3;
        componentFour : Component_4;
        componentFive : Component_5;
    END_VAR
   
    METHOD PROTECTED OVERRIDE Main
        VAR_EXTERNAL        
            Inputs : AXOpen.Io.Inputs;
            Outputs : AXOpen.Io.Outputs;          
        END_VAR             
        VAR 
            _tmpBool : BOOL;
        END_VAR
        
        THIS.InitializeRootObject(_rootObject);
        componentOne.Run(_rootObject);
        componentTwo.Run(_rootObject);
        componentThree.Run(_rootObject);
        componentFour.Run(_rootObject);
        componentFive.Run(_rootObject);

        //  Example of BNI0099 connected to port X04, 
        //  accessing digital input connected to the port 7 of the BNI0099
        _tmpBool := Inputs.bni00l3_BALLUFF_Link_module_X04_Input.Signals_0[0].%X7;

        //  Example of an extended BNI0099 with an additional one connected to port X02, 
        //  accessing digital input connected to the port 5 of the first BNI0099 in the chain
        _tmpBool := Inputs.bni00l3_BALLUFF_Link_module_X02_Input.Signals_0[0].%X5;
        
        //  Example of an extended BNI0099 with an additional one connected to port X02, 
        //  accessing digital input connected to the port 3 of the second BNI0099 in the chain
        _tmpBool := Inputs.bni00l3_BALLUFF_Link_module_X02_Input.Signals_0[1].%X3;
        
        //  Example of BNI00AY connected to port X03,
        //  accessing digital input connected to the port 6 of the BNI00AY
        _tmpBool := Inputs.bni00l3_BALLUFF_Link_module_X03_Input.Signals_0[0].%X6;
        
        //  Example of BNI00AY connected to port X03,
        //  accessing digital input connected to the port 15 of the BNI00AY
        _tmpBool := Inputs.bni00l3_BALLUFF_Link_module_X03_Input.Signals_0[1].%X7;

        //  Example of an extended BNI00AY with an additional one connected to port X01, 
        //  accessing digital input connected to the port 0 of the first BNI00AY in the chain
        _tmpBool := Inputs.bni00l3_BALLUFF_Link_module_X01_Input.Signals_0[0].%X0;

        //  Example of an extended BNI00AY with an additional one connected to port X01, 
        //  accessing digital input connected to the port 14 of the first BNI00AY in the chain
        _tmpBool := Inputs.bni00l3_BALLUFF_Link_module_X01_Input.Signals_0[1].%X6;

        //  Example of an extended BNI00AY with an additional one connected to port X01, 
        //  accessing digital input connected to the port 2 of the second BNI00AY in the chain
        _tmpBool := Inputs.bni00l3_BALLUFF_Link_module_X01_Input.Signals_0[2].%X2;

        //  Example of an extended BNI00AY with an additional one connected to port X01, 
        //  accessing digital input connected to the port 11 of the second BNI00AY in the chain
        _tmpBool := Inputs.bni00l3_BALLUFF_Link_module_X01_Input.Signals_0[3].%X3;

    END_METHOD
END_CLASS
