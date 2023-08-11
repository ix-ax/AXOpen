using Microsoft.AspNetCore.SignalR.Client;

namespace clientchat.ClientIdentification;

public class HubConnectionProvider
{
    public HubConnection HubConnection { get; set; }
}
