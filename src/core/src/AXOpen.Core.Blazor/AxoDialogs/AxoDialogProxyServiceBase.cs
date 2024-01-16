using AXOpen.Base.Dialogs;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    public class AxoDialogProxyServiceBase
    {
        public List<IsDialogType> DisplayedDialogs { get; set; } = new();

        public void RemoveDisplayeDialog(IsDialogType dialog)
        {
            var exist = this.DisplayedDialogs.Any((p) => p.Symbol == dialog.Symbol);
            if (exist)
            {
                this.DisplayedDialogs.Remove(dialog);
            }
        }

        public void RemoveDisplayeDialog(string dialogSymbol)
        {
            var exist = this.DisplayedDialogs.Any((p) => p.Symbol == dialogSymbol);
            if (exist)
            {
                var first = this.DisplayedDialogs.First((p) => p.Symbol == dialogSymbol);
                this.DisplayedDialogs.Remove(first);
            }
        }

        public bool IsInListOfDisplayeDialog(string dialogSymbol)
        {
            return  this.DisplayedDialogs.Any((p) => p.Symbol == dialogSymbol);
        }


        protected IEnumerable<T> GetDescendants<T>(ITwinObject obj, IList<T> children = null) where T : class
        {
            children = children != null ? children : new List<T>();

            if (obj != null)
            {
                foreach (var child in obj.GetChildren())
                {
                    var ch = child as T;
                    if (ch != null)
                    {
                        children.Add(ch);
                    }

                    GetDescendants<T>(child, children);
                }
            }

            return children;
        }
    }
}
