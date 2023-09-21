## AXOpenElements.AxoAi

AxoAi is used for checking values of analogue inputs. AxoAi scales input signal based on values in `AxoAiConfig` class.

AxoAiConfig contains:

[!code-smalltalk[](../ctrl/src//AxoAi/AxoAiConfig.st?name=AxoAiConfigDeclaration)]

# How to

# [CONTROLLER](#tab/controller)

# How to use component in controller

## Declare component

[!code-smalltalk[](../app/src/Documentation/DocumentationContext.st?name=AxoAiDeclaration)]

## Declare initialization variables

*Most of the initialization variable will come from the I/O system. This example is only for demostrational puproses.*

[!code-smalltalk[](../app/src/Documentation/DocumentationContext.st?name=AxoAiInitializationArgumentsDeclaration)]

## Manual Control

[!code-smalltalk[](../app/src/Documentation/DocumentationContext.st?name=AxoAiManualControl)]

## Initialize & Run

[!code-smalltalk[](../app/src/Documentation/DocumentationContext.st?name=AxoAiInitialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

# [.NET TWIN](#tab/twin)



# [BLAZOR](#tab/blazor)

![AxoAi](assets/axoai.gif)