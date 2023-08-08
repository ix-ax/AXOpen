# AxoTextList

AxoTextList provides displaying the string value from the list defined in the extended class inside the `.NET` twin based on the numerical value read out from the PLC.
Moreover, the display form could also change the background colour with the numerical value change. To achieve this, the attributes `WarningLevel` and `ErrorLevel` need to be declared as in the following example.
[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/AxoTextList/AxoTextListExample.st?name=AxoTextListWithLevelsDefined)]
The final text displayed in the UI application will be `static prefix`+[`text value from text list`(Id)](for example `Description : ` + [TextList(Id)]). 
The static prefix is optional. Use the following example to display the same text list without static prefix and with different levels.
[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/AxoTextList/AxoTextListExample.st?name=AxoTextListWithoutPrefix)]
If the `WarningLevel` is greater than 0 and the `ErrorLevel` is greater than the `WarningLevel`, all items with the `Id` lower than the `WarningLevel` are displayed with the `Primary` background, all items with the `Id` greater or equal to the `WarningLevel` and lower then the `ErrorLevel` are displayed with the `Warning` background and all the rest are displayed with the `Danger` background. The final colours depend on the style used.
If the attributes `WarningLevel` and `ErrorLevel` are not declared as in the following example, all items are displayed with the `Primary` background.
[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/AxoTextList/AxoTextListExample.st?name=AxoTextListWithoutLevelsDefined)]

For each `AxoTextList`, there must be a defined property, named exactly as in the `Attributes` inside the examples above. It must be defined in the extended class that the particular `AxoTextList` is a member of.  
This property must return a string value from the dictionary defined in the same class based on the numerical value of the `Id` variable.

Declaration of the dictionary:
[!code-csharp[](../../../src/integrations/src/AXOpen.Integrations/AxoTextListExample/AxoTextListExampleContext.cs?name=DeclarationOfTheDictionary)]

Filling the items of the dictionary:
[!code-csharp[](../../../src/integrations/src/AXOpen.Integrations/AxoTextListExample/AxoTextListExampleContext.cs?name=FillingTheItemsOfTheDictionary)]

Returning the string item from the dictionary:
[!code-csharp[](../../../src/integrations/src/AXOpen.Integrations/AxoTextListExample/AxoTextListExampleContext.cs?name=ReturningTheItemBasedOnId)]

Complete example for two different `AxoTextList`:
[!code-csharp[](../../../src/integrations/src/AXOpen.Integrations/AxoTextListExample/AxoTextListExampleContext.cs?range=1-71)]

**How to visualize `AxoTextList`**

On the UI side, to visualize the `AxoTextList`, use the `RenderableContentControl` and set its Context according to the placement of the instance of the `AxoTextList`.
[!code-csharp[](../../../src/integrations/src/AXOpen.Integrations.Blazor/Pages/AxoTextList/AxoTextListExample.razor?name=UI)]

The displayed result should look like this:

![Alt text](~/images/AxoTextListExampleVisu.gif)
