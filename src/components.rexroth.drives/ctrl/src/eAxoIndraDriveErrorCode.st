NAMESPACE AXOpen.Components.Rexroth.Drives
    TYPE PUBLIC
        eAxoIndraDriveErrorCode : WORD
        (		
            NONE_ERROR                  := WORD#16#0000,     (* No error code available              *)
            (*                  invalid input                                                   *)
            INPUT_INVALID_ERROR         := WORD#16#0001,     (* Invalid input                        *)
            (*                  communications error                                            *)
            COMMUNICATION_ERROR         := WORD#16#0002,     (* Error while communication            *)
            (*                  data processing error                                           *)
            RESOURCE_ERROR              := WORD#16#0003,     (* Resource error                       *)
            ACCESS_ERROR                := WORD#16#0004,     (* Access error                         *)
            STATE_MACHINE_ERROR         := WORD#16#0005,     (* Invalid state State - Machine        *)
            INPUT_RANGE_ERROR           := WORD#16#0006,     (* Error because Input out of range     *)
            CALCULATION_ERROR           := WORD#16#0007,     (* Error while calculation              *)
            (*                  device error                                                    *)
            DEVICE_ERROR                := WORD#16#0008,     (* Device Error occurred                *)
            (*                  other error                                                     *)
            OTHER_ERROR                 := WORD#16#7FFE,     (* Undefined Error                      *)
            (*                  system error                                                    *)
            SYSTEM_ERROR                := WORD#16#7FFF      (* System error occured                 *)
        
                );
    END_TYPE
END_NAMESPACE
