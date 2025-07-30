using AXSharp.Connector.Localizations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using System.Security.Cryptography;
using K4os.Hash.xxHash;

namespace AXOpen.Core
{
    public partial class AxoStep : AXOpen.Core.AxoTaskLight, IAxoStep
    {
        private uint? _UID;
        public uint UID
        {
            get
            {
                if (_UID == null)
                {
                    var bytes = Encoding.UTF8.GetBytes(Symbol ?? string.Empty);
                    _UID = XXH32.DigestOf(bytes);
                }
                return _UID.Value;
            }
        }
    }
}