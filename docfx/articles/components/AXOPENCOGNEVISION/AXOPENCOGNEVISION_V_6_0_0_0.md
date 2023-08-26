# AXOpenCognexVision

The `AXOpenCognexVision` library controls and operates the vision devices from the manufacturer `Cognex`. 


## AxoDataman

`AxoDataman` provides the essential control and operation of all code-reader of the `Dataman` family.

### Implementation
The `AxoDataman` is designed to be used as a member of the `AxoContext` or `AxoObject`.
Therefore its instance must be initialized with the proper `AxoContext` or `AxoObject` before any use. 
Also, the hardware signals must be assigned first before calling any method of this instance. 
To accomplish this, call the `Run` method cyclically with the proper variables (i.e. inside the `Main` method of the relevant `AxoContext`) as in the example below:

**Example of the initialization and hardware signal assignement**
[!code-smalltalk[](../../../../src/integrations/ctrl/src/Examples/AXOpen.Cognex.Vision/AxoCognexVisionDatamanExample.st?name=HWIO_Assignement)]

There are three public methods to operate the `AxoDataman`:

`Restore` - restores the state of the `AxoDataman` to the initial state and resets all the internal variables.

`ClearResultData` - resets the data read and confirms the data received from the device.
**Example of using ClearResultData method**
[!code-smalltalk[](../../../../src/integrations/ctrl/src/Examples/AXOpen.Cognex.Vision/AxoCognexVisionDatamanExample.st?name=ClearResultData)]

`Read` - triggers the reading sequence and waits for results.
**Example of using Read method**
[!code-smalltalk[](../../../../src/integrations/ctrl/src/Examples/AXOpen.Cognex.Vision/AxoCognexVisionDatamanExample.st?name=Read)]

