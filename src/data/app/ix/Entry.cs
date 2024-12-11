using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXSharp.Connector.S71500.WebApi;
using System.Net.Security;
using System.Reflection;
using System.Security.Cryptography.X509Certificates;

namespace librarytemplate
{

    public static class Entry
    {
        public static string TargetIp { get; } = Environment.GetEnvironmentVariable("AXTARGET"); // <- replace by your IP 
        private static string Pass => Environment.GetEnvironmentVariable("AX_TARGET_PWD"); // <- Pass in the password that you have set up for the user. NOT AS PLAIN TEXT! Use user secrets instead.
        private static string UserName = Environment.GetEnvironmentVariable("AX_USERNAME"); //<- replace by user name you have set up in your WebAPI settings        
        private const bool IgnoreSslErrors = true; // <- When you have your certificates in order set this to false.
        private static string CertificatePath = "certs\\plc_line\\plc_line.cer";

        static string GetCertPath()
        {
            var fp = new FileInfo(Path.Combine(Assembly.GetExecutingAssembly().Location));
            return Path.Combine(fp.DirectoryName, CertificatePath);
        }

        static readonly X509Certificate2 Certificate = new X509Certificate2(GetCertPath());

        private static bool CertificateValidation(HttpRequestMessage requestMessage, X509Certificate2 certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
        {
            return certificate.Thumbprint == Certificate.Thumbprint;
        }

        public static axopen_data_appTwinController Plc { get; }
            = new(ConnectorAdapterBuilder.Build()
            .CreateWebApi(TargetIp, UserName, Pass, CertificateValidation, IgnoreSslErrors));

    }

}