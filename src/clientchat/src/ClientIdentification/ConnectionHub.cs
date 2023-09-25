using Microsoft.AspNetCore.SignalR;
using Microsoft.IdentityModel.Tokens;

namespace clientchat.ClientIdentification;

public class ConnectionHub : Hub
{
    private readonly static ConnectionMapping<string> _connections = new();

    public async override Task OnConnectedAsync()
    {
        string name = Context.User.Identity.Name;

        if (name != null)
        {
            _connections.Add(name, Context.ConnectionId);
        }

        await base.OnConnectedAsync();
    }

    public async override Task OnDisconnectedAsync(Exception? exception)
    {
        string name = Context.User.Identity.Name;

        if (name != null)
        {
            _connections.Remove(name, Context.ConnectionId);
        }

        await base.OnDisconnectedAsync(exception);
    }

    public async Task SendMessage(string receiver, string message)
    {
        var sender = Context.User.Identity.Name ?? "Anonymous";
        var receiverConnections = _connections.GetConnections(receiver);

        if (receiverConnections.IsNullOrEmpty())
        {
            await Clients.All.SendAsync("ReceiveMessage", sender, message);
        }
        else
        {
            await Clients.Clients(receiverConnections.ToList()).SendAsync("ReceiveMessage", sender, message);
        }
    }

    public async Task RequestConnectionsCounts()
    {
        await Clients.Caller.SendAsync("ReceiveConnectionsCounts", _connections.GetConnectionsCounts());
    }

    public async Task RequestUserConnections(string user)
    {
          await Clients.Caller.SendAsync("ReceiveUserConnections", _connections.GetConnections(user));
    }
}
