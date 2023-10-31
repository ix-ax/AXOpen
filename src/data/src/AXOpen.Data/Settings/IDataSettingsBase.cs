using Microsoft.AspNetCore.Identity;
using Newtonsoft.Json.Linq;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace AXOpen.Data
{
    public interface IDataSettingsBase
    {
        string SettingsName { set; get; }

        DateTime Updated { get; set; }

    }
}
