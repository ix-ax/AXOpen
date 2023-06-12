using AXSharp.Abstractions.Dialogs.AlertDialog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Timers;

namespace AXSharp.Presentation.Blazor.Controls.Dialogs.AlertDialog
{
    public class ToasterService : IDialogService, IDisposable
    {
        private List<IToast> ToastsList { get; set; } = new List<IToast>();
        private System.Timers.Timer Timer = new System.Timers.Timer();

        public event EventHandler? ToasterChanged;

        public ToasterService()
        {
            Timer.Interval = 1000;
            Timer.AutoReset = true;
            Timer.Elapsed += TimerElapsed;
            Timer.Start();
        }

        public void AddToast(string type, string title, string message, int time)
        {
            ToastsList.Add(new Toast(type, title, message, time));
            ToasterChanged?.Invoke(this, EventArgs.Empty);
        }

        public void AddToast(IToast toast)
        {
            ToastsList.Add(toast);
            ToasterChanged?.Invoke(this, EventArgs.Empty);
        }

        public List<IToast> GetToasts()
        {
            ClearBurntToast();
            return ToastsList;
        }

        public void RemoveToast(IToast toast)
        {
            ToastsList.Remove(toast);
            ToasterChanged?.Invoke(this, EventArgs.Empty);
        }

        public void RemoveAllToast()
        {
            ToastsList.Clear();
            ToasterChanged?.Invoke(this, EventArgs.Empty);
        }

        private void ClearBurntToast()
        {
            var toastsToDelete = ToastsList.Where(item => item.TimeToBurn < DateTimeOffset.Now).ToList();
            if (toastsToDelete != null && toastsToDelete.Count > 0)
            {
                toastsToDelete.ForEach(toast => ToastsList.Remove(toast));
                ToasterChanged?.Invoke(this, EventArgs.Empty);
            }
        }

        private void TimerElapsed(object? sender, ElapsedEventArgs e)
        {
            ClearBurntToast();
            ToasterChanged?.Invoke(this, EventArgs.Empty);
        }

        public void Dispose()
        {
            if (Timer != null)
            {
                Timer.Elapsed += TimerElapsed;
                Timer.Stop();
            }
        }
    }
}
