# AxoDialogs

AxoDialogs provide capability to interact with the user by rising dialogs directly from the PLC program.

## Example


```
VAR  PUBLIC
    _dialog : AXOpen.Core.AxoDialog;
END_VAR
//----------------------------------------------

IF(_dialog.Show(THIS)
    .WithOk()
    .WithType(eDialogType#Success)
    .WithCaption('What`s next?')
    .WithText('To continue click OK?').Answer() = eDialogAnswer#OK) THEN

    //if answer is ok, move next in sequence                                 
    THIS.MoveNext(); 

END_IF;	
```

![Modal ok Dialog](~/images/ok-dialog.png)

## Getting started 

1. Make sure your Blazor application references `axopen_core_blazor` project and AxoCore services are added to builder in `Program.cs` file. Also, map `dialoghub` which is needed for dialog synchronization using SignalR technology. 
```C#
builder.Services.AddAxoCoreServices();
//...
app.MapHub<DialogHub>("/dialoghub");
```



2. Go to your page, where you wish to have dialogs and include `AxoDialogLocator` component at the end of that page.

Provide list of `ObservedObjects`, on which you want to observe dialogs. You can also provide `DialogId`, which serves for synchronization of dialogs between multiple clients. If `DialogId` is not provided, the current *URI* is used as an id.

> [!IMPORTANT]
> Make sure, that each page has only one instance of `AxoDialogLocator` and that provided `DialogId` is unique across the application! If you wish to observe multiple objects, add them into `ObservedObjects` list.

```C#
<AxoDialogLocator DialogId="custation001" ObservedObjects="new[] {Entry.Plc.Context.PneumaticManipulator}"></AxoDialogLocator>
```

Now, when dialog is invoked in PLC, it will show on all clients and pages, where `AxoDialogLocator` is present with corresponding observed objects. The answers are synchronized across multiple clients.

## AxoDialog types

AxoDialogs contains currently 3 types of predefined dialogs:

1. Okay dialog
2. YesNo dialog
3. YesNoCancel dialog


![Dialog types](~/images/dialog-types.gif)

Also, the visual type of corresponding dialog can be adjusted with `eDialogType` enum, which is defined as follows:
```
 eDialogType : INT (
    Undefined := 0,
    Info := 10,
    Success := 20,
    Danger := 30,
    Warning := 40
);

```

## Answer synchronization on multiple clients

Answers of dialogs are synchronized across multiple clients with the SignalR technology. 

![Dialog sync](~/images/dialog-sync.gif)


## Creation of own dialog