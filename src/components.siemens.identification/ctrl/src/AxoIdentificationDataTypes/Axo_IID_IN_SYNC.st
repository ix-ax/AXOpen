NAMESPACE AXOpen.Components.Siemens.Identification

// TYPE ST_IID_IN_SYNC :
//     STRUCT
    CLASS Axo_IID_IN_SYNC
        VAR PUBLIC
            STATUS_IN_WORK              :   BOOL    :=  FALSE;      //command is in work
            STATUS_INITIALISATION       :   BOOL    :=  FALSE;      //initialisation is in work
            STATUS_LAST_CMD_INIT        :   BOOL    :=  FALSE;      //flag for initialisation
            sreset_request              :   BOOL    :=  FALSE;      //show that one app is in sreset
            acyc_active                 :   BOOL    :=  FALSE;      //acyc service is running
            reset_request               :   BOOL    :=  FALSE;      //shows that one reset-instruction is wait for ends of acyclic commands
            AC_H                        :   BOOL    :=  FALSE;      //ack counter high
            AC_L                        :   BOOL    :=  FALSE;      //ack counter low
            CC_H                        :   BOOL    :=  FALSE;      //cmd counter high
            CC_L                        :   BOOL    :=  FALSE;      //cmd counter low
            old_CC_H                    :   BOOL    :=  FALSE;      //previous ack counter high
            old_CC_L                    :   BOOL    :=  FALSE;      //previous ack counter low
            old_AC_H                    :   BOOL    :=  FALSE;      //previous cmd counter high
            old_AC_L                    :   BOOL    :=  FALSE;      //previous cmd counter low
            cyc_control                 :   WORD    :=  WORD#16#0;  //cyclic control word
            cyc_status                  :   WORD    :=  WORD#16#0;  //cyclic status word
            SRESET_active               :   BOOL    :=  FALSE;      //sreset active bit (cyc status word)
            SRESET_cyc                  :   BOOL    :=  FALSE;      //sreset control bit (cyc control word)
            RPTCMD_cyc                  :   BOOL    :=  FALSE;      //repeat control bit (cyc control word)
            RPTCMD_active               :   BOOL    :=  FALSE;      //repeat active bit (cyc status word)
            INIT_cyc                    :   BOOL    :=  FALSE;      //init control bit (cyc control word)
            init_active                 :   BOOL    :=  FALSE;      //init status bit (cyc status word)
            presence                    :   BOOL    :=  FALSE;      //presence-bit
            buf_header                  :   UINT    :=  UINT#11;    //length pib-header
            sequence_number             :   UINT    :=  UINT#0;     //sequence number (pib-header)
            config_value                :   BYTE    :=  BYTE#16#4;  //config mode for pdu-detection
            offset                      :   UINT    :=  UINT#0;     //offset for cyclic status/control word
            index                       :   UINT    :=  UINT#0;     //index for WRREC/RDREC
            buf_max                     :   UINT    :=  UINT#240;   //acyclic datagram buffer size
            instruction_set             :   BOOL    :=  FALSE;      //state for instruction set (1=RF68xR; 0=old CMs)
            index_set                   :   BOOL    :=  TRUE;       //state for DS-index (1=PROFINET; 0=PROFIBUS)
            timeout_repeat              :   TIME    :=  T#5S;       //timeout for repeat
            timeout_reset               :   TIME    :=  T#1M;       //timeout for init
            state                       :   UINT    :=  UINT#0;     //variable for statemachine
            buf_maxdata                 :   UINT    :=  UINT#229;   //user data size
            //buf:ARRAY[0..1034] OF BYTE;
            pnConfigRecord : Axo_IID_IN_PN_CONFIGRECORD;
        //     END_STRUCT
    // END_TYPE
        END_VAR
    END_CLASS
END_NAMESPACE