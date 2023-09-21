## AXOpenElements.AxoAo

AxoAo is used for setting analogue values. AxoAo un-scales input signal based on `SetPoint` and values in `AxoAoConfig` class.

AxoAiConfig contains:

[!code-smalltalk[](../ctrl/src/AxoAo/AxoAoConfig.st?name=AxoAoConfigDeclaration)]

# How to

# [CONTROLLER](#tab/controller)

# How to use component in controller

## Declare component

[!code-smalltalk[](../app/src/Documentation/DocumentationContext.st?name=AxoAoDeclaration)]

## Declare initialization variables

*Most of the initialization variable will come from the I/O system. This example is only for demostrational puproses.*

[!code-smalltalk[](../app/src/Documentation/DocumentationContext.st?name=AxoAoInitializationArgumentsDeclaration)]

## Manual Control

[!code-smalltalk[](../app/src/Documentation/DocumentationContext.st?name=AxoAoManualControl)]

## Initialize & Run

[!code-smalltalk[](../app/src/Documentation/DocumentationContext.st?name=AxoAoInitialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

# [.NET TWIN](#tab/twin)



# [BLAZOR](#tab/blazor)

![AxoAo](assets/axoao.gif)