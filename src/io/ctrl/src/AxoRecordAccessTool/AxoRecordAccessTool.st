USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING Siemens.Simatic.Diagnostics.Hardware;
USING Siemens.Simatic.DistributedIO;

NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    CLASS AxoRecordAccessTool EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Records")]}
            {#ix-set:AttributeName = "<#Hardware ID#>"}
            hardwareID	                :   UINT;	                
            {#ix-attr:[ComponentDetails("Records")]}
            {#ix-set:AttributeName = "<#Index#>"}
            index	                :   DINT;	                
            {#ix-attr:[ComponentDetails("Records")]}
            {#ix-set:AttributeName = "<#Length#>"}
            length	                :   UINT;	                
            {#ix-attr:[ComponentDetails("Records")]}
            {#ix-set:AttributeName = "<#Status#>"}
            status	                :   DWORD;	                
            {#ix-attr:[ComponentDetails("Records")]}
            {#ix-set:AttributeName = "<#Data#>"}
            Data	                :   AxoRecordAccessData;	                
            {#ix-attr:[ComponentDetails("Records")]}
            {#ix-set:AttributeName = "<#Read record#>"}
            ReadRecordTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Records")]}
            {#ix-set:AttributeName = "<#Write record#>"}
            WriteRecordTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Records")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
        END_VAR

        VAR PRIVATE
            _writeRecord : WriteRecord;
            _readRecord : ReadRecord;
            _data : ARRAY[0..1] OF BYTE;
        END_VAR

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent    :   IAxoObject;
            END_VAR
            IF (inParent = NULL) THEN 
                RETURN; 
            END_IF;
            SUPER.Run(inParent);    

            RestoreTask.Run(THIS);
            ReadRecordTask.Run(THIS);
            WriteRecordTask.Run(THIS);

            IF RestoreTask.Execute() THEN
                THIS.Restore();
            END_IF;

            ReadRecordTask.SetIsDisabled(WriteRecordTask.IsBusy());
            IF ReadRecordTask.Execute() THEN
                _readRecord(TRUE, hardwareID, index , UINT#255 , Data.Data);
                IF _readRecord.valid THEN
                    Data.ToggleDataChangedFlag();
                    ReadRecordTask.DoneWhen(TRUE);
                END_IF;
                ReadRecordTask.ThrowWhen(_readRecord.error);
                length := _readRecord.length;
                status := _readRecord.status;
            ELSE
                _readRecord(FALSE, hardwareID, index , length , _data);
            END_IF;
            IF ReadRecordTask.RestoreTriggered() THEN
                status := DWORD#0;
            END_IF;

            WriteRecordTask.SetIsDisabled(ReadRecordTask.IsBusy());
            IF WriteRecordTask.Execute() THEN
                _writeRecord(TRUE, hardwareID, index , length , Data.Data);
                WriteRecordTask.DoneWhen(_writeRecord.done);
                WriteRecordTask.ThrowWhen(_writeRecord.error);
                status := _writeRecord.status;
            ELSE
                _writeRecord(FALSE, hardwareID, index , length , _data);
            END_IF;
            IF WriteRecordTask.RestoreTriggered() THEN
                status := DWORD#0;
            END_IF;

        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            THIS._isManuallyControllable := true;
        END_METHOD
        
        ///<summary>
        /// Restores this component into intial state.        
        ///</summary>
        METHOD PUBLIC OVERRIDE Restore
            status := DWORD#0;
            ReadRecordTask.Restore();
            WriteRecordTask.Restore();
            RestoreTask.DoneWhen(TRUE);
        END_METHOD        
    END_CLASS
END_NAMESPACE
