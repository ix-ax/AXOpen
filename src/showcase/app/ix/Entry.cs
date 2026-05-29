using AXSharp.Connector;
using AXSharp.Connector.S71500.WebApi;
using System;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;

namespace showcase
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
        public static string TargetIp { get; } = "192.168.100.1";
        private static string Pass => @"Qwerty123456+";
        private static string UserName = "admin";
        private const bool IgnoreSslErrors = true;
        private static string CertificatePath = "..\\..\\certs\\plc_line\\plc_line.cer";

        static readonly X509Certificate2 Certificate = new X509Certificate2(CertificatePath);

        private static bool CertificateValidation(HttpRequestMessage requestMessage, X509Certificate2 certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
        {
            return certificate.Thumbprint == Certificate.Thumbprint;
        }

        public static showcaseTwinController SecurePlc { get; }
            = new(ConnectorAdapterBuilder.Build()
            .CreateWebApi(TargetIp, UserName, Pass, CertificateValidation, IgnoreSslErrors));

        // public static showcaseTwinController SecurePlc { get; } = new showcaseTwinController(ConnectorAdapterBuilder.Build().CreateDummy());
    }

    public static class Entry
    {
        public static showcaseTwinController Plc { get; } = TwinConnectorSelector.SecurePlc;
    }
}
