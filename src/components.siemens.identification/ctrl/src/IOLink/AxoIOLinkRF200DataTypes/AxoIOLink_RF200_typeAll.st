NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS AxoIOLink_RF200_typeAll
        VAR PUBLIC
            directParameterPage     :	AxoIOLink_typeParameterPage0;       //  ID0: Parameter page 0
            systemCommand           :	BYTE    :=  BYTE#16#0;              //  ID2: System command
            deviceAccessLocks       :	WORD    :=  WORD#16#0;              //	ID12: Device access locks
            vendorName              :	STRING[12]  :=	'';                 //  ID16: Vendor name
            vendorText              :	STRING[12]  :=	'';                 //  ID17: Vendor text
            productName             :	STRING[24]  :=	'';                 //  ID18: Product name
            productID               :	STRING[16]  :=	'';                 //  ID19: Product ID
            productText             :	STRING[64]  :=	'';                 //  ID20: Product Text
            serialNumber            :	STRING[12]  :=	'';                 //  ID21: Serial Number
            hwRevision              :	STRING[12]  :=	'';                 //  ID22: Hardware revision
            fwRevision              :	STRING[12]  :=	'';                 //  ID23: Firmware revision
            appSpecificName         :	STRING[32]  :=	'';                 //  ID24: Application specific name
            errorCount              :	WORD    :=  WORD#16#0;              //	ID32: Number of errors that have occured (not warnings)
            deviceStatus            :	BYTE    :=  BYTE#16#0;              //  ID36: Device status
            deviceStatusDetailed    :	BYTE    :=  BYTE#16#0;              //  ID37: Detailed device status
            processImageIn          :	ARRAY[0..7] OF BYTE;                //	ID40: Read out last process image of the inputs
            processImageOut         :	ARRAY[0..7] OF BYTE;                //	ID41: Read out last process image of the outputs
            parameters              :	AxoIOLink_RF200_typeParameters;     //	ID64: Read/Write Reader Parameters
            eventHistory            :	AxoIOLink_RF200_typeEventHistory;   //	ID74: Number of events
            readerStatus            :	AxoIOLink_RF200_typeReaderStatus;   //	ID90: Reader status
            tagStatus               :	AxoIOLink_RF200_typeTagStatus;      //	ID91: Tag status
            uidHistory              :	AxoIOLink_RF200_typeUIDHistory;     //	ID92: History of UID
        END_VAR
    END_CLASS
END_NAMESPACE