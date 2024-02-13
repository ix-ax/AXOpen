NAMESPACE AXOpen.Components.Siemens.Identification

(* 
+-----------+-------------------------------------------+------------------------------------------------------+---------------------+
|           |             RF61xR/RF68xR                 |                     RF1xxC/RF360R                    |   RF180C/RF170C/MV  |
| Parameter +----------+----------+----------+----------+----------+----------+----------+----------+----------+----------+----------+
|			|   CH01   |   CH02   |   CH03   |   CH04   |   CH01   |   CH02   |   CH03   |   CH04   |CM_CONFIG |   CH01   |   CH02   |  
+===========+==========+==========+==========+==========+==========+==========+==========+==========+==========+==========+==========+
| API       | 16#5B00  | 16#5B00  | 16#5B00  | 16#5B00  | 16#5B00  | 16#5B00  | 16#5B00  | 16#5B00  | 16#5B00  |   16#00  |   16#00  |
+-----------+----------+----------+----------+----------+----------+----------+----------+----------+----------+----------+----------+
| SLOT      |     1    |     1    |     1    |     1    |     2    |     3    |     4    |     5    |     1    |     1    |     1    |
+-----------+----------+----------+----------+----------+----------+----------+----------+----------+----------+----------+----------+
| SUB_SLOT  |     1    |     1    |     1    |     1    |     1    |     1    |     1    |     1    |     1    |     1    |     1    |
+-----------+----------+----------+----------+----------+----------+----------+----------+----------+----------+----------+----------+
|CM_CHANNEL |     1    |     2    |     3    |     4    |     1    |     1    |     1    |     1    |     1    |     1    |     2    |
+-----------+----------+----------+----------+----------+----------+----------+----------+----------+----------+----------+----------+
*)

// TYPE ST_IID_HW_CONNECT :
//     STRUCT
    CLASS Axo_IID_HW_CONNECT
        VAR PUBLIC
            // AMS_NET_ID			:   T_AmsNetID; 				    //ams net id of profinet controller
            // PORT 				:   T_AmsPort; 				        //port of profinet device
            AMS_NET_ID			:   STRING; 				        //ams net id of profinet controller
            PORT 				:   STRING; 				        //port of profinet device
            AR_NUMBER 			:   WORD    :=  WORD#16#0; 			//Number of AR
            API 				:   DWORD   :=  DWORD#16#0000_5B00; //API number 
            SLOT 				:   WORD    :=  WORD#16#02;  		//Slot number  
            SUB_SLOT 			:   WORD    :=  WORD#16#01; 		//Subslot number 
            CM_CHANNEL 			:   UINT    :=  UINT#1; 		    //channel of communication module	
            STATUS_WORD         :   WORD; 					        //status word cyclic data -> link to input word of device
            CONTROL_WORD        :   WORD; 					        //control word cyclic data -> link to output word of device
            Static              :   Axo_IID_IN_SYNC; 
//     END_STRUCT
// END_TYPE
    END_VAR
    END_CLASS
END_NAMESPACE