using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace Security
{
    public class UserAccessor
    {
        private static UserAccessor _instance;

        public AppIdentity Identity { get; set; }

        public static UserAccessor Instance
        {
            get
            {
                if (_instance == null)
                    _instance = new UserAccessor();
                return _instance;
            }
        }

        private UserAccessor()
        {
        }
    }
}