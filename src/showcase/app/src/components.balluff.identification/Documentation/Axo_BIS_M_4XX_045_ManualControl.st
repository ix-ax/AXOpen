USING AXOpen.Core;

NAMESPACE AXOpen.Components.Balluff.Identification
    {S7.extern=ReadWrite}
    CLASS Axo_BIS_M_4XX_045_ManualControl_Example EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC
            ManualReader : AXOpen.Components.Balluff.Identification.Axo_BIS_M_4XX_045;
        END_VAR
        //</ComponentDeclaration>

        //<InitializationArgumentsDeclaration>
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Activate manual control#>"}
            ActivateManualControl : BOOL := TRUE;
        END_VAR
        //</InitializationArgumentsDeclaration>

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR

            SUPER.Run(inParent);

            // In manual-control mode the operator drives individual tasks from
            // the HMI. Configuration is still applied from ST on startup.
            IF ActivateManualControl THEN
                ManualReader.ActivateManualControl();
            END_IF;

            //<Initialization>
            ManualReader.Config.InfoTime      := LTIME#2S;
            ManualReader.Config.ErrorTime     := LTIME#5S;
            ManualReader.Config.TaskTimeout   := LTIME#50S;
            ManualReader.Config.StartAddress  := WORD#0;
            ManualReader.Config.RfidCodeSize  := WORD#50;

            ManualReader.Run(  inParent := THIS,
                               hwID     := AXOpen.Showcase.HwIdentifiers#BNIPNT507005Z040_HwID);
            //</Initialization>

            IF NOT ActivateManualControl THEN
                ManualReader.Restore();
            END_IF;
        END_METHOD

        //<Usage>
        // This scenario has no sequencer -- the reader is operated entirely
        // from the RenderableContentControl (Command-Control presentation):
        //   * Restore             -- applies Config and clears errors
        //   * Read                -- triggers ReadTask on the connected tag
        //   * Write               -- triggers WriteTask with the configured payload
        //   * ResetReader         -- restarts the reader firmware
        //   * ResetCommunication  -- restarts the PROFINET communication channel
        //   * WriteCharToMemory   -- writes a single byte at a configurable address
        //</Usage>
    END_CLASS
END_NAMESPACE
