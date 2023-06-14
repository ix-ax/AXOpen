using System;
using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;
using System.Collections.Generic;
using AXOpen;
using System.ComponentModel;
using System.Security.Principal;

namespace AXOpen.Core
{
    public partial class AxoTask 
    {
        /// <summary>
        /// Restore this task to ready state.
        /// </summary>
        public void Restore()
        {
           this.RemoteRestore.Cyclic = true;
        }

        public void Abort()
        {
            RemoteAbort.Cyclic = true;
        }

        public void ResumeTask()
        {
            RemoteResume.Cyclic = true;
        }

        /// <summary>
        /// Executes this task.
        /// </summary>
        /// <param name="parameter"></param>
        public async Task ExecuteAsync(object? parameter = null)
        {
            await this.RemoteInvoke.SetAsync(true);
        }
    }
}