using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.AxoDialogs.Hubs
{
    public static class SignalRDialogMessages
    {
        public const string SERVER_SEND_DIALOG_OPEN = "SendOpen";
        public const string SERVER_SEND_DIALOG_CLOSE = "SendClose";

        public const string CLIENT_RECEIVE_DIALOG_OPEN = "ClientOpen";
        public const string CLIENT_RECEIVE_DIALOG_CLOSE = "ClientClose"; 
    }
}
