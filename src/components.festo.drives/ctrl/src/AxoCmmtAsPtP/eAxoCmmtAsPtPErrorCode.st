NAMESPACE AXOpen.Components.Festo.Drives
    TYPE PUBLIC
        eAxoCmmtAsPtPErrorCode : WORD
        (		
            STATUS_IN_OPERATION         :=	WORD#16#7002,
            ERROR_INVALID_MODE          :=	WORD#16#8202,
            ERROR_OVERRIDE              :=	WORD#16#8203,
            ERROR_INVALID_TRV_BLOCK     :=	WORD#16#8204,
            ERROR_DRIVE_ERROR           :=	WORD#16#8401,
            ERROR_SWITCH_ON_INHIBITED   :=	WORD#16#8402,
            ERROR_ADD_TORQUE            :=	WORD#16#8210,
            ERROR_ADD_TORQUE_LIMIT_POS  :=	WORD#16#8211,
            ERROR_ADD_TORQUE_LIMIT_NEG  :=	WORD#16#8212
                );
    END_TYPE
END_NAMESPACE