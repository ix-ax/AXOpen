using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Localization;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.Culture
{
    public static class CultureExtensions
    {
        public static CultureInfo Culture { get; set; } = CultureInfo.CurrentCulture ?? CultureInfo.DefaultThreadCurrentCulture ?? new CultureInfo("en-US");
    }
}
