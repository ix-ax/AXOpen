using System;
using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;
using System.Collections.Generic;
using AXSharp.Connector.Localizations;
using AXSharp.Abstractions.Presentation;
using AXOpen.Core;
using AXOpen.Data;

namespace Tests_L1
{
    public partial class SharedEntityHeader : AXOpen.Data.AxoDataEntity
    {
        public OnlinerInt ComesFrom { get; }
        public OnlinerInt GoesTo { get; }
        public OnlinerString Name { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        public SharedEntityHeader(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail) : base(parent, readableTail, symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            PreConstruct(parent, readableTail, symbolTail);
            ComesFrom = @Connector.ConnectorAdapter.AdapterFactory.CreateINT(this, "ComesFrom", "ComesFrom");
            GoesTo = @Connector.ConnectorAdapter.AdapterFactory.CreateINT(this, "GoesTo", "GoesTo");
            Name = @Connector.ConnectorAdapter.AdapterFactory.CreateSTRING(this, "Name", "Name");
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async override Task<T> OnlineToPlain<T>(eAccessPriority priority = eAccessPriority.Normal)
        {
            return await (dynamic)this.OnlineToPlainAsync(priority);
        }

        public new async Task<global::Pocos.Tests_L1.SharedEntityHeader> OnlineToPlainAsync(eAccessPriority priority = eAccessPriority.Normal)
        {
            global::Pocos.Tests_L1.SharedEntityHeader plain = new global::Pocos.Tests_L1.SharedEntityHeader();
            await this.ReadAsync<IgnoreOnPocoOperation>(priority);
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
            plain.ComesFrom = ComesFrom.LastValue;
            plain.GoesTo = GoesTo.LastValue;
            plain.Name = Name.LastValue;
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public new async Task<global::Pocos.Tests_L1.SharedEntityHeader> _OnlineToPlainNoacAsync()
        {
            global::Pocos.Tests_L1.SharedEntityHeader plain = new global::Pocos.Tests_L1.SharedEntityHeader();
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
            plain.ComesFrom = ComesFrom.LastValue;
            plain.GoesTo = GoesTo.LastValue;
            plain.Name = Name.LastValue;
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        protected async Task<global::Pocos.Tests_L1.SharedEntityHeader> _OnlineToPlainNoacAsync(global::Pocos.Tests_L1.SharedEntityHeader plain)
        {
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
            plain.ComesFrom = ComesFrom.LastValue;
            plain.GoesTo = GoesTo.LastValue;
            plain.Name = Name.LastValue;
            return plain;
        }

        public async override Task PlainToOnline<T>(T plain, eAccessPriority priority = eAccessPriority.Normal)
        {
            await this.PlainToOnlineAsync((dynamic)plain, priority);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(global::Pocos.Tests_L1.SharedEntityHeader plain, eAccessPriority priority = eAccessPriority.Normal)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            ComesFrom.LethargicWrite(plain.ComesFrom);
#pragma warning restore CS0612
#pragma warning disable CS0612
            GoesTo.LethargicWrite(plain.GoesTo);
#pragma warning restore CS0612
#pragma warning disable CS0612
            Name.LethargicWrite(plain.Name);
#pragma warning restore CS0612
            return await this.WriteAsync<IgnoreOnPocoOperation>(priority);
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `PlainToOnline` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task _PlainToOnlineNoacAsync(global::Pocos.Tests_L1.SharedEntityHeader plain)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            ComesFrom.LethargicWrite(plain.ComesFrom);
#pragma warning restore CS0612
#pragma warning disable CS0612
            GoesTo.LethargicWrite(plain.GoesTo);
#pragma warning restore CS0612
#pragma warning disable CS0612
            Name.LethargicWrite(plain.Name);
#pragma warning restore CS0612
        }

        public async override Task<T> ShadowToPlain<T>()
        {
            return await (dynamic)this.ShadowToPlainAsync();
        }

        public new async Task<global::Pocos.Tests_L1.SharedEntityHeader> ShadowToPlainAsync()
        {
            global::Pocos.Tests_L1.SharedEntityHeader plain = new global::Pocos.Tests_L1.SharedEntityHeader();
            await base.ShadowToPlainAsync(plain);
            plain.ComesFrom = ComesFrom.Shadow;
            plain.GoesTo = GoesTo.Shadow;
            plain.Name = Name.Shadow;
            return plain;
        }

        protected async Task<global::Pocos.Tests_L1.SharedEntityHeader> ShadowToPlainAsync(global::Pocos.Tests_L1.SharedEntityHeader plain)
        {
            await base.ShadowToPlainAsync(plain);
            plain.ComesFrom = ComesFrom.Shadow;
            plain.GoesTo = GoesTo.Shadow;
            plain.Name = Name.Shadow;
            return plain;
        }

        public async override Task PlainToShadow<T>(T plain)
        {
            await this.PlainToShadowAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(global::Pocos.Tests_L1.SharedEntityHeader plain)
        {
            await base.PlainToShadowAsync(plain);
            ComesFrom.Shadow = plain.ComesFrom;
            GoesTo.Shadow = plain.GoesTo;
            Name.Shadow = plain.Name;
            return this.RetrievePrimitives();
        }

        ///<inheritdoc/>
        public async override Task<bool> AnyChangeAsync<T>(T plain)
        {
            return await this.DetectsAnyChangeAsync((dynamic)plain);
        }

        ///<summary>
        ///Compares if the current plain object has changed from the previous object.This method is used by the framework to determine if the object has changed and needs to be updated.
        ///[!NOTE] Any member in the hierarchy that is ignored by the compilers (e.g. when CompilerOmitAttribute is used) will not be compared, and therefore will not be detected as changed.
        ///</summary>
        public new async Task<bool> DetectsAnyChangeAsync(global::Pocos.Tests_L1.SharedEntityHeader plain, global::Pocos.Tests_L1.SharedEntityHeader latest = null)
        {
            if (latest == null)
                latest = await this._OnlineToPlainNoacAsync();
            var somethingChanged = false;
            return await Task.Run(async () =>
            {
                if (await base.DetectsAnyChangeAsync(plain))
                    return true;
                if (plain.ComesFrom != ComesFrom.LastValue)
                    somethingChanged = true;
                if (plain.GoesTo != GoesTo.LastValue)
                    somethingChanged = true;
                if (plain.Name != Name.LastValue)
                    somethingChanged = true;
                plain = latest;
                return somethingChanged;
            });
        }

        public new void Poll()
        {
            this.RetrievePrimitives().ToList().ForEach(x => x.Poll());
        }

        public new global::Pocos.Tests_L1.SharedEntityHeader CreateEmptyPoco()
        {
            return new global::Pocos.Tests_L1.SharedEntityHeader();
        }
    }
}