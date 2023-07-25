﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Base.Dialogs
{
    public interface IAlertDialogService
    {
        public event EventHandler? AlertDialogChanged;
        public void AddAlertDialog(eAlertDialogType type, string title, string message, int time);
        public void AddAlertDialog(IAlertDialog toast);
        public List<IAlertDialog> GetAlertDialogs();
        public void RemoveAlertDialog(IAlertDialog toast);
        public void RemoveAllAlertDialogs();
    }
}
