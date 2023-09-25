using Microsoft.AspNetCore.SignalR.Client;
using clientchat.ClientIdentification;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;

namespace clientchat.Pages;

public partial class Index
{
    [Inject]
    public HubConnectionProvider HubConnectionProvider { get; set; }
    [Inject]
    public AuthenticationStateProvider AuthenticationStateProvider { get; set; }

    private List<Message> messages = new List<Message>();
    private string? toUserInput;
    private string? messageInput;
    private string? identityUserName;
    private string? userToShowConnections;
    private Dictionary<string, int> connectionsCounts = new();
    private List<string> usersConnections = new();

    protected override async Task OnInitializedAsync()
    {
        var context = await AuthenticationStateProvider.GetAuthenticationStateAsync();
        identityUserName = context.User.Identity.Name;

        HubConnectionProvider.HubConnection.On<string, string>("ReceiveMessage", (sender, message) =>
        {
            // show received message in chat
            messages.Add(new Message(sender, message, false));
            InvokeAsync(StateHasChanged);
        });

        HubConnectionProvider.HubConnection.On<Dictionary<string, int>>("ReceiveConnectionsCounts", (connectionsCounts) =>
        {
            this.connectionsCounts = connectionsCounts;
            InvokeAsync(StateHasChanged);
        });

        HubConnectionProvider.HubConnection.On<List<string>>("ReceiveUserConnections", (connections) =>
        {
            usersConnections = connections;
            InvokeAsync(StateHasChanged);
        });

        await base.OnInitializedAsync();
    }

    private async Task Send()
    {
        if (HubConnectionProvider.HubConnection is not null)
        {
            // For visualisation purposes, show sent message in chat.
            // Only on the screen of the client who sent the message not all clients with
            // sender user logged in.
            messages.Add(new Message(identityUserName ?? "Anonymous", messageInput, true));
            InvokeAsync(StateHasChanged);

            await HubConnectionProvider.HubConnection.SendAsync("SendMessage", toUserInput, messageInput);
        }
    }

    private async Task ShowConnected()
    {
        await HubConnectionProvider.HubConnection.SendAsync("RequestConnectionsCounts");
    }

    private async Task ShowConnections(string user)
    {
        userToShowConnections = user;
        await HubConnectionProvider.HubConnection.SendAsync("RequestUserConnections", user);
    }

    public bool IsConnected =>
        HubConnectionProvider.HubConnection?.State == HubConnectionState.Connected;
}

public class Message
{
    public string Sender { get; set; }
    public string Text { get; set; }
    public bool IsAuthor { get; set; }

    public Message(string sender, string text)
    {
        Sender = sender;
        Text = text;
    }

    public Message(string sender, string text, bool isAuthor)
    {
        Sender = sender;
        Text = text;
        IsAuthor = isAuthor;
    }

    public string ResolveMessageColor() => IsAuthor ? "primary" : "warning";

    public string ResolveMessageAlignment() => IsAuthor ? "end" : "start";
}
