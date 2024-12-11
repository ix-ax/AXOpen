#define axopen_components_balluff_identification

using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXSharp.Connector.S71500.WebApi;
using Siemens.Simatic.S7.Webserver.API.Services;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Reflection;

namespace AXOpen.Components.Balluff.Identification
{
    public class ConnectionConfig
    {
        public string TargetIp { get; set; } = string.Empty;
        public string UserName { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
        public Func<HttpRequestMessage, X509Certificate2, X509Chain, SslPolicyErrors, bool>? CertificateValidationCallback { get; set; }
        public bool IgnoreSslErrors { get; set; } = true;
    }

    public class TwinConnectorSelector
    {
        public static string TargetIp { get; } = "10.10.10.120";//Environment.GetEnvironmentVariable("AXTARGET"); // <- replace by your IP 
        private static string Pass => @"123ABCDabcd$#!"; //Environment.GetEnvironmentVariable("AX_TARGET_PWD");       //Environment.GetEnvironmentVariable("AX_TARGET_PWD"); // <- Pass in the password that you have set up for the user. NOT AS PLAIN TEXT! Use user secrets instead.
        private static string UserName = "adm"; //Environment.GetEnvironmentVariable("AX_USERNAME"); //<- replace by user name you have set up in your WebAPI settings        
        private const bool IgnoreSslErrors = true; // <- When you have your certificates in order set this to false.
        private static string CertificatePath = "..\\certs\\plc_line\\plc_line.cer";

        static readonly X509Certificate2 Certificate = new X509Certificate2(CertificatePath);

        private static bool CertificateValidation(HttpRequestMessage requestMessage, X509Certificate2 certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
        {
            return certificate.Thumbprint == Certificate.Thumbprint;
        }

        public static app_axopen_components_balluff_identificationTwinController SecurePlc { get; }
            = new(ConnectorAdapterBuilder.Build()
            .CreateWebApi(TargetIp, UserName, Pass, CertificateValidation, IgnoreSslErrors));
    }

    public static class Entry
    {
        public static app_axopen_components_balluff_identificationTwinController Plc { get; } = TwinConnectorSelector.SecurePlc;
    }
}