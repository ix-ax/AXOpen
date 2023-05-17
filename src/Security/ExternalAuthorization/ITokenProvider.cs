using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Security
{
    /// <summary>
    /// Interface of generic Token provider.
    /// </summary>
    public interface ITokenProvider
    {
        void SetTokenReceivedAction(Action<string> tokenReceivedAction);
    }
}
