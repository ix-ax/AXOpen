﻿using AXOpen.Base.Dialogs;
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
    public class AxoAlertDialogService : IAlertDialogService, IDisposable
    {
        private List<IAlertDialog> ToastsList { get; set; } = new List<IAlertDialog>();
        private System.Timers.Timer Timer = new System.Timers.Timer();

        public event EventHandler? AlertDialogChanged;

        public AxoAlertDialogService()
        {
            Timer.Interval = 1000;
            Timer.AutoReset = true;
            Timer.Elapsed += TimerElapsed;
            Timer.Start();
        }

        public void AddAlertDialog(eAlertDialogType type, string title, string message, int time)
        {
            ToastsList.Add(new AlertDialog(type, title, message, time));
            AlertDialogChanged?.Invoke(this, EventArgs.Empty);
        }

        public void AddAlertDialog(IAlertDialog toast)
        {
            ToastsList.Add(toast);
            AlertDialogChanged?.Invoke(this, EventArgs.Empty);
        }

        public List<IAlertDialog> GetAlertDialogs()
        {
            ClearBurntAlertDialog();
            return ToastsList;
        }

        public void RemoveAlertDialog(IAlertDialog toast)
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
