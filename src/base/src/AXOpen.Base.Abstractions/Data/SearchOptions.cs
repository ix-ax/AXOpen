using System;
using System.Linq;

namespace AXOpen.Base.Data
{
    public enum eSearchMode
    {
        Exact,
        StartsWith,
        Contains,
    }

    public class SearchOptions
    {       
        public eSearchMode SearchMode { get; set; }
    }
}
