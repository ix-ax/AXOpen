NAMESPACE AXOpen.Components.Siem.Identification

    {S7.extern=ReadWrite}
    CLASS SiemIdentification EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject     :   AxoObject;
            axo_IdentDevice    :   Axo_IdentDevice_Showcase;
            axoIOLink_RF200Device    :   AxoIOLink_RF200Device_Showcase;
            axoSimaticIdentCyclic  :   AxoSimaticIdentCyclic_Showcase;
            axoSimaticIdentCyclic_2   :   AxoSimaticIdentCyclic_Showcase2;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            axo_IdentDevice.Run(_rootObject);
            axoIOLink_RF200Device.Run(_rootObject);
            axoSimaticIdentCyclic.Run(_rootObject);
            axoSimaticIdentCyclic_2.Run(_rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE