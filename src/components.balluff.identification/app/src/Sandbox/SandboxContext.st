USING AXOpen.Core;
USING Siemens.Simatic.S71500.Clocks;
USING System.Strings;
USING System.BitAccess;
USING System.Math;
USING System.Serialization;

NAMESPACE AXOpen.Components.Balluff.Identification
    {S7.extern=ReadWrite}
    CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            _manualControl  :   BOOL;
            _rootObject     :   AxoObject;
            _testReader     :   AXOpen.Components.Balluff.Identification.Axo_BIS_M_4XX_045;          

        END_VAR

        METHOD PROTECTED OVERRIDE Main
            VAR 
                i:int;
            END_VAR;

            THIS.InitializeRootObject(_rootObject);
            _testReader.Run(    parent := _rootObject,
                                hwID            := HwIdentifiers#BNIPNT507005Z040_HwID,
                                hwId_BISM       := HwIdentifiers#BNIPNT507005Z040_BIS_M_4XX_045_1_BIS_M_4XX_045_HwID);

            IF(_manualControl) THEN
                _testReader.ActivateManualControl();
            END_IF;    
        END_METHOD
    END_CLASS
END_NAMESPACE