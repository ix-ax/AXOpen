using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata;
using System.Text;
using System.Threading.Tasks;
using AXSharp.Connector;
using AXOpen.ToolBox.Extensions;
namespace AXOpen.Messaging.Static
{
    public class AxoMessageProvider
    {
        private AxoMessageProvider(IEnumerable<ITwinObject> observedObjects)
        {
            this.ObservedObjects = observedObjects;
        }

        public int? MessagesCount {
            get
            {
                return this.Messengers?.Count(p => p.State > eAxoMessengerState.Idle && p.State != eAxoMessengerState.NotActiveWatingAckn);
            }
        } 

        private IEnumerable<ITwinObject> ObservedObjects { get; }

        public IEnumerable<ITwinElement>? Observables 
        {
            get
            {
                return this.Messengers?.SelectMany(p => new ITwinElement[] { p.MessengerState });
            }
        }

        private AxoMessenger[]? _messengers;
        
        public AxoMessenger[]? Messengers
        {
            get
            {
                if (_messengers == null)
                {
                    var retVal = new List<AxoMessenger>();
                    foreach (var observedObject in ObservedObjects)
                    {
                        retVal.AddRange(observedObject.GetChildren().Flatten(p => p.GetChildren())
                            .OfType<AxoMessenger>());
                    }

                    _messengers = retVal.ToArray();
                }

                return _messengers;
            }
        }

        public static AxoMessageProvider Create(IEnumerable<ITwinObject> observedObjects)
        {
            return new AxoMessageProvider(observedObjects); 
        }
    }
}
