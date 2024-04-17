using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.SignalR;
using Microsoft.AspNetCore.SignalR.Client;

namespace AXOpen.Core.Blazor.AxoDialogs.Hubs
{
    public class SignalRDialogHub : Hub
    {
        public const string HUB_URL_SUFFIX = "/dialoghub";

        [HubMethodName(SignalRDialogMessages.SERVER_SEND_DIALOG_OPEN)]
        public async Task SendOpen(string SymbolOfDialogInstance)
        {
            await Clients.All.SendAsync(SignalRDialogMessages.CLIENT_RECEIVE_DIALOG_OPEN, SymbolOfDialogInstance);
        }

        [HubMethodName(SignalRDialogMessages.SERVER_SEND_DIALOG_CLOSE)]
        public async Task SendClose(string SymbolOfDialogInstance)
        {
            await Clients.All.SendAsync(SignalRDialogMessages.CLIENT_RECEIVE_DIALOG_CLOSE, SymbolOfDialogInstance);
        }
       
    }
}
