using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace Security
{
    public class UserAccessor : INotifyPropertyChanged
    {
        private static UserAccessor _instance;

        private AppIdentity _identity;

        public AppIdentity Identity
        {
            get => _identity;
            set
            {
                _identity = value;
                OnPropertyChanged(nameof(Identity));
            }
        }

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

        #region propertychanged
        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged([CallerMemberName] string propertyName = null) =>
                    PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));

        #endregion
    }
}