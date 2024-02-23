namespace AXOpen.Core.Blazor.AxoDialogs.Hubs
{
    public class SignalRClientReceivedMessageArgs : EventArgs
    {
        public SignalRClientReceivedMessageArgs(string symbolOfDialogInstance)
        {
            this.SymbolOfDialogInstance = symbolOfDialogInstance;
        }

        public string SymbolOfDialogInstance { get; set; }

    }
}
