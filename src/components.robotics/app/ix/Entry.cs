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

namespace AXOpen.Components.Robotics
{
    public static class Entry
    {
        static Entry()
        {
            if (IgnoreSslErrors)
            {
                ServerCertificateCallback.CertificateCallback =
                    (sender, cert, chain, sslPolicyErrors) => true;
            }

            Plc = new(ConnectorAdapterBuilder.Build()
                .CreateWebApi(TargetIp, UserName, Pass, CertificateValidation));
        }

        // Load your custom certificate (example from a file)
        static X509Certificate2 customCertificate = new X509Certificate2("..\\certs\\plc_line\\plc_line.cer");

        // Implement the delegate
        private static bool CertificateValidation(HttpRequestMessage requestMessage, X509Certificate2 certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
        {
            return certificate.Thumbprint == customCertificate.Thumbprint;
        }

        private static readonly string TargetIp = Environment.GetEnvironmentVariable("AXTARGET"); // <- replace by your IP 
        private static string UserName = Environment.GetEnvironmentVariable("AX_USERNAME"); //<- replace by user name you have set up in your WebAPI settings
        private static string Pass = Environment.GetEnvironmentVariable("MY_VERY_STRONG_PASSWORD"); // <- Pass in the password that you have set up for the user. NOT AS PLAIN TEXT! Use user secrets instead.
        private const bool IgnoreSslErrors = true; // <- When you have your certificates in order set this to false.

        public static app_axopen_components_roboticsTwinController Plc { get; }
        //= new(ConnectorAdapterBuilder.Build()
        //    .CreateWebApi(TargetIp, UserName, Pass, IgnoreSslErrors));
    }

}