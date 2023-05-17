using Sparrow;
using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Security
{
    public class ExternalTokenAuthorization : ExternalAuthorization
    {
        private readonly ITokenProvider _tokenProvider;

        /// <summary>
        /// Creates new instance of External token authentication.
        /// </summary>
        /// <param name="tokenProvider">Token provider.</param>
        public ExternalTokenAuthorization(ITokenProvider tokenProvider, bool deauthenticateWhenSame)
        {
            this._tokenProvider = tokenProvider;
            this._tokenProvider.SetTokenReceivedAction((token) => this.RequestAuthorization(token, deauthenticateWhenSame));
        }

        public static ExternalAuthorization CreateComReader(string portName, int baudRate = 9600, int dataBits = 8, StopBits stopBits = StopBits.One, Parity parity = Parity.None, bool deauthenticateWhenSame = true)
        {
            throw new NotImplementedException();
        }

        public static ExternalAuthorization CreatePlcTokenReader(string tokenValue, bool tokenPresence, bool deauthenticateWhenSame = true)
        {
            throw new NotImplementedException();
        }
    }
}
