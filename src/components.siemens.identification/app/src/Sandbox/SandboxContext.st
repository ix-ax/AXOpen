USING  AXOpen.Components.SIEM.Identification;
USING System.Serialization;
USING System.Strings;


{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    // VAR PUBLIC
    //     _manualControl             :   BOOL := TRUE;
    //     {#ix-attr:[CompilerOmits()]}
    //     _rf186_1_hardwareConfig: ARRAY[0..15] OF BYTE := [BYTE#16#04,BYTE#16#00,BYTE#16#00,BYTE#16#00,BYTE#16#00,BYTE#16#0A,BYTE#16#00,BYTE#16#00,BYTE#16#00,BYTE#16#25,BYTE#16#00,BYTE#16#00,BYTE#16#00,BYTE#16#01,BYTE#16#00,BYTE#16#01]; //default data for RF260R 
    //     rf186_1 : AXOpen.Components.SIEM.Identification.Axo_IdentDevice;        
    //     ExampleReader : AXOpen.Components.SIEM.Identification.AxoIOLink_RF200Device;            
    //     _readTag_execute            :   BOOL    :=  FALSE;    
    //     _readTag_addrTag            :	WORD    :=  WORD#16#0;      
    //     _readTag_length             :	WORD    :=  WORD#16#1C;   
    //     _readTag_Data               :   AxoByteArray256;
    //     _readTag_done               :   BOOL    :=  FALSE;        
    //     _readTag_busy               :   BOOL    :=  FALSE;        
    //     _readTag_error              :   BOOL    :=  FALSE;        
    //     _readTag_status             :   DWORD   :=  DWORD#16#0;
    //     _readTag_presence           :   BOOL    :=  FALSE; 
    //     _readTag : AXOpen.Components.SIEM.Identification.AxoIOLink_RF200_ReadTag;          
    //     _readBuffer                 :   ARRAY[0..255] OF BYTE;       

    //     _write      :    BOOL;
    //     WriteData   :   STRING  :=  'My_very_first_attempt_to_use_RF2xx_via_IO-Link_interface';
    //     WriteDataArr:   ARRAY[0..255] OF BYTE;
    // END_VAR
    VAR PUBLIC
        _WriteTag_execute            :   BOOL    :=  FALSE;    
        _WriteTag_addrTag            :	WORD    :=  WORD#16#0;      
        _WriteTag_length             :	WORD    :=  WORD#16#1C;   
        _WriteTag_Data               :   AxoByteArray256;
        _WriteTag_done               :   BOOL    :=  FALSE;        
        _WriteTag_busy               :   BOOL    :=  FALSE;        
        _WriteTag_error              :   BOOL    :=  FALSE;        
        _WriteTag_status             :   DWORD   :=  DWORD#16#0;
        _WriteTag_presence           :   BOOL    :=  FALSE; 
        _WriteTag : AXOpen.Components.SIEM.Identification.AxoIOLink_RF200_WriteTag;          
        _WriteBuffer                 :   ARRAY[0..255] OF BYTE;       

        WriteData   :   STRING  :=  'My_very_first_attempt_to_use_RF2xx_via_IO-Link_interface';
        WriteDataArr:   ARRAY[0..255] OF BYTE;
    END_VAR

    METHOD PROTECTED OVERRIDE Main
        RETURN;

        Serialize(UINT#0,WriteData,WriteDataArr);

        _WriteTag.Run(  execute     :=  _WriteTag_execute,
                        addrTag     :=  _WriteTag_addrTag,
                        length      :=  _WriteTag_length,
                        hwID        :=   HwIdentifiers#ET200SP_CM_4xIO_Link_V2_2_144I_128O_1,        
                        portAddr    :=  INT#0,   
                        version     :=  USINT#11,
                        identData   :=  REF(_WriteBuffer),
                        done        =>  _WriteTag_done,
                        busy        =>  _WriteTag_busy,
                        error       =>  _WriteTag_error,
                        status      =>  _WriteTag_status,
                        presence    =>  _WriteTag_presence);


    END_METHOD
END_CLASS



