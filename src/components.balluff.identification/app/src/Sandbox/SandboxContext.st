USING Siemens.Simatic.S71500.Clocks;
USING System.Strings;
USING System.BitAccess;
USING System.Math;
USING System.Serialization;

{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl : BOOL;
        _testReader : AXOpen.Components.Balluff.Identification.Axo_BIS_M_4XX_045;          

    END_VAR

    METHOD PROTECTED OVERRIDE Main
        VAR 
            i:int;
        END_VAR;

        _testReader.Run(    parent := THIS,
                            hwID            := HwIdentifiers#BNIPNT507005Z040,
                            hwId_BISM       := HwIdentifiers#BNIPNT507005Z040_BIS_M_4XX_045_1);

        IF(_manualControl) THEN
            _testReader.ActivateManualControl();
        END_IF;    
    END_METHOD
END_CLASS
