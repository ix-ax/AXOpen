using Ix.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Ix.Base.Data
{
    public static class IPlainExtensions
    {
        public static void ShadowToPlain1<T>(this object obj, ITwinObject twin)
        {
            obj = twin.ShadowToPlain<T>();
        }
    }
}
