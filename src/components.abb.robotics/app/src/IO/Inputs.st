NAMESPACE AXOpen.Components.Abb.Robotics
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
            OmniCore_DI_64_bytes_0 AT %B0:  LWORD;
            OmniCore_DI_64_bytes_1 AT %B8:  LWORD;
            OmniCore_DI_64_bytes_2 AT %B16:  LWORD;
            OmniCore_DI_64_bytes_3 AT %B24:  LWORD;
            OmniCore_DI_64_bytes_4 AT %B32:  LWORD;
            OmniCore_DI_64_bytes_5 AT %B40:  LWORD;
            OmniCore_DI_64_bytes_6 AT %B48:  LWORD;
            OmniCore_DI_64_bytes_7 AT %B56:  LWORD;
            RobotBasicIO_DI_64_bytes_0 AT %B64:  LWORD;
            RobotBasicIO_DI_64_bytes_1 AT %B72:  LWORD;
            RobotBasicIO_DI_64_bytes_2 AT %B80:  LWORD;
            RobotBasicIO_DI_64_bytes_3 AT %B88:  LWORD;
            RobotBasicIO_DI_64_bytes_4 AT %B96:  LWORD;
            RobotBasicIO_DI_64_bytes_5 AT %B104:  LWORD;
            RobotBasicIO_DI_64_bytes_6 AT %B112:  LWORD;
            RobotBasicIO_DI_64_bytes_7 AT %B120:  LWORD;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
