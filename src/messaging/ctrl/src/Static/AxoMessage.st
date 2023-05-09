USING AXOpen.Core;
USING AXOpen.Core;
NAMESPACE AXOpen.Messaging.Static    
    {#ix-prop: public string MessageText }
    {#ix-prop: public string Help }
    CLASS AxoMessage        
        VAR PUBLIC
            Active : BOOL;
            Pinned : BOOL;
            Risen : LDATE_AND_TIME;
            Fallen : LDATE_AND_TIME;
            Acknowledged : LDATE_AND_TIME;
            Category : eAxoMessageCategory;            
            ActiveContextCount : ULINT;
            Context : IAxoContext;
            MessageCode : ULINT;
        END_VAR
        
/*

        {#ix-set: MessageText = "Servo error: [#MessageCode2#}"}
        message : AxoMessage;


        CLASS AxoMessageExt EXTENDS AxoMessage
            VAR PUBLIC
                MessageCode2 : ULINT;
            END_VAR    
        END_CLASS    

        //"Hello I am message"
        message.Post(//"{1}Hello I am message");

*/

        METHOD Serve 
            VAR_INPUT
                Contex : IAxoContext;
            END_VAR               
            THIS.Context := Contex;
            Active := Context.OpenCycleCount() = ActiveContextCount;
        END_METHOD

        METHOD Activate
            VAR_INPUT
                _category : eAxoMessageCategory;
            END_VAR    
            ActiveContextCount := Context.OpenCycleCount();
            Category := _category;
        END_METHOD    

    END_CLASS

END_NAMESPACE