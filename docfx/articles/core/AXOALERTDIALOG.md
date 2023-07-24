# AlertDialog

The AlertDialog class provides a notification mechanism in application in form of toasts. 

![Alert Dialog](~/images/AlertDialog.png)

## In-app usage

Alerts dialogs can be simply called anywhere from application by injecting `IAlertDialogService` and calling `AddAlertDialog(type, title, message, time)` method.

> [!NOTE]
> `IAlertDialogService` is a scoped service, therefore alerts are unique to each client and are not synchronized.

1. Make sure your Blazor application references `axopen_core_blazor` project and AxoCore services are added to builder in `Program.cs` file. 
```C#
builder.Services.AddAxoCoreServices();
```

2. Add `AxoAlertToast` instance to `MainLayout.razor` file.
```HTML
@using AXOpen.Core.Blazor.AxoAlertDialog

<div class="page">
    <main>
        <TopRow />
        <article class="content px-4">
            @Body
        </article>
    </main>
    <NavMenu />

   <AxoAlertToast/>

</div>
```
2. Inject `IAlertDialogService` into you Blazor component

```C#
@inject IAlertDialogService _alerts
```

3. Invoke notification toast from your Blazor view

``` C#
_alertDialogService.AddAlertDialog(type, title, message, time);
```

Where:

- **type**: `eAlertDialogType` enum representing visualization type:
    - Undefined
    - Info
    - Success
    - Danger
    - Warning
- **title**: Refers to the header of alert
- **message**: Corresponds to the message 
- **time**: Specifies the duration in *seconds* for which the alert will be displayed



## Invoking alerts from PLC

Alerts can be invoked from PLC similarly like [AxoDialog](./AXODIALOG.md), however there is no need for user interaction.

```
VAR PUBLIC
    _alertDialog : AXOpen.Core.AxoAlertDialog;
END_VAR
//...
IF(_alertDialog.Show(THIS)
    .WithTitle('Plc alert')
    .WithType(eDialogType#Success)
    .WithMessage('This is alert invoked from plc!')
    .WithTimeToBurn(UINT#5).IsShown() = true) THEN
    //when task is done, move next
    THIS.MoveNext(); 
END_IF;	
```

> [!NOTE]
> `Alerts` invoked from PLC are synchronized across clients. 

1. Make sure your Blazor application references `axopen_core_blazor` project and AxoCore services are added to builder in `Program.cs` file.

2. Make sure your `MainLayout.razor` file contains instance of `<AxoAlertToast/>` component.

3. Add `AxoAlertDialogLocator` with provided list of observed objects to your view. You can add it either to:

    - `MainLayout.razor` file, where in consequence alerts will be displayed and synchronized across whole application.
    - Your own razor file, where alerts will be synchronized across multiple clients but only displayed within that specific razor page.

> [!NOTE]
> Make sure, that exist only one instance of `AxoAlertDialogLocator` either in `MainLayout.razor` or in your own page.

```HTML
<AxoAlertDialogLocator ObservedObjects="new[] {Entry.Plc.Context.PneumaticManipulator}"/>
```



