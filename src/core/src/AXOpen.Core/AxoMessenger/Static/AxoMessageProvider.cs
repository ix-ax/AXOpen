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
    /// <summary>
    /// Represents a provider for AxoMessages.
    /// </summary>
    public class AxoMessageProvider
    {
        private AxoMessageProvider(IEnumerable<ITwinObject> observedObjects)
        {
            this.ObservedObjects = observedObjects;
        }

        private IEnumerable<ITwinObject> ObservedObjects { get; }

        /// <summary>
        /// Gets the number of active messages.
        /// </summary>
        /// <remarks>
        /// This property counts the number of messages that are currently active.
        /// An active message is defined as a message belonging to a Messenger that has a state other than Idle or NotActiveWatingAckn.
        /// </remarks>
        public int? ActiveMessagesCount
        {
            get
            {
                return this.Messengers?.Count(p => p.State > eAxoMessengerState.Idle && p.State != eAxoMessengerState.NotActiveWaitingAckn);
            }
        }


        /// <summary>
        /// Gets the count of relevant messages based on the state of Messengers.
        /// </summary>
        /// <remarks>
        /// The RelevantMessagesCount property will return the number of messengers that have a state greater than eAxoMessengerState.Idle.
        /// Messengers is a collection of objects that represents messengers.
        /// </remarks>
        /// <returns>An integer that represents the count of relevant messages.</returns>
        public int? RelevantMessagesCount
        {
            get
            {
                return this.Messengers?.Count(p => p.State > eAxoMessengerState.Idle);
            }
        }
        
        /// <summary>
        /// Represents a class with a property to access a collection of observables.
        /// </summary>
        public IEnumerable<ITwinElement>? Observables 
        {
            get
            {
                return this.Messengers?.SelectMany(p => new ITwinElement[] { p.MessengerState });
            }
        }
        
        private AxoMessenger[]? _messengers;

        /// <summary>
        /// Gets the list of AxoMessengers associated with the observed objects.
        /// </summary>
        /// <remarks>
        /// This property returns an array of AxoMessenger objects which are
        /// associated with the observed objects. If no AxoMessengers are found,
        /// an empty array is returned.
        /// </remarks>
        /// <value>
        /// An array of AxoMessenger objects associated with the observed objects.
        /// If no AxoMessengers are found, an empty array is returned.
        /// </value>
        public AxoMessenger[]? Messengers
        {
            get
            {
                if (_messengers == null)
                {
                    var retVal = new List<AxoMessenger>();
                    foreach (var observedObject in ObservedObjects.Where(p => p != null))
                    {
                        retVal.AddRange(observedObject.GetChildren().Flatten(p => p.GetChildren())
                            .OfType<AxoMessenger>());
                    }

                    _messengers = retVal.ToArray();
                }

                return _messengers ?? new AxoMessenger[0];
            }
        }

        /// <summary>
        /// Creates a new instance of AxoMessageProvider with the specified observed objects.
        /// </summary>
        /// <param name="observedObjects">The collection of observed objects.</param>
        /// <returns>A new instance of the AxoMessageProvider class.</returns>
        public static AxoMessageProvider Create(IEnumerable<ITwinObject> observedObjects)
        {
            return new AxoMessageProvider(observedObjects); 
        }
    }
}
