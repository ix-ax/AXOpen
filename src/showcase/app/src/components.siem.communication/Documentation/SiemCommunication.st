NAMESPACE AXOpen.Components.Siem.Communication
    {S7.extern=ReadWrite}
    CLASS SiemCommunication EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            rootObject      : AxoObject;
            axoCmPtp    : AXOpen.Components.Siem.Communication.AxoCmPtp_Showcase;
            // axoCmPtp_2    : AXOpen.Components.Siem.Communication.AxoCmPtp_Showcase2;
        END_VAR

        METHOD PUBLIC Execute
            rootObject.Run(THIS);
            axoCmPtp.Run(rootObject);
            // axoCmPtp_2.Run(rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE