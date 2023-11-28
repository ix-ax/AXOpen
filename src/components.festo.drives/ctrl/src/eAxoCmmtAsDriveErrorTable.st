NAMESPACE AXOpen.Components.Festo.Drives
    TYPE PUBLIC
        eAxoCmmtAsDriveErrorTable : WORD
        (		
            NO_TABLE_USED           := WORD#16#0000,         //reserved                                     
            SERCOS_TABLE            := WORD#16#0010,         //Sercos Error: Addtitional1 = Sercos Code     
            MLDS_TABLE              := WORD#16#0020,         //Drive-based Motion - Logic                   
            MLC_TABLE               := WORD#16#0030,         //Controller - based Motion - Logic            
            MTX_TABLE               := WORD#16#0040,         //CNC                                          
            MLP_TABLE               := WORD#16#0050,         //PC  - based Motion Logic                     
            PLC_TABLE               := WORD#16#0060,         //PLC                                          
            INDRV_TABLE             := WORD#16#0070,         //IndraDrive                                   
            DIAX_TABLE              := WORD#16#0080,         //DIAX                                         
            ECO_TABLE               := WORD#16#0090,         //EcoDrive                                     
            PB_DP_TABLE             := WORD#16#0130,         //Profibus                                     
            DEVICENET_TABLE         := WORD#16#0140,         //DeviceNet                                    
            ETHERNET_TABLE          := WORD#16#0150,         //Ethernet                                     
            INTERBUS_TABLE          := WORD#16#0160,         //Interbus                                     
            F_RELATED_TABLE         := WORD#16#0170,         //function related                             
            USER1_TABLE             := WORD#16#1000,         //free User Table                              
            USER2_TABLE             := WORD#16#1001,         //free User Table                              
            USER3_TABLE             := WORD#16#1002,         //free User Table                              
            USER4_TABLE             := WORD#16#1003,         //free User Table                              
            USER5_TABLE             := WORD#16#1004,         //free User Table                              
            USER6_TABLE             := WORD#16#1005,         //free User Table                              
            USER7_TABLE             := WORD#16#1006,         //free User Table                              
            USER8_TABLE             := WORD#16#1007,         //free User Table                              
            USER9_TABLE             := WORD#16#1008,         //free User Table                              
            USER10_TABLE            := WORD#16#1009          //free User Table                              
        );
    END_TYPE
END_NAMESPACE