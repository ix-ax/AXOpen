using System;
using Ix.Connector;
using Ix.Connector.ValueTypes;
using System.Collections.Generic;
using System.Windows.Input;
namespace ix.framework.core
{
    public partial class CommandTask : ICommand
    {
        public bool CanExecute(object parameter = null)
        {
            return !this.IsDisabled.GetAsync().Result;
        }

        public void Execute(object parameter)
        {
            if (CanExecute())
            {
                this.RemoteInvoke.Cyclic = true;
            }
        }

        public event EventHandler CanExecuteChanged;
    }
}