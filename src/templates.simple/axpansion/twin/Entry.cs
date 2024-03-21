//#define WEBAPI_3_1
// ixsharpblazor
// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/axsharp/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/axsharp/blob/dev/LICENSE
// Third party licenses: https://github.com/ix-ax/axsharp/blob/master/notices.md

using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXSharp.Connector.S71500.WebApi;

namespace axosimple
{
    public static class Entry
    {
        public static string TargetIp { get; } = Environment.GetEnvironmentVariable("AXTARGET"); // <- replace by your IP 
        private const string UserName = "Everybody"; //<- replace by user name you have set up in your WebAPI settings
        
#if WEBAPI_3_1
        private static string Pass => Environment.GetEnvironmentVariable("AX_TARGET_PWD") ?? string.Empty; // <- Pass in the password that you have set up for the user. NOT AS PLAIN TEXT! Use user secrets instead.
#else
        private static string Pass => string.Empty; // <- Pass in the password that you have set up for the user. NOT AS PLAIN TEXT! Use user secrets instead.
#endif
        
        private const bool IgnoreSslErrors = true; // <- When you have your certificates in order set this to false.

        // public static axosimpleTwinController Plc { get; } 
        //     = new (ConnectorAdapterBuilder.Build()
        //         .CreateWebApi(TargetIp, UserName, Pass, IgnoreSslErrors));
        
        
        public static axosimpleTwinController Plc { get; } 
            = new (ConnectorAdapterBuilder.Build()
                .CreateWebApi(TargetIp, "Everybody", string.Empty, IgnoreSslErrors));
    }
    
}