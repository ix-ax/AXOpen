using System.Runtime.Serialization;
using System.Security;
using System.Security.Principal;
using static System.Formats.Asn1.AsnWriter;

namespace BlazorAuthApp.Identity
{
    public delegate void OnUserAuthentication(string username);
}
