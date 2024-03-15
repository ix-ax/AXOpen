USING AXOpen.Components.Abstractions.Drives;
USING AXOpen.Timers;
USING Siemens.Simatic.S71500.DistributedIO;
USING System.Timer;
USING System.Strings;
USING System.Serialization;

NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoIOLink_RF200 
        VAR PRIVATE 
            instDevice                  :	AxoIOLink_Device;                       //  Acyclically reads or writes data records from and to IO-Link devices
            statRecordParam_index       :   ARRAY[0..HIGHEST_REQUEST_NUMBER] OF INT :=  [0,INDEX_DIRECT_PARAM1,0,0,0,0,0,0,0,INDEX_EVENT_HISTORY,INDEX_VENDOR_NAME,INDEX_VENDOR_TEXT,INDEX_PRODUCT_NAME,INDEX_PRODUCT_ID,20,21,22,INDEX_FIRMWARE_REVISION,INDEX_APP_SPECIFIC_NAME,INDEX_ERROR_COUNT,0,0,INDEX_TAG_STATUS,INDEX_READER_STATUS,INDEX_UID_HISTORY,0,0,0,0];  //  Data set index
            statRecordParam_subindex    :	ARRAY[0..HIGHEST_REQUEST_NUMBER] OF INT :=  [29(0)];    //  Data set subindex
            statRecordParam_length      :	ARRAY[0..HIGHEST_REQUEST_NUMBER] OF INT :=  [0,LENGTH_DIRECT_PARAM1,0,0,0,0,0,0,0,LENGTH_EVENT_HISTORY,LENGTH_VENDOR_NAME,LENGTH_VENDOR_TEXT,LENGTH_PRODUCT_NAME,LENGTH_PRODUCT_ID,0,0,0,LENGTH_FIRMWARE_REVISION,LENGTH_APP_SPECIFIC_NAME,LENGTH_ERROR_COUNT,0,0,LENGTH_TAG_STATUS,LENGTH_READER_STATUS,LENGTH_UID_HISTORY,0,0,0,0]; //  Data set length
            statRecord                  :	ARRAY[0..UPPER_BOUND_RECORD] OF BYTE;   //  Record buffer
            statIndex                   :	INT     :=  INT#0;                      //	Requested index
            statSubindex                :	INT     :=  INT#0;                      //	Requested subindex
            statRecordLen               :	INT     :=  INT#0;                      //	Length of record to be written
            statHwID                    :	WORD    :=  WORD#0;                     //  Static value for input 'hwID'
            statCap                     :	INT     :=  INT#0;                      //  Static value for input 'cap'
            statReadWrite               :	BOOL    :=  FALSE;                      //  Static value for input 'readWrite'
            statPort                    :	INT     :=  INT#0;                      //  Static value for input 'port'
            statPollingPeriod           :	Time	:=  T#0ms;                      //  Static value for input 'pollingPeriod'
            statDirectParameter1        :	BOOL    :=  FALSE;                      //  Static value for input 'directParameter1'
            statSystemCommand           :	BOOL    :=  FALSE;                      //  Static value for input 'systemCommands'
            statDeviceAccessLocks       :	BOOL    :=  FALSE;                      //  Static value for input 'deviceAccessLocks'
            statVendorName              :	BOOL    :=  FALSE;                      //  Static value for input 'vendorName'
            statVendorText              :	BOOL    :=  FALSE;                      //  Static value for input 'vendorText'
            statProductName             :	BOOL    :=  FALSE;                      //  Static value for input 'productName'
            statProductID               :	BOOL    :=  FALSE;                      //  Static value for input 'productID'
            statProductText             :	BOOL    :=  FALSE;                      //  Static value for input 'productText'
            statSerialNumber            :	BOOL    :=  FALSE;                      //  Static value for input 'serialNumber'
            statHwRevision              :	BOOL    :=  FALSE;                      //  Static value for input 'hwRevision'
            statFwRevision              :	BOOL    :=  FALSE;                      //  Static value for input 'fwRevision'
            statAppSpecificName         :	BOOL    :=  FALSE;                      //  Static value for input 'appSpecificName'
            statErrorCount              :	BOOL    :=  FALSE;                      //  Static value for input 'errorCount'
            statDeviceStatus            :	BOOL    :=  FALSE;                      //  Static value for input 'deviceStatus'
            statDeviceStatusDetailed    :	BOOL    :=  FALSE;                      //  Static value for input 'deviceStatusDetailed'
            statProcessIn               :	BOOL    :=  FALSE;                      //  Static value for input 'processIn'
            statProcessOut              :	BOOL    :=  FALSE;                      //  Static value for input 'processOut'
            statParameters              :	BOOL    :=  FALSE;                      //  Static value for input 'parameters'
            statEventHistory            :	BOOL    :=  FALSE;                      //  Static value for input 'eventHistory'
            statReaderStatus            :	BOOL    :=  FALSE;                      //  Static value for input 'readerStatus'
            statTagStatus               :	BOOL    :=  FALSE;                      //  Static value for input 'tagStatus'
            statUidHistory              :	BOOL    :=  FALSE;                      //  Static value for input 'uidHistory'
            statRequest                 :	INT     :=  INT#0;                      //  Case of request (data set)
            statDoneOld                 :	BOOL    :=  FALSE;                      //  Last cycle's value of instDevice.done
            instDevice_done             :	BOOL    :=  FALSE;    
            instDevice_busy             :	BOOL    :=  FALSE;  
            instDevice_error            :	BOOL    :=  FALSE;  
            instDevice_status           :	WORD    :=  WORD#0;  
            instDevice_readLen          :	INT     :=  INT#0;  
            instDevice_diagnostics      :   AxoIOLink_typeDiagnostics;
        END_VAR

        VAR CONSTANT 
            UPPER_BOUND_RECORD              :	INT     :=  INT#231;        //				        Upper Bound of record buffer
            HIGHEST_REQUEST_NUMBER          :	INT     :=  INT#28;         //				        Highest available request number
            UPPER_BOUND_PARAMETER_PAGE0     :	INT     :=  INT#15;         //				        Upper Bound of Parameter Page 0 auxiliary field
            UPPER_BOUND_PARAMETERS          :	INT     :=  INT#7;          //				        Upper Bound of Parameters auxiliary field
            UPPER_BOUND_EVENT_HISTORY       :	INT     :=  INT#19;         //				        Upper Bound of Event History auxiliary field
            UPPER_BOUND_READER_STATUS       :	INT     :=  INT#17;         //				        Upper Bound of Reader Status auxiliary field
            UPPER_BOUND_TAG_STATUS          :	INT     :=  INT#15;         //				        Upper Bound of Tag Status auxiliary field
            UPPER_BOUND_UID_HISTORY         :	INT     :=  INT#39;         //				        Upper Bound of UID History auxiliary field
            MODE_READ                       :	BOOL    :=	FALSE;          //						Mode to read data
            MODE_WRITE                      :	BOOL    :=	TRUE;           //						Mode to write data
            STATUS_IDLE                     :	WORD    :=  WORD#16#7000;   //						Status: Idle
            STATUS_EXECUTION_FINISHED       :	WORD    :=  WORD#16#0000;   //						Execution finished without errors
            ERR_INCONSISTENT_DATA           :	WORD    :=  WORD#16#8402;   //						Error: Read data record doesn't match request
            INDEX_DIRECT_PARAM1             :	INT     :=  INT#0;          //						Record Index
            INDEX_SYSTEM_COMMAND            :	INT     :=  INT#2;          //						Record Index
            INDEX_ACCESS_LOCKS              :	INT     :=  INT#12;         //						Record Index
            INDEX_EVENT_HISTORY             :	INT     :=  INT#74;         //						Record Index
            INDEX_VENDOR_NAME               :	INT     :=  INT#16;         //						Record Index
            INDEX_VENDOR_TEXT               :	INT     :=  INT#17;         //						Record Index
            INDEX_PRODUCT_NAME              :	INT     :=  INT#18;         //						Record Index
            INDEX_PRODUCT_ID                :	INT     :=  INT#19;         //						Record Index
            INDEX_PRODUCT_TEXT              :	INT     :=  INT#20;         //						Record Index
            INDEX_SERIAL_NUMBER             :	INT     :=  INT#21;         //						Record Index
            INDEX_HARDWARE_REVISION         :	INT     :=  INT#22;         //						Record Index
            INDEX_FIRMWARE_REVISION         :	INT     :=  INT#23;         //						Record Index
            INDEX_APP_SPECIFIC_NAME         :	INT     :=  INT#24;         //						Record Index
            INDEX_ERROR_COUNT               :	INT     :=  INT#32;         //						Record Index
            INDEX_DEVICE_STATUS             :	INT     :=  INT#36;         //						Record Index
            INDEX_DETAILED_STATUS           :	INT     :=  INT#37;         //						Record Index
            INDEX_PII                       :	INT     :=  INT#40;         //						Record Index
            INDEX_PIQ                       :	INT     :=  INT#41;         //						Record Index
            INDEX_PARAMETERS                :	INT     :=  INT#64;         //						Record Index
            INDEX_TAG_STATUS                :	INT     :=  INT#91;         //						Record Index
            INDEX_READER_STATUS             :	INT     :=  INT#90;         //						Record Index
            INDEX_UID_HISTORY               :	INT     :=  INT#92;         //						Record Index
            LENGTH_DIRECT_PARAM1            :	INT     :=  INT#16;         //						Record Length
            LENGTH_SYSTEM_COMMAND           :	INT     :=  INT#1;          //						Record Length
            LENGTH_ACCESS_LOCKS             :	INT     :=  INT#2;          //						Record Length
            LENGTH_EVENT_HISTORY            :	INT     :=  INT#20;         //						Record Length
            LENGTH_VENDOR_NAME              :	INT     :=  INT#12;         //						Record Length
            LENGTH_VENDOR_TEXT              :	INT     :=  INT#12;         //						Record Length
            LENGTH_PRODUCT_NAME             :	INT     :=  INT#24;         //						Record Length
            LENGTH_PRODUCT_ID               :	INT     :=  INT#16;         //						Record Length
            LENGTH_PRODUCT_TEXT             :	INT     :=  INT#64;         //						Record Length
            LENGTH_SERIAL_NUMBER            :	INT     :=  INT#12;         //						Record Length
            LENGTH_HARDWARE_REVISION        :	INT     :=  INT#12;         //						Record Length
            LENGTH_FIRMWARE_REVISION        :	INT     :=  INT#12;         //						Record Length
            LENGTH_APP_SPECIFIC_NAME        :	INT     :=  INT#32;         //						Record Length
            LENGTH_ERROR_COUNT              :	INT     :=  INT#2;          //						Record Length
            LENGTH_DEVICE_STATUS            :	INT     :=  INT#1;          //						Record Length
            LENGTH_DETAILED_STATUS          :	INT     :=  INT#1;          //						Record Length
            LENGTH_PII                      :	INT     :=  INT#8;          //						Record Length
            LENGTH_PIQ                      :	INT     :=  INT#8;          //						Record Length
            LENGTH_PARAMETERS               :	INT     :=  INT#8;          //						Record Length
            LENGTH_TAG_STATUS               :	INT     :=  INT#15;         //						Record Length
            LENGTH_READER_STATUS            :	INT     :=  INT#18;         //						Record Length
            LENGTH_UID_HISTORY              :	INT     :=  INT#40;         //						Record Length
            EMPTY_CHAR                      :	CHAR    :=  CHAR#'$00';     //						Default empty chat to fill empty field entries
            DEVICE_TIMEOUT                  :	TIME    :=	T#20S;          //						Timeout value for the IO-Link Device Instance
        
        END_VAR

        METHOD PUBLIC Run
            VAR_INPUT
                execute                 :	BOOL    :=  FALSE;                  //  Request job (on rising edge)
                hwID                    :	WORD    :=  WORD#0;                 //  Hardware identifier of IO-Link master module or first sub module
                cap                     :	INT     :=  INT#0;                  //  Client Access Point (CAP) 0xB400 or 0x00E3 (227)
                readWrite               :	BOOL    :=  FALSE;                  //  Read and write access to IO-Link device 0: Read, 1:Write
                port                    :	INT     :=  INT#0;                  //  Port of device on the IO-Link Master
                pollingPeriod           :	TIME    :=  T#100MS;                //	Time period of polling
                directParameter1        :	BOOL    :=  FALSE;                  //  Read parameter page 1
                systemCommand           :	BOOL    :=  FALSE;                  //  Read system commands
                deviceAccessLocks       :	BOOL    :=  FALSE;                  //  Read device access locks
                vendorName              :	BOOL    :=  FALSE;                  //  Read manufacturer name
                vendorText              :	BOOL    :=  FALSE;                  //  Read manufacturer text
                productName             :	BOOL    :=  FALSE;                  //  Read product name
                productID               :	BOOL    :=  FALSE;                  //  Read product ID
                productText             :	BOOL    :=  FALSE;                  //  Read product text
                serialNumber            :	BOOL    :=  FALSE;                  //  Read serial number
                hwRevision              :	BOOL    :=  FALSE;                  //  Read hardware revision
                fwRevision              :	BOOL    :=  FALSE;                  //  Read firmware revision
                appSpecificName         :	BOOL    :=  FALSE;                  //  Read/Write application specific name
                errorCount              :	BOOL    :=  FALSE;                  //  Read error count
                deviceStatus            :	BOOL    :=  FALSE;                  //  Read device status
                deviceStatusDetailed    :	BOOL    :=  FALSE;                  //  Read device status detailed
                processIn               :	BOOL    :=  FALSE;                  //  Read process data IN
                processOut              :	BOOL    :=  FALSE;                  //  Read process data OUT
                parameters              :	BOOL    :=  FALSE;                  //  Read parameters
                eventHistory            :	BOOL    :=  FALSE;                  //  Read event history
                readerStatus            :	BOOL    :=  FALSE;                  //  Read status of reader
                tagStatus               :	BOOL    :=  FALSE;                  //  Reag tag status
                uidHistory              :	BOOL    :=  FALSE;                  //  Read UID history
                diagnostics	            :   REF_TO  AxoIOLink_typeDiagnostics;  //  IO-Link error status
                data                    :   REF_TO	AxoIOLink_RF200_typeAll;    //  Device data buffer

            END_VAR         

            VAR_OUTPUT          
                done    :	BOOL;       //  FALSE: data invalid, TRUE: data valid
                busy    :	BOOL;       //  FALSE: job done, TRUE: job in progress
                error   :	BOOL;       //  FALSE: no error, TRUE: error
                status  :	WORD;       //  DP/PN IO error status

            END_VAR

            VAR_TEMP 
                tempIndex                   :	UINT;								            //  Loop index
                tempLen                     :	UINT;								            //  Auxiliary tag Length
                tempRetValSerialize         :	INT;								            //  Auxiliary tag for Serialize RetVal
                tempRetValDeserialize       :	INT;								            //  Auxiliary tag for Deserialize RetVal
                tempPosSerialize            :	DINT;								            //  Auxiliary tag for Serialize POS
                tempPosDeserialize          :	DINT;								            //  Auxiliary tag for Deserialize POS Output
                tempFieldParameterPage0     :	ARRAY[0..UPPER_BOUND_PARAMETER_PAGE0] OF BYTE;  //	Auxiliary tag for Parameter Page 0 record conversion
                tempFieldParameters         :	ARRAY[0..UPPER_BOUND_PARAMETERS] OF BYTE;       //	Auxiliary tag for Parameters record conversion
                tempFieldEventHistory       :	ARRAY[0..UPPER_BOUND_EVENT_HISTORY] OF BYTE;    //	Auxiliary tag for EventHistory record conversion
                tempFieldReaderStatus       :	ARRAY[0..UPPER_BOUND_READER_STATUS] OF BYTE;    //	Auxiliary tag for Reader Status record conversion
                tempFieldTagStatus          :	ARRAY[0..UPPER_BOUND_TAG_STATUS] OF BYTE;       //	Auxiliary tag for Tag Status record conversion
                tempFieldUIDHistory         :	ARRAY[0..UPPER_BOUND_UID_HISTORY] OF BYTE;      //	Auxiliary tag for UID History record conversion
                tempInternalError           :	BOOL;                                           //  Auxiliary tag to collect serialize and Deserialize issues
                tempData256                 :   ARRAY[0..255] OF BYTE;
            END_VAR

            
            IF data = NULL THEN
                // TODO some message
                RETURN;
            END_IF;
            
            IF diagnostics = NULL THEN
                // TODO some message
                RETURN;
            END_IF;

            // INFO HEADER
            //===============================================================================
            // Siemens / (c)Copyright 2023
            //-------------------------------------------------------------------------------
            // Title:            LIOLink_RF200
            // Function:         Capsule block to communicate with SIMATIC RF200 Readers
            // Library:          LIOLink
            // Author:           Siemens Industry Online Support
            // Tested with:      CPU 1513-1 PN FW 2.8
            // Engineering:      TIA Portal V16
            // Restrictions:     --
            // Requirements:     --
            //-------------------------------------------------------------------------------
            // Change log table:
            // Version  | Date       | Expert in charge       | Changes applied
            //----------|------------|------------------------|------------------------------
            // 01.00.00 | 11.04.2014 | Online Support         | First release
            // 02.00.00 | 30.03.2015 | Online Support         | Upgrade to TIA Portal V13 SP1, use function IO_LINK_DEVICE, only one function for S7-1200 and 1500
            // 02.01.00 | 23.10.2015 | Online Support         | Update to IO_LINK_DEVICE Version 3.1
            // 03.00.00 | 01.09.2020 | Online Support         | Rewrote block for FB "LIOLink_Device" V4.0.0
            // 03.01.00 | 25.10.2022 | SUP SPH                | Optimized and function extension
            //===============================================================================
        
            // INIT
            IF (execute = TRUE AND instDevice_status = STATUS_IDLE) THEN
                
                // Inputs
                    //save inputs
                    statHwID := hwID;
                    statCap := cap;
                    statReadWrite := readWrite;
                    statPort := port;
                    statPollingPeriod := pollingPeriod;
                    statDirectParameter1 := directParameter1;
                    statSystemCommand := systemCommand;
                    statDeviceAccessLocks := deviceAccessLocks;
                    statVendorName := vendorName;
                    statVendorText := vendorText;
                    statProductName := productName;
                    statProductID := productID;
                    statProductText := productText;
                    statSerialNumber := serialNumber;
                    statHwRevision := hwRevision;
                    statFwRevision := fwRevision;
                    statAppSpecificName := appSpecificName;
                    statErrorCount := errorCount;
                    statDeviceStatus := deviceStatus;
                    statDeviceStatusDetailed := deviceStatusDetailed;
                    statProcessIn := processIn;
                    statProcessOut := processOut;
                    statParameters := parameters;
                    statEventHistory := eventHistory;
                    statReaderStatus := readerStatus;
                    statTagStatus := tagStatus;
                    statUidHistory := uidHistory;
                
                // Request selector
                    //set Index and RecordLen based on the request
                    IF statDirectParameter1 THEN
                        statIndex := INDEX_DIRECT_PARAM1;
                        statRecordLen := LENGTH_DIRECT_PARAM1;
                    ELSIF statSystemCommand THEN
                        statIndex := INDEX_SYSTEM_COMMAND;
                        statRecordLen := LENGTH_SYSTEM_COMMAND;
                    ELSIF statDeviceAccessLocks THEN
                        statIndex := INDEX_ACCESS_LOCKS;
                        statRecordLen := LENGTH_ACCESS_LOCKS;
                    ELSIF statVendorName THEN
                        statIndex := INDEX_VENDOR_NAME;
                        statRecordLen := LENGTH_VENDOR_NAME;
                    ELSIF statVendorText THEN
                        statIndex := INDEX_VENDOR_TEXT;
                        statRecordLen := LENGTH_VENDOR_TEXT;
                    ELSIF statProductName THEN
                        statIndex := INDEX_PRODUCT_NAME;
                        statRecordLen := LENGTH_PRODUCT_NAME;
                    ELSIF statProductID THEN
                        statIndex := INDEX_PRODUCT_ID;
                        statRecordLen := LENGTH_PRODUCT_ID;
                    ELSIF statProductText THEN
                        statIndex := INDEX_PRODUCT_TEXT;
                        statRecordLen := LENGTH_PRODUCT_TEXT;
                    ELSIF statSerialNumber THEN
                        statIndex := INDEX_SERIAL_NUMBER;
                        statRecordLen := LENGTH_SERIAL_NUMBER;
                    ELSIF statHwRevision THEN
                        statIndex := INDEX_HARDWARE_REVISION;
                        statRecordLen := LENGTH_HARDWARE_REVISION;
                    ELSIF statFwRevision THEN
                        statIndex := INDEX_FIRMWARE_REVISION;
                        statRecordLen := LENGTH_FIRMWARE_REVISION;
                    ELSIF statAppSpecificName THEN
                        statIndex := INDEX_APP_SPECIFIC_NAME;
                        statRecordLen := LENGTH_APP_SPECIFIC_NAME;
                    ELSIF statErrorCount THEN
                        statIndex := INDEX_ERROR_COUNT;
                        statRecordLen := LENGTH_ERROR_COUNT;
                    ELSIF statDeviceStatus THEN
                        statIndex := INDEX_DEVICE_STATUS;
                        statRecordLen := LENGTH_DEVICE_STATUS;
                    ELSIF statDeviceStatusDetailed THEN
                        statIndex := INDEX_DETAILED_STATUS;
                        statRecordLen := LENGTH_DETAILED_STATUS;
                    ELSIF statProcessIn THEN
                        statIndex := INDEX_PII;
                        statRecordLen := LENGTH_PII;
                    ELSIF statProcessOut THEN
                        statIndex := INDEX_PIQ;
                        statRecordLen := LENGTH_PIQ;
                    ELSIF statParameters THEN
                        statIndex := INDEX_PARAMETERS;
                        statRecordLen := LENGTH_PARAMETERS;
                    ELSIF statEventHistory THEN
                        statIndex := INDEX_EVENT_HISTORY;
                        statRecordLen := LENGTH_EVENT_HISTORY;
                    ELSIF statReaderStatus THEN
                        statIndex := INDEX_READER_STATUS;
                        statRecordLen := LENGTH_READER_STATUS;
                    ELSIF statTagStatus THEN
                        statIndex := INDEX_TAG_STATUS;
                        statRecordLen := LENGTH_TAG_STATUS;
                    ELSIF statUidHistory THEN
                        statIndex := INDEX_UID_HISTORY;
                        statRecordLen := LENGTH_UID_HISTORY;
                    ELSE
                        RETURN;
                    END_IF;
                
                IF statReadWrite = MODE_WRITE THEN
                    //prepare statRecord in case of a writing request
                    // write
                        IF statSystemCommand THEN
                            statRecord[0] := data^.systemCommand;
                            
                        ELSIF statDeviceAccessLocks THEN
                            statRecord[0] := data^.deviceAccessLocks.%B0;
                            statRecord[1] := data^.deviceAccessLocks.%B1;
                            
                        ELSIF statAppSpecificName THEN
                            tempLen :=  TO_UINT(LengthOf(data^.appSpecificName));
                            Serialize(UINT#0,data^.appSpecificName,tempData256);
                            FOR tempIndex := UINT#0 TO tempLen - UINT#1 DO
                                statRecord[tempIndex] :=   tempData256[tempIndex + UINT#1];
                            END_FOR;
                        ELSIF statParameters THEN
                                      statRecord[0] := data^.parameters.eventMessage;
                                      statRecord[1] := data^.parameters.operatingMode;  
                                      statRecord[2] := data^.parameters.readyDelay;     
                                      statRecord[3] := data^.parameters.dataHoldingTime;
                                      statRecord[4] := data^.parameters.rfParameters;   
                                      statRecord[5] := data^.parameters.modulation;     
                                      statRecord[6] := data^.parameters.subcarrier;     
                                      statRecord[7] := data^.parameters.dataTransfer;   

                            // Fill remaining characters with null
                            FOR tempIndex := UINT#8 TO TO_UINT(statRecordLen - 1) DO
                                statRecord[tempIndex] := TO_BYTE(EMPTY_CHAR);
                            END_FOR;
                        ELSE // all other data sets are read only  
                            ;
                        END_IF;
                        tempInternalError := tempRetValSerialize <> TO_INT(STATUS_EXECUTION_FINISHED);
                END_IF;
            END_IF;
        
            //CALL
            //IOL-Call -> Request to read/write from an IO-Link-Device
            instDevice.Run(execute      := execute,
                        hwID            := statHwID,
                        cap             := statCap,
                        readWrite       := statReadWrite,
                        port            := statPort,
                        pollingPeriod   := statPollingPeriod,
                        index           := statIndex,
                        subindex        := statSubindex,
                        writeLen        := statRecordLen,
                        timeout         := DEVICE_TIMEOUT,
                        record          := REF(statRecord),
                        diagnostics     :=  REF(instDevice_diagnostics),
                        done            =>  instDevice_done    ,
                        busy            =>  instDevice_busy    ,
                        error           =>  instDevice_error   ,
                        status          =>  instDevice_status  ,
                        readLen         =>  instDevice_readLen );
       
            // READ
            // Copy data if available and valid
            IF instDevice_done = TRUE AND statDoneOld = FALSE AND statReadWrite = MODE_READ THEN
                IF statDirectParameter1 THEN

                    data^.directParameterPage.masterCommand       :=    statRecord[0];
                    data^.directParameterPage.masterCycleTime     :=    statRecord[1];
                    data^.directParameterPage.minCycleTime        :=    statRecord[2];
                    data^.directParameterPage.frameCapability     :=    statRecord[3];
                    data^.directParameterPage.ioLinkRevisionID    :=    statRecord[4];
                    data^.directParameterPage.processDataIn       :=    statRecord[5];
                    data^.directParameterPage.processDataOut      :=    statRecord[6];
                    data^.directParameterPage.vendorID1           :=    statRecord[7];
                    data^.directParameterPage.vendorID2           :=    statRecord[8];
                    data^.directParameterPage.deviceID1           :=    statRecord[9];
                    data^.directParameterPage.deviceID2           :=    statRecord[10];
                    data^.directParameterPage.deviceID3           :=    statRecord[11];
                    data^.directParameterPage.functionID1         :=    statRecord[12];
                    data^.directParameterPage.functionID2         :=    statRecord[13];
                    data^.directParameterPage.reserved1           :=    statRecord[14];
                    data^.directParameterPage.reserved2           :=    statRecord[15];
        
                ELSIF statDeviceAccessLocks THEN
                    data^.deviceAccessLocks.%B0 := statRecord[0];
                    data^.deviceAccessLocks.%B1 := statRecord[1];
                    
                ELSIF statVendorName THEN
                    tempData256[0]  := TO_BYTE(statRecordLen);
                    FOR tempIndex := UINT#0 TO TO_UINT(statRecordLen) - UINT#0 DO
                        tempData256[tempIndex + UINT#1] := statRecord[tempIndex];
                    END_FOR;
                    Deserialize(UINT#0,tempData256,data^.vendorName);
                ELSIF statVendorText THEN
                    tempData256[0]  := TO_BYTE(statRecordLen);
                    FOR tempIndex := UINT#0 TO TO_UINT(statRecordLen) - UINT#0 DO
                        tempData256[tempIndex + UINT#1] := statRecord[tempIndex];
                    END_FOR;
                    Deserialize(UINT#0,tempData256,data^.vendorText);
                    
                ELSIF statProductName THEN
                    tempData256[0]  := TO_BYTE(statRecordLen);
                    FOR tempIndex := UINT#0 TO TO_UINT(statRecordLen) - UINT#0 DO
                        tempData256[tempIndex + UINT#1] := statRecord[tempIndex];
                    END_FOR;
                    Deserialize(UINT#0,tempData256,data^.productName);
                    
                ELSIF statProductID THEN
                    tempData256[0]  := TO_BYTE(statRecordLen);
                    FOR tempIndex := UINT#0 TO TO_UINT(statRecordLen) - UINT#0 DO
                        tempData256[tempIndex + UINT#1] := statRecord[tempIndex];
                    END_FOR;
                    Deserialize(UINT#0,tempData256,data^.productID);
                    
                ELSIF statProductText THEN
                    tempData256[0]  := TO_BYTE(statRecordLen);
                    FOR tempIndex := UINT#0 TO TO_UINT(statRecordLen) - UINT#0 DO
                        tempData256[tempIndex + UINT#1] := statRecord[tempIndex];
                    END_FOR;
                    Deserialize(UINT#0,tempData256,data^.productText);
                    
                ELSIF statSerialNumber THEN
                    FOR tempIndex := UINT#0 TO TO_UINT(statRecordLen) - UINT#0 DO
                        tempData256[tempIndex + UINT#1] := statRecord[tempIndex];
                    END_FOR;
                    Deserialize(UINT#0,tempData256,data^.serialNumber);                    
                    
                ELSIF statHwRevision THEN
                    tempData256[0]  := TO_BYTE(statRecordLen);
                    FOR tempIndex := UINT#0 TO TO_UINT(statRecordLen) - UINT#0 DO
                        tempData256[tempIndex + UINT#1] := statRecord[tempIndex];
                    END_FOR;
                    Deserialize(UINT#0,tempData256,data^.hwRevision);
                    
                ELSIF statFwRevision THEN
                    tempData256[0]  := TO_BYTE(statRecordLen);
                    FOR tempIndex := UINT#0 TO TO_UINT(statRecordLen) - UINT#0 DO
                        tempData256[tempIndex + UINT#1] := statRecord[tempIndex];
                    END_FOR;
                    Deserialize(UINT#0,tempData256,data^.fwRevision);
                    
                ELSIF statAppSpecificName THEN
                    tempData256[0]  := TO_BYTE(statRecordLen);
                    FOR tempIndex := UINT#0 TO TO_UINT(statRecordLen) - UINT#0 DO
                        tempData256[tempIndex + UINT#1] := statRecord[tempIndex];
                    END_FOR;
                    Deserialize(UINT#0,tempData256,data^.appSpecificName);
                    
                ELSIF statErrorCount THEN
                    data^.errorCount.%B0 := statRecord[1];
                    data^.errorCount.%B1 := statRecord[0];
                    
                ELSIF statDeviceStatus THEN
                    data^.deviceStatus := statRecord[0];
                    
                ELSIF statDeviceStatusDetailed THEN
                    data^.deviceStatusDetailed := statRecord[0];
                    
                ELSIF statProcessIn THEN
                    FOR tempIndex := UINT#0 TO TO_UINT(statRecordLen) - UINT#1 DO
                        data^.processImageIn[tempIndex] :=  statRecord[tempIndex];
                    END_FOR;
                    
                ELSIF statProcessOut THEN
                    FOR tempIndex := UINT#0 TO TO_UINT(statRecordLen) - UINT#1 DO
                        data^.processImageOut[tempIndex] :=  statRecord[tempIndex];
                    END_FOR;
                    
                ELSIF statParameters THEN
                    data^.parameters.eventMessage    := statRecord[0];
                    data^.parameters.operatingMode   := statRecord[1];
                    data^.parameters.readyDelay      := statRecord[2];
                    data^.parameters.dataHoldingTime := statRecord[3];
                    data^.parameters.rfParameters    := statRecord[4];
                    data^.parameters.modulation      := statRecord[5];
                    data^.parameters.subcarrier      := statRecord[6];
                    data^.parameters.dataTransfer    := statRecord[7];
        
                ELSIF statEventHistory THEN
                    data^.eventHistory.lastEvent.%B0                :=	statRecord[3];
                    data^.eventHistory.lastEvent.%B1                :=	statRecord[2];
                    data^.eventHistory.lastEvent.%B2                :=	statRecord[1];
                    data^.eventHistory.lastEvent.%B3                :=	statRecord[0];

                    data^.eventHistory.secondLastEvent.%B0          :=	statRecord[7];
                    data^.eventHistory.secondLastEvent.%B1          :=	statRecord[6];
                    data^.eventHistory.secondLastEvent.%B2          :=	statRecord[5];
                    data^.eventHistory.secondLastEvent.%B3          :=	statRecord[4];

                    data^.eventHistory.thirdLastEvent.%B0           :=	statRecord[11];
                    data^.eventHistory.thirdLastEvent.%B1           :=	statRecord[10];
                    data^.eventHistory.thirdLastEvent.%B2           :=	statRecord[9];
                    data^.eventHistory.thirdLastEvent.%B3           :=	statRecord[8];

                    data^.eventHistory.fourthLastEvent.%B0          :=	statRecord[15];
                    data^.eventHistory.fourthLastEvent.%B1          :=	statRecord[14];
                    data^.eventHistory.fourthLastEvent.%B2          :=	statRecord[13];
                    data^.eventHistory.fourthLastEvent.%B3          :=	statRecord[12];

                    data^.eventHistory.fifthLastEvent.%B0           :=	statRecord[19];
                    data^.eventHistory.fifthLastEvent.%B1           :=	statRecord[18];
                    data^.eventHistory.fifthLastEvent.%B2           :=	statRecord[17];
                    data^.eventHistory.fifthLastEvent.%B3           :=	statRecord[16];
                            
                ELSIF statReaderStatus THEN
                    data^.readerStatus.timeSinceStartup.%B0         :=  statRecord[3];
                    data^.readerStatus.timeSinceStartup.%B1         :=  statRecord[2];
                    data^.readerStatus.timeSinceStartup.%B2         :=  statRecord[1];
                    data^.readerStatus.timeSinceStartup.%B3         :=  statRecord[0];
                    data^.readerStatus.tagsInTheField               :=	statRecord[4];
                    data^.readerStatus.antennaStatus                :=  statRecord[5];
                    data^.readerStatus.tagChanges.%B0               :=  statRecord[9]; 
                    data^.readerStatus.tagChanges.%B1               :=  statRecord[8]; 
                    data^.readerStatus.tagChanges.%B2               :=  statRecord[7]; 
                    data^.readerStatus.tagChanges.%B3               :=  statRecord[6]; 
                    data^.readerStatus.lineDriverRev                :=  statRecord[10]; 
                    data^.readerStatus.errorCounterPassive          :=  statRecord[11]; 
                    data^.readerStatus.abortCounter                 :=  statRecord[12]; 
                    data^.readerStatus.codeErrorCounter             :=  statRecord[13]; 
                    data^.readerStatus.signatureErrorCounter        :=  statRecord[14]; 
                    data^.readerStatus.crcErrorCounter              :=  statRecord[15]; 
                    data^.readerStatus.currentCommandStatus         :=  statRecord[16]; 
                    data^.readerStatus.errorCount                   :=  statRecord[17]; 
        
                    
                ELSIF statTagStatus THEN
                    data^.tagStatus.uid[0]              :=  statRecord[0];
                    data^.tagStatus.uid[1]              :=  statRecord[1];
                    data^.tagStatus.uid[2]              :=  statRecord[2];
                    data^.tagStatus.uid[3]              :=  statRecord[3];
                    data^.tagStatus.uid[4]              :=  statRecord[4];
                    data^.tagStatus.uid[5]              :=  statRecord[5];
                    data^.tagStatus.uid[6]              :=  statRecord[6];
                    data^.tagStatus.uid[7]              :=  statRecord[7];
                    data^.tagStatus.tagName             :=  statRecord[8];
                    data^.tagStatus.chipVersion         :=  statRecord[9];
                    data^.tagStatus.memSize.%B0         :=  statRecord[11];
                    data^.tagStatus.memSize.%B1         :=  statRecord[10];
                    data^.tagStatus.lockStatus          :=  statRecord[12];
                    data^.tagStatus.memBlockSize        :=  statRecord[13];
                    data^.tagStatus.numBlocks           :=  statRecord[14];
        
                    
                ELSIF statUidHistory THEN
                    data^.uidHistory.lastUID1.%B0         :=  statRecord[3];
                    data^.uidHistory.lastUID1.%B1         :=  statRecord[2];
                    data^.uidHistory.lastUID1.%B2         :=  statRecord[1];
                    data^.uidHistory.lastUID1.%B3         :=  statRecord[0];
                    data^.uidHistory.lastUID2.%B0         :=  statRecord[7];
                    data^.uidHistory.lastUID2.%B1         :=  statRecord[6];
                    data^.uidHistory.lastUID2.%B2         :=  statRecord[5];
                    data^.uidHistory.lastUID2.%B3         :=  statRecord[4];
                    data^.uidHistory.secondLastUID1.%B0   :=  statRecord[11];
                    data^.uidHistory.secondLastUID1.%B1   :=  statRecord[10];
                    data^.uidHistory.secondLastUID1.%B2   :=  statRecord[9];
                    data^.uidHistory.secondLastUID1.%B3   :=  statRecord[8];
                    data^.uidHistory.secondLastUID2.%B0   :=  statRecord[15];
                    data^.uidHistory.secondLastUID2.%B1   :=  statRecord[14];
                    data^.uidHistory.secondLastUID2.%B2   :=  statRecord[13];
                    data^.uidHistory.secondLastUID2.%B3   :=  statRecord[12];
                    data^.uidHistory.thirdLastUID1.%B0    :=  statRecord[19];
                    data^.uidHistory.thirdLastUID1.%B1    :=  statRecord[18];
                    data^.uidHistory.thirdLastUID1.%B2    :=  statRecord[17];
                    data^.uidHistory.thirdLastUID1.%B3    :=  statRecord[16];
                    data^.uidHistory.thirdLastUID2.%B0    :=  statRecord[23];
                    data^.uidHistory.thirdLastUID2.%B1    :=  statRecord[22];
                    data^.uidHistory.thirdLastUID2.%B2    :=  statRecord[21];
                    data^.uidHistory.thirdLastUID2.%B3    :=  statRecord[20];
                    data^.uidHistory.fourthLastUID1.%B0   :=  statRecord[27];
                    data^.uidHistory.fourthLastUID1.%B1   :=  statRecord[26];
                    data^.uidHistory.fourthLastUID1.%B2   :=  statRecord[25];
                    data^.uidHistory.fourthLastUID1.%B3   :=  statRecord[24];
                    data^.uidHistory.fourthLastUID2.%B0   :=  statRecord[31];
                    data^.uidHistory.fourthLastUID2.%B1   :=  statRecord[30];
                    data^.uidHistory.fourthLastUID2.%B2   :=  statRecord[29];
                    data^.uidHistory.fourthLastUID2.%B3   :=  statRecord[28];
                    data^.uidHistory.fifthLastUID1.%B0    :=  statRecord[35];
                    data^.uidHistory.fifthLastUID1.%B1    :=  statRecord[34];
                    data^.uidHistory.fifthLastUID1.%B2    :=  statRecord[33];
                    data^.uidHistory.fifthLastUID1.%B3    :=  statRecord[32];
                    data^.uidHistory.fifthLastUID2.%B0    :=  statRecord[39];
                    data^.uidHistory.fifthLastUID2.%B1    :=  statRecord[38];
                    data^.uidHistory.fifthLastUID2.%B2    :=  statRecord[37];
                    data^.uidHistory.fifthLastUID2.%B3    :=  statRecord[36];
        
                ELSE // Other data sets are not defined
                    ;
                END_IF;
                tempInternalError := tempRetValDeserialize <> TO_INT(STATUS_EXECUTION_FINISHED);
            END_IF;
            
            statDoneOld := instDevice_done;
        
            // OUTPUTS
            IF tempInternalError THEN //Error occured
                done := false;
                busy := false;
                error := true;
                status := ERR_INCONSISTENT_DATA;
            ELSE //Execute successful
                done := instDevice_done;
                busy := instDevice_busy;
                error := instDevice_error;
                status := instDevice_status;
                diagnostics^ := instDevice_diagnostics;
            END_IF;
        END_METHOD
    END_CLASS
END_NAMESPACE
