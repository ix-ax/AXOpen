using AXOpen.Base.Dialogs;
using AXOpen.Core.Blazor.AxoDialogs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Timers;

namespace AXOpen.Core.Blazor.AxoAlertDialog
{
    /// <summary>
    /// Class representing implementation of alerts in Blazor.
    /// </summary>
    public class AxoAlertService : IAlertService, IDisposable
    {
        private List<IAlertToast> ToastsList { get; set; } = new List<IAlertToast>();
        private System.Timers.Timer Timer = new System.Timers.Timer();

        public event EventHandler? AlertDialogChanged;

        public AxoAlertService()
        {
            Timer.Interval = 1000;
            Timer.AutoReset = true;
            Timer.Elapsed += TimerElapsed;
            Timer.Start();
        }

        public void AddAlertDialog(eAlertType type, string title, string message, int time)
        {
            ToastsList.Add(new AlertToast(type, title, message, time));
            AlertDialogChanged?.Invoke(this, EventArgs.Empty);
        }

        public void AddAlertDialog(IAlertToast toast)
        {
            ToastsList.Add(toast);
            AlertDialogChanged?.Invoke(this, EventArgs.Empty);
        }

        public List<IAlertToast> GetAlertDialogs()
        {
            ClearBurntAlertDialog();
            return ToastsList;
        }

        public void RemoveAlertDialog(IAlertToast toast)
        {
            ToastsList.Remove(toast);
            AlertDialogChanged?.Invoke(this, EventArgs.Empty);
        }

        public void RemoveAllAlertDialogs()
        {
            ToastsList.Clear();
            AlertDialogChanged?.Invoke(this, EventArgs.Empty);
        }

        private void ClearBurntAlertDialog()
        {
            var toastsToDelete = ToastsList.Where(item => item.TimeToBurn < DateTimeOffset.Now).ToList();
            if (toastsToDelete != null && toastsToDelete.Count > 0)
            {
                toastsToDelete.ForEach(toast => ToastsList.Remove(toast));
                AlertDialogChanged?.Invoke(this, EventArgs.Empty);
            }
        }

        private void TimerElapsed(object? sender, ElapsedEventArgs e)
        {
            ClearBurntAlertDialog();
            AlertDialogChanged?.Invoke(this, EventArgs.Empty);
        }

        public void Dispose()
        {
            if (Timer != null)
            {
                Timer.Elapsed -= TimerElapsed;
                Timer.Stop();
            }
        }
    }
}
