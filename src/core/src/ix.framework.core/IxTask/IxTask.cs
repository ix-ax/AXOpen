using System;
using Ix.Connector;
using Ix.Connector.ValueTypes;
using System.Collections.Generic;
using System.Windows.Input;

namespace ix.framework.core
{
    public partial class IxTask : ICommand
    {
        /// <summary>
        /// Restore this task to ready state.
        /// </summary>
        /// <returns>Returns true when the task is restored.</returns>
        public async Task<bool> Restore()
        {
           await this.RemoteRestore.SetAsync(true);
           return true;
        }

        public bool CanExecute(object parameter = null)
        {
            return !this.IsDisabled.GetAsync().Result;
        }

        /// <summary>
        /// Executes this task.
        /// </summary>
        /// <param name="parameter"></param>
        public async void Execute(object parameter = null)
        {
            if (CanExecute())
            {
               await this.RemoteInvoke.SetAsync(true);
            }
        }

        public event EventHandler CanExecuteChanged;
    }
}