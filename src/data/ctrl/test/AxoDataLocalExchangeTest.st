USING AXOpen.Messaging.Static;
USING AXOpen.Core;
USING AXOpen.Core.Dummies;
USING AXOpen.Data;



NAMESPACE AXOpen.Data      
    CLASS _DataStorage_template EXTENDS AxoDataLocalExchange    
        VAR CONSTANT
            LOWBOUND : DINT := 0;
            HIGHBOUND : DINT := 10;
        END_VAR    
        VAR PUBLIC  
            Payload : _EntityTemplate_;           
            Storage : ARRAY[LOWBOUND..HIGHBOUND] OF _EntityTemplate_;                          
        END_VAR        
           
        METHOD PUBLIC OVERRIDE Create : IAxoTaskState
            VAR_INPUT
                inIdentifier : STRING[254];
            END_VAR            
            VAR               
                tmpSlot : DINT;
             END_VAR    
           
            dataExchangeTask.Status := eAxoTaskState#Busy;        
            operation := eCrudOperation#Create;                                               
                     
            tmpSlot :=THIS.GetFreeSlot(); 
            IF(tmpSlot >= 0) THEN 
                Payload.DataEntityId :=  inIdentifier;      
                Storage[tmpSlot] :=  Payload;                                      
                dataExchangeTask.Status := eAxoTaskState#Done;
            ELSE
                dataExchangeTask.Status := eAxoTaskState#Error;
            END_IF;                             
            
            Create := dataExchangeTask;
        END_METHOD 

        METHOD PUBLIC OVERRIDE Read : IAxoTaskState
            VAR_INPUT
                inIdentifier : STRING[254];
            END_VAR            
            VAR
                tmpStorage : REF_TO ARRAY[*] OF IAxoDataEntity;
                tmpEntity : IAxoDataEntity;
                tmpSlot : DINT;
             END_VAR    
           
            dataExchangeTask.Status := eAxoTaskState#Busy;        
            operation := eCrudOperation#Read;                                              
            tmpSlot := THIS.LocateSlot(inIdentifier);
            IF(tmpSlot >= LOWBOUND && tmpSlot <= HIGHBOUND) THEN                                      
                Payload := Storage[tmpSlot];
                dataExchangeTask.Status := eAxoTaskState#Done;
            ELSE
                dataExchangeTask.Status := eAxoTaskState#Error;
            END_IF;                             
            
            Read := dataExchangeTask;
        END_METHOD 

        METHOD PUBLIC OVERRIDE Update : IAxoTaskState
            VAR_INPUT
                inIdentifier : STRING[254];
            END_VAR        
            VAR
                tmpSlot : DINT;
            END_VAR    
            dataExchangeTask.Status := eAxoTaskState#Busy;        
            operation := eCrudOperation#Update;                                              
          
            tmpSlot := THIS.LocateSlot(inIdentifier);
            IF(tmpSlot >= LOWBOUND && tmpSlot <= HIGHBOUND) THEN                           
                Payload := Storage[tmpSlot];
                dataExchangeTask.Status := eAxoTaskState#Done;
            ELSE
                dataExchangeTask.Status := eAxoTaskState#Error;
            END_IF;                             
            
            Update := dataExchangeTask;
        END_METHOD 

        METHOD PUBLIC OVERRIDE Delete : IAxoTaskState
            VAR_INPUT
                inIdentifier : STRING[254];
            END_VAR
           
            dataExchangeTask.Status := eAxoTaskState#Busy;        
            operation := eCrudOperation#Delete;
            
            Storage[THIS.LocateSlot(inIdentifier)].DataEntityId := '';            
            dataExchangeTask.Status := eAxoTaskState#Done;
            Delete := dataExchangeTask;        
        END_METHOD 

        METHOD PUBLIC OVERRIDE EntityExist : IAxoEntityExistTaskState
            VAR_INPUT
                inIdentifier : STRING[254];
            END_VAR        
            ; 
        END_METHOD 

        METHOD PUBLIC OVERRIDE CreateOrUpdate : IAxoTaskState
            VAR_INPUT
                inIdentifier : STRING[254];
            END_VAR                   
            dataExchangeTask.Status := eAxoTaskState#Done;
            CreateOrUpdate := dataExchangeTask;     
        END_METHOD 

        METHOD PUBLIC OVERRIDE Restore        
            ;
        END_METHOD 

        METHOD PRIVATE GetFreeSlot : DINT          
            VAR
                i : DINT;                
                s : IAxoDataEntity;                
            END_VAR 
            GetFreeSlot := -1;               
            FOR i := LOWBOUND TO HIGHBOUND DO                                  
                IF(Storage[i].DataEntityId = '') THEN
                     GetFreeSlot := i;
                     RETURN;
                END_IF;                
            END_FOR;            
        END_METHOD

        METHOD PRIVATE LocateSlot : DINT
            VAR_INPUT
                inIdentifier : STRING[254];
            END_VAR               
            VAR
                i : DINT;
                s : IAxoDataEntity;                
            END_VAR 
            LocateSlot := -1;   
            FOR i := LOWBOUND TO HIGHBOUND DO                                  
                IF(Storage[i].DataEntityId = inIdentifier) THEN
                    LocateSlot := i;
                     RETURN;
                END_IF;                
            END_FOR;       
        END_METHOD                  
    END_CLASS

    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoDataLocalExchangeTests       
        VAR
            context : Context;
            rootObject : MockAxoObject;         
            storageController : _DataStorage_template;                           
            s : ARRAY[0..10] OF _EntityTemplate_;       
            rtm : MockAxoRtm;
            rtc : MockAxoRtc;
        END_VAR    

        {FixtureSetup}
        METHOD PUBLIC TestFixtureSetup
            VAR
                index : INT;
            END_VAR    
            context.InitializeRootObject(rootObject);
            context.InjectRtc(rtc);
            context.InjectRtm(rtm);                                
        END_METHOD

        {Test}
        METHOD PUBLIC create_new_entity_with_identifier 
            VAR
                index : INT;
            END_VAR    
                       
            storageController.Payload.DataEntityId := 'NON-ID';
            storageController.Payload._hello := 'HEY';
            storageController.Payload._someNumber := 1;                                                     
            storageController.Create('ID');
                                           
            
            storageController.Payload.DataEntityId := 'NON-ID';
            storageController.Payload._hello := 'HEY-2';
            storageController.Payload._someNumber := 2;                                                     
            storageController.Create('ID-2');

            storageController.Read('ID');

            AxUnit.Assert.Equal(storageController.Payload._hello = 'HEY' , TRUE);
            AxUnit.Assert.Equal(storageController.Payload.DataEntityId = 'ID' , TRUE);
            AxUnit.Assert.Equal(storageController.Payload._someNumber , 1);
        END_METHOD   
        
        
        {Test}
        METHOD PUBLIC read_new_entity_with_identifier 
            VAR
                index : INT;
            END_VAR    
                       
            storageController.Payload.DataEntityId := 'NON-ID';
            storageController.Payload._hello := 'HEY';
            storageController.Payload._someNumber := 1;                                                     
            storageController.Create('ID');
                                           
            
            storageController.Payload.DataEntityId := 'NON-ID';
            storageController.Payload._hello := 'TO_BE_READ';
            storageController.Payload._someNumber := 2;                                                     
            storageController.Create('READ-ID');

            storageController.Read('READ-ID');

            AxUnit.Assert.Equal(storageController.Payload._hello = 'TO_BE_READ' , TRUE);
            AxUnit.Assert.Equal(storageController.Payload.DataEntityId = 'READ-ID' , TRUE);
            AxUnit.Assert.Equal(storageController.Payload._someNumber , 2);
        END_METHOD

        {Test}
        METHOD PUBLIC delet_entity_with_identifier 
            VAR
                index : INT;
            END_VAR    
                       
            storageController.Payload.DataEntityId := 'NON-ID';
            storageController.Payload._hello := 'HEY';
            storageController.Payload._someNumber := 1;                                                     
            storageController.Create('ID');
                                           
            
            storageController.Payload.DataEntityId := 'NON-ID';
            storageController.Payload._hello := 'TO_BE_READ';
            storageController.Payload._someNumber := 2;                                                     
            storageController.Create('DELETE-ID');

            storageController.Delete('DELETE-ID');

            storageController.Read('DELETE-ID');

            AxUnit.Assert.Equal(storageController.Payload._hello = '' , TRUE);
            AxUnit.Assert.Equal(storageController.Payload.DataEntityId = '' , TRUE);
            AxUnit.Assert.Equal(storageController.Payload._someNumber , 0);
        END_METHOD
    END_CLASS

    CLASS _EntityTemplate_ EXTENDS AxoDataEntity
        VAR PUBLIC
            _hello : STRING;
            _someNumber : INT;
        END_VAR        
    END_CLASS
    CLASS Context EXTENDS MockAxoContext
        VAR
            
        END_VAR
        METHOD OVERRIDE Main 
            ;
        END_METHOD
    END_CLASS
END_NAMESPACE    