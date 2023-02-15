using Ix.Presentation.Blazor.Controls.RenderableContent;
using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ix.framework.core
{
    public partial class IxComponentView 
    {
        public object Header 
        {
            get 
            {
                object retval = new object();
                
                if (this.Component != null && this.Component.GetType() != null && this.Component.GetType().GetProperty("AlwaysVisible") != null)
                {
                    retval = this.Component.GetType().GetProperty("AlwaysVisible").GetValue(Component) ;

                }
                return retval ;
            }
        }

        public object Details
        {
            get
            {
                object retval = new object();

                if (this.Component != null && this.Component.GetType() != null && this.Component.GetType().GetProperty("Expandable") != null)
                {
                    retval = this.Component.GetType().GetProperty("Expandable").GetValue(Component);

                }
                return retval;
            }
        }
    }
}

