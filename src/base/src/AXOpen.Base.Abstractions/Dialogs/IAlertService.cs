using System;
using System.Collections.Generic;


namespace AXOpen.Base.Dialogs
{
    public interface IAlertService
    {
        public event EventHandler? AlertDialogChanged;
        public void AddAlertDialog(eAlertType type, string title, string message, int time);
        public void AddAlertDialog(IAlertToast toast);
        public List<IAlertToast> GetAlertDialogs();
        public void RemoveAlertDialog(IAlertToast toast);
        public void RemoveAllAlertDialogs();
    }
}
