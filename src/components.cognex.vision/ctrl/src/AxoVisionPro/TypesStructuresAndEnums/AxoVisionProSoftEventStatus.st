
NAMESPACE AXOpen.Components.Cognex.Vision
   {S7.extern=ReadWrite}
	CLASS AxoVisionProSoftEventStatus 
      VAR PUBLIC
         ResetAck          : BOOL;
         DataHandlerDone   : BOOL;
         TriggerAck        : BOOL;
         Reserve           : BOOL;
      END_VAR
   END_CLASS
END_NAMESPACE
