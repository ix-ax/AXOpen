﻿using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXSharp.Connector.S71500.WebApi;

namespace projname
{
    public static class Entry
    {
        private static readonly string TargetIp = Environment.GetEnvironmentVariable("AXTARGET"); // <- replace by your IP 
        private const string UserName = "Everybody"; //<- replace by user name you have set up in your WebAPI settings
        private const string Pass = ""; // <- Pass in the password that you have set up for the user. NOT AS PLAIN TEXT! Use user secrets instead.
        private const bool IgnoreSslErrors = true; // <- When you have your certificates in order set this to false.

#if !appconnectorname
        public static app_appconnectornameTwinController Plc { get; }
#else
        public static app_apaxappnameTwinController Plc { get; }
#endif
            = new(ConnectorAdapterBuilder.Build()
                .CreateWebApi(TargetIp, UserName, Pass, IgnoreSslErrors));
    }
}