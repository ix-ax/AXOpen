# AxoDialogs

AxoDialogs provide capability to interact with the user by rising dialogs directly from the PLC program.

## Prerequisities

1. Make sure your Blazor application references `axopen_core_blazor` project and AxoCore services are added to builder in `Program.cs` file. Also, map `dialoghub` which is needed for dialog synchronization using SignalR technology. 
```C#
builder.Services.AddAxoCoreServices();
//...
app.MapHub<DialogHub>("/dialoghub");
```



2. Go to your page, where you wish to have dialogs and include `AxoDialogLocator` component at the end of that page.

Provide list of `ObservedObjects`, on which you want to observe dialogs. Also provide `DialogId`, which serves for synchronization of dialogs between multiple clients. If `DialogId` is not provided, the current *URI* is used as an id.

> [!IMPORTANT]
> Make sure, that each page has only one instance of `AxoDialogLocator` and that provided `DialogId` is unique across the application! If you wish to observe multiple objects, add them into `ObservedObjects` list.

```HTML
<AxoDialogLocator DialogId="custation001" ObservedObjects="new[] {Entry.Plc.Context.PneumaticManipulator}"/>
```

Now, when dialog is invoked in PLC, it will show on all clients and pages, where `AxoDialogLocator` is present with corresponding observed objects. The answers are synchronized across multiple clients.

## .Net integration


```mermaid
  classDiagram

AxoDialogContainer o-- DialogClient
AxoDialogContainer o-- AxoAlertDialogProxyService
AxoDialogContainer o-- AxoDialogProxyService


AxoDialogLocator o-- AxoDialogContainer : injected
AxoDialogDialogView --|> AxoDialogBaseView
%%AxoDialogLocator o-- NavigationManager : injected
AxoDialogLocator o-- AxoDialogProxyService : injected
AxoDialogLocator o.. AxoDialogProxyService : DialogInvoked


AxoDialogBaseView --|> AxoDialogBase

DialogClient ..> DialogHub   : SignalR
AxoDialogDialogView ..> DialogHub   : SignalR

AxoDialogProxyService o-- AxoDialogDialogView : composition
AxoDialogProxyService --|> AxoDialogProxyServiceBase

AxoDialogProxyService "1" -- "1" AxoDialogEventArgs : uses 
AxoDialogEventArgs --|> EventArgs
AxoDialogBase  --|> AxoRemoteTask 

  %% done
    class AxoDialogLocator{
        - _dialogProxyService : AxoDialogProxyService  
        - _dialogContainer : AxoDialogContainer         
        - _navigationManager : NavigationManager 
        + DialogLocatorId : String       
        + ObservedObject : IEnumerable~ITwinObject~  
        + DialogOpenDelay : Int

        - OnDialogInvoked ()
        # OnInitializedAsync()
    }     


    %% done
    class AxoDialogDialogView~T:AxoDialog~{
        - OnCloseSignal()
        # AddToPolling()
        # OnInitialized()
        # OnAfterRenderAsync()
        + DialogAnswerOk()
        + DialogAnswerYes()
        + DialogAnswerNo()
        + DialogAnswerCancel()
    }    
    
    %% done
    class AxoDialogBaseView~T:AxoDialogBase~{
        - _axoDialogContainer : AxoDialogContainer         
        - _navigationManager : NavigationManager 
        - _dialogProxyService : AxoDialogProxyService  
        # ModalDialog: ModalDialog
        # OnInitialized()
        + OpenDialog()
        + Close()
        + CloseDialogsWithSignalR()
        # OnAfterRenderAsync()
        # OnOpenDialogMessage()
        # OnCloseDialogMessage()
        # AddToPolling()
    } 
   
  
    %% done
    class AxoDialogProxyService{
        - _axoDialogContainer : AxoDialogContainer  
        - _observedObject : IEnumerable~ITwinObject~ 
        + DialogInvoked : EventHandler~AxoDialogEventArgs~ 
        - DialogId : String 
        + DialogProxyService(dialogContainer, dialogLocatorId, [] observedObjects)        
        # StartObservingObjectsForDialogues ()
        # HandleDialogInvocation()
        # StartObservingDialogs()

    }  

    %% done
    class AxoDialogProxyServiceBase{
        + DialogInstance : IsDialogType
        + DialogInstances : List~IsDialogType~
        - GetDescendants()        
    }   

    %% done
    class AxoDialogContainer{
        +  DialogClient : DialogClient 
        +  ObservedObjects : HashSet~string~
        +  ObservedObjectsAlerts: HashSet~string~

        +  DialogProxyServicesDictionary : Dictonary~String,AxoDialogProxyService~  
        +  AlertDialogProxyServicesDictionary : Dictonary~String,AxoAlertDialogProxyService~
        + InitializeSignalR(string uri)       
    }   


    
    %% done
    class DialogClient{
        + _hubConnection : HubConnection
        + MessageReceivedEventHandler : delegate
        + DialogClient(string siteUrl)
        + StartAsync()
        + StopAsync()
        + SendDialogOpen(string message)
        + SendDialogClose(string message)
        + HandleReceiveMessage(string message)
        + HandleReceiveDialogClose(string message)
    } 

    %% treba ozrejmit dialog-id ked bude pole
    class AxoDialogEventArgs{
        +  DialogId : String
        + (DialogId)
    }   

    %% done
    class DialogHub{
        +  SendDialogOpen(string message) 
        +  SendDialogClose(string message) 
    }   


```




