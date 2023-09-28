## AxoAnalogueInspector

Provides evaluation of *continuous* values. The inspector checks that the input value falls within the limit of *Min* and *Max*. The inspection passes when the input value is within the required limit without interruption for the duration of stabilization time.

![Analog inspector](assets/analog-inspector.png)

Common inspector data are extended with following analogue inspector data:

[!code-smalltalk[](../ctrl/src/AxoAnalogueInspector/AxoAnalogueInspectorData.st?name=AxoAnalogueInspectorDataDeclaration)]
