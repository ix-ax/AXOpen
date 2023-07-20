using AXOpen.Base.Dialogs;
using System;

namespace AXOpen.Core.Blazor.AxoAlertDialog
{
    /// <summary>
    /// Data structure representing AlertDialog.
    /// </summary>
    public class AlertDialog : IAlertDialog
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public eAlertDialogType Type { get; set; } = eAlertDialogType.Undefined;
        public string Title { get; set; } = "";
        public string Message { get; set; } = "";
        public DateTimeOffset TimeToBurn { get; set; } = DateTimeOffset.Now.AddSeconds(30);
        public DateTimeOffset Posted { get; set; } = DateTimeOffset.Now;

        public AlertDialog(eAlertDialogType type, string title, string message, int time)
        {
            Type = type;
            Title = title;
            Message = message;
            TimeToBurn = DateTimeOffset.Now.AddSeconds(time);
        }
    }
}