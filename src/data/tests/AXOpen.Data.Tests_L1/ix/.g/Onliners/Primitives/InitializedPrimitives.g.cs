using System;
using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;
using System.Collections.Generic;
using AXSharp.Connector.Localizations;
using AXSharp.Abstractions.Presentation;
using AXOpen.Core;
using AXOpen;
using AXOpen.Data;

namespace Tests_L1.Primitives
{
    public partial class InitializedPrimitives : AXSharp.Connector.ITwinObject
    {
        public OnlinerBool v_BOOL { get; }
        public OnlinerByte v_BYTE { get; }
        public OnlinerWord v_WORD { get; }
        public OnlinerDWord v_DWORD { get; }
        public OnlinerLWord v_LWORD { get; }
        public OnlinerSInt v_SINTMin { get; }
        public OnlinerSInt v_SINTMax { get; }
        public OnlinerInt v_INT { get; }
        public OnlinerDInt v_DINT { get; }
        public OnlinerLInt v_LINT { get; }
        public OnlinerUSInt v_USINT { get; }
        public OnlinerUInt v_UINT { get; }
        public OnlinerUDInt v_UDINT { get; }
        public OnlinerULInt v_ULINT { get; }
        public OnlinerReal v_REAL { get; }
        public OnlinerLReal v_LREAL { get; }
        public OnlinerTime v_TIME { get; }
        public OnlinerLTime v_LTIME { get; }
        public OnlinerDate v_DATE { get; }
        public OnlinerDate v_LDATE { get; }
        public OnlinerTimeOfDay v_TIME_OF_DAY { get; }
        public OnlinerLTimeOfDay v_LTIME_OF_DAY { get; }
        public OnlinerDateTime v_DATE_AND_TIME { get; }
        public OnlinerLDateTime v_LDATE_AND_TIME { get; }
        public OnlinerChar v_CHAR { get; }
        public OnlinerWChar v_WCHAR { get; }
        public OnlinerString v_STRING { get; }
        public OnlinerWString v_WSTRING { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        public InitializedPrimitives(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            this.@SymbolTail = symbolTail;
            this.@Connector = parent.GetConnector();
            this.@Parent = parent;
            HumanReadable = AXSharp.Connector.Connector.CreateHumanReadable(parent.HumanReadable, readableTail);
            PreConstruct(parent, readableTail, symbolTail);
            v_BOOL = @Connector.ConnectorAdapter.AdapterFactory.CreateBOOL(this, "v_BOOL", "v_BOOL");
            v_BYTE = @Connector.ConnectorAdapter.AdapterFactory.CreateBYTE(this, "v_BYTE", "v_BYTE");
            v_WORD = @Connector.ConnectorAdapter.AdapterFactory.CreateWORD(this, "v_WORD", "v_WORD");
            v_DWORD = @Connector.ConnectorAdapter.AdapterFactory.CreateDWORD(this, "v_DWORD", "v_DWORD");
            v_LWORD = @Connector.ConnectorAdapter.AdapterFactory.CreateLWORD(this, "v_LWORD", "v_LWORD");
            v_SINTMin = @Connector.ConnectorAdapter.AdapterFactory.CreateSINT(this, "v_SINTMin", "v_SINTMin");
            v_SINTMax = @Connector.ConnectorAdapter.AdapterFactory.CreateSINT(this, "v_SINTMax", "v_SINTMax");
            v_INT = @Connector.ConnectorAdapter.AdapterFactory.CreateINT(this, "v_INT", "v_INT");
            v_DINT = @Connector.ConnectorAdapter.AdapterFactory.CreateDINT(this, "v_DINT", "v_DINT");
            v_LINT = @Connector.ConnectorAdapter.AdapterFactory.CreateLINT(this, "v_LINT", "v_LINT");
            v_USINT = @Connector.ConnectorAdapter.AdapterFactory.CreateUSINT(this, "v_USINT", "v_USINT");
            v_UINT = @Connector.ConnectorAdapter.AdapterFactory.CreateUINT(this, "v_UINT", "v_UINT");
            v_UDINT = @Connector.ConnectorAdapter.AdapterFactory.CreateUDINT(this, "v_UDINT", "v_UDINT");
            v_ULINT = @Connector.ConnectorAdapter.AdapterFactory.CreateULINT(this, "v_ULINT", "v_ULINT");
            v_REAL = @Connector.ConnectorAdapter.AdapterFactory.CreateREAL(this, "v_REAL", "v_REAL");
            v_LREAL = @Connector.ConnectorAdapter.AdapterFactory.CreateLREAL(this, "v_LREAL", "v_LREAL");
            v_TIME = @Connector.ConnectorAdapter.AdapterFactory.CreateTIME(this, "v_TIME", "v_TIME");
            v_LTIME = @Connector.ConnectorAdapter.AdapterFactory.CreateLTIME(this, "v_LTIME", "v_LTIME");
            v_DATE = @Connector.ConnectorAdapter.AdapterFactory.CreateDATE(this, "v_DATE", "v_DATE");
            v_LDATE = @Connector.ConnectorAdapter.AdapterFactory.CreateLDATE(this, "v_LDATE", "v_LDATE");
            v_TIME_OF_DAY = @Connector.ConnectorAdapter.AdapterFactory.CreateTIME_OF_DAY(this, "v_TIME_OF_DAY", "v_TIME_OF_DAY");
            v_LTIME_OF_DAY = @Connector.ConnectorAdapter.AdapterFactory.CreateLTIME_OF_DAY(this, "v_LTIME_OF_DAY", "v_LTIME_OF_DAY");
            v_DATE_AND_TIME = @Connector.ConnectorAdapter.AdapterFactory.CreateDATE_AND_TIME(this, "v_DATE_AND_TIME", "v_DATE_AND_TIME");
            v_LDATE_AND_TIME = @Connector.ConnectorAdapter.AdapterFactory.CreateLDATE_AND_TIME(this, "v_LDATE_AND_TIME", "v_LDATE_AND_TIME");
            v_CHAR = @Connector.ConnectorAdapter.AdapterFactory.CreateCHAR(this, "v_CHAR", "v_CHAR");
            v_WCHAR = @Connector.ConnectorAdapter.AdapterFactory.CreateWCHAR(this, "v_WCHAR", "v_WCHAR");
            v_STRING = @Connector.ConnectorAdapter.AdapterFactory.CreateSTRING(this, "v_STRING", "v_STRING");
            v_WSTRING = @Connector.ConnectorAdapter.AdapterFactory.CreateWSTRING(this, "v_WSTRING", "v_WSTRING");
            parent.AddChild(this);
            parent.AddKid(this);
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async virtual Task<T> OnlineToPlain<T>(eAccessPriority priority = eAccessPriority.Normal)
        {
            return await (dynamic)this.OnlineToPlainAsync(priority);
        }

        public async Task<global::Pocos.Tests_L1.Primitives.InitializedPrimitives> OnlineToPlainAsync(eAccessPriority priority = eAccessPriority.Normal)
        {
            global::Pocos.Tests_L1.Primitives.InitializedPrimitives plain = new global::Pocos.Tests_L1.Primitives.InitializedPrimitives();
            await this.ReadAsync<IgnoreOnPocoOperation>(priority);
            plain.v_BOOL = v_BOOL.LastValue;
            plain.v_BYTE = v_BYTE.LastValue;
            plain.v_WORD = v_WORD.LastValue;
            plain.v_DWORD = v_DWORD.LastValue;
            plain.v_LWORD = v_LWORD.LastValue;
            plain.v_SINTMin = v_SINTMin.LastValue;
            plain.v_SINTMax = v_SINTMax.LastValue;
            plain.v_INT = v_INT.LastValue;
            plain.v_DINT = v_DINT.LastValue;
            plain.v_LINT = v_LINT.LastValue;
            plain.v_USINT = v_USINT.LastValue;
            plain.v_UINT = v_UINT.LastValue;
            plain.v_UDINT = v_UDINT.LastValue;
            plain.v_ULINT = v_ULINT.LastValue;
            plain.v_REAL = v_REAL.LastValue;
            plain.v_LREAL = v_LREAL.LastValue;
            plain.v_TIME = v_TIME.LastValue;
            plain.v_LTIME = v_LTIME.LastValue;
            plain.v_DATE = v_DATE.LastValue;
            plain.v_LDATE = v_LDATE.LastValue;
            plain.v_TIME_OF_DAY = v_TIME_OF_DAY.LastValue;
            plain.v_LTIME_OF_DAY = v_LTIME_OF_DAY.LastValue;
            plain.v_DATE_AND_TIME = v_DATE_AND_TIME.LastValue;
            plain.v_LDATE_AND_TIME = v_LDATE_AND_TIME.LastValue;
            plain.v_CHAR = v_CHAR.LastValue;
            plain.v_WCHAR = v_WCHAR.LastValue;
            plain.v_STRING = v_STRING.LastValue;
            plain.v_WSTRING = v_WSTRING.LastValue;
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task<global::Pocos.Tests_L1.Primitives.InitializedPrimitives> _OnlineToPlainNoacAsync()
        {
            global::Pocos.Tests_L1.Primitives.InitializedPrimitives plain = new global::Pocos.Tests_L1.Primitives.InitializedPrimitives();
            plain.v_BOOL = v_BOOL.LastValue;
            plain.v_BYTE = v_BYTE.LastValue;
            plain.v_WORD = v_WORD.LastValue;
            plain.v_DWORD = v_DWORD.LastValue;
            plain.v_LWORD = v_LWORD.LastValue;
            plain.v_SINTMin = v_SINTMin.LastValue;
            plain.v_SINTMax = v_SINTMax.LastValue;
            plain.v_INT = v_INT.LastValue;
            plain.v_DINT = v_DINT.LastValue;
            plain.v_LINT = v_LINT.LastValue;
            plain.v_USINT = v_USINT.LastValue;
            plain.v_UINT = v_UINT.LastValue;
            plain.v_UDINT = v_UDINT.LastValue;
            plain.v_ULINT = v_ULINT.LastValue;
            plain.v_REAL = v_REAL.LastValue;
            plain.v_LREAL = v_LREAL.LastValue;
            plain.v_TIME = v_TIME.LastValue;
            plain.v_LTIME = v_LTIME.LastValue;
            plain.v_DATE = v_DATE.LastValue;
            plain.v_LDATE = v_LDATE.LastValue;
            plain.v_TIME_OF_DAY = v_TIME_OF_DAY.LastValue;
            plain.v_LTIME_OF_DAY = v_LTIME_OF_DAY.LastValue;
            plain.v_DATE_AND_TIME = v_DATE_AND_TIME.LastValue;
            plain.v_LDATE_AND_TIME = v_LDATE_AND_TIME.LastValue;
            plain.v_CHAR = v_CHAR.LastValue;
            plain.v_WCHAR = v_WCHAR.LastValue;
            plain.v_STRING = v_STRING.LastValue;
            plain.v_WSTRING = v_WSTRING.LastValue;
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        protected async Task<global::Pocos.Tests_L1.Primitives.InitializedPrimitives> _OnlineToPlainNoacAsync(global::Pocos.Tests_L1.Primitives.InitializedPrimitives plain)
        {
            plain.v_BOOL = v_BOOL.LastValue;
            plain.v_BYTE = v_BYTE.LastValue;
            plain.v_WORD = v_WORD.LastValue;
            plain.v_DWORD = v_DWORD.LastValue;
            plain.v_LWORD = v_LWORD.LastValue;
            plain.v_SINTMin = v_SINTMin.LastValue;
            plain.v_SINTMax = v_SINTMax.LastValue;
            plain.v_INT = v_INT.LastValue;
            plain.v_DINT = v_DINT.LastValue;
            plain.v_LINT = v_LINT.LastValue;
            plain.v_USINT = v_USINT.LastValue;
            plain.v_UINT = v_UINT.LastValue;
            plain.v_UDINT = v_UDINT.LastValue;
            plain.v_ULINT = v_ULINT.LastValue;
            plain.v_REAL = v_REAL.LastValue;
            plain.v_LREAL = v_LREAL.LastValue;
            plain.v_TIME = v_TIME.LastValue;
            plain.v_LTIME = v_LTIME.LastValue;
            plain.v_DATE = v_DATE.LastValue;
            plain.v_LDATE = v_LDATE.LastValue;
            plain.v_TIME_OF_DAY = v_TIME_OF_DAY.LastValue;
            plain.v_LTIME_OF_DAY = v_LTIME_OF_DAY.LastValue;
            plain.v_DATE_AND_TIME = v_DATE_AND_TIME.LastValue;
            plain.v_LDATE_AND_TIME = v_LDATE_AND_TIME.LastValue;
            plain.v_CHAR = v_CHAR.LastValue;
            plain.v_WCHAR = v_WCHAR.LastValue;
            plain.v_STRING = v_STRING.LastValue;
            plain.v_WSTRING = v_WSTRING.LastValue;
            return plain;
        }

        public async virtual Task PlainToOnline<T>(T plain, eAccessPriority priority = eAccessPriority.Normal)
        {
            await this.PlainToOnlineAsync((dynamic)plain, priority);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(global::Pocos.Tests_L1.Primitives.InitializedPrimitives plain, eAccessPriority priority = eAccessPriority.Normal)
        {
#pragma warning disable CS0612
            v_BOOL.LethargicWrite(plain.v_BOOL);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_BYTE.LethargicWrite(plain.v_BYTE);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_WORD.LethargicWrite(plain.v_WORD);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_DWORD.LethargicWrite(plain.v_DWORD);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_LWORD.LethargicWrite(plain.v_LWORD);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_SINTMin.LethargicWrite(plain.v_SINTMin);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_SINTMax.LethargicWrite(plain.v_SINTMax);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_INT.LethargicWrite(plain.v_INT);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_DINT.LethargicWrite(plain.v_DINT);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_LINT.LethargicWrite(plain.v_LINT);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_USINT.LethargicWrite(plain.v_USINT);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_UINT.LethargicWrite(plain.v_UINT);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_UDINT.LethargicWrite(plain.v_UDINT);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_ULINT.LethargicWrite(plain.v_ULINT);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_REAL.LethargicWrite(plain.v_REAL);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_LREAL.LethargicWrite(plain.v_LREAL);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_TIME.LethargicWrite(plain.v_TIME);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_LTIME.LethargicWrite(plain.v_LTIME);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_DATE.LethargicWrite(plain.v_DATE);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_LDATE.LethargicWrite(plain.v_LDATE);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_TIME_OF_DAY.LethargicWrite(plain.v_TIME_OF_DAY);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_LTIME_OF_DAY.LethargicWrite(plain.v_LTIME_OF_DAY);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_DATE_AND_TIME.LethargicWrite(plain.v_DATE_AND_TIME);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_LDATE_AND_TIME.LethargicWrite(plain.v_LDATE_AND_TIME);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_CHAR.LethargicWrite(plain.v_CHAR);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_WCHAR.LethargicWrite(plain.v_WCHAR);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_STRING.LethargicWrite(plain.v_STRING);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_WSTRING.LethargicWrite(plain.v_WSTRING);
#pragma warning restore CS0612
            return await this.WriteAsync<IgnoreOnPocoOperation>(priority);
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `PlainToOnline` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task _PlainToOnlineNoacAsync(global::Pocos.Tests_L1.Primitives.InitializedPrimitives plain)
        {
#pragma warning disable CS0612
            v_BOOL.LethargicWrite(plain.v_BOOL);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_BYTE.LethargicWrite(plain.v_BYTE);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_WORD.LethargicWrite(plain.v_WORD);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_DWORD.LethargicWrite(plain.v_DWORD);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_LWORD.LethargicWrite(plain.v_LWORD);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_SINTMin.LethargicWrite(plain.v_SINTMin);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_SINTMax.LethargicWrite(plain.v_SINTMax);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_INT.LethargicWrite(plain.v_INT);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_DINT.LethargicWrite(plain.v_DINT);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_LINT.LethargicWrite(plain.v_LINT);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_USINT.LethargicWrite(plain.v_USINT);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_UINT.LethargicWrite(plain.v_UINT);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_UDINT.LethargicWrite(plain.v_UDINT);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_ULINT.LethargicWrite(plain.v_ULINT);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_REAL.LethargicWrite(plain.v_REAL);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_LREAL.LethargicWrite(plain.v_LREAL);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_TIME.LethargicWrite(plain.v_TIME);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_LTIME.LethargicWrite(plain.v_LTIME);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_DATE.LethargicWrite(plain.v_DATE);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_LDATE.LethargicWrite(plain.v_LDATE);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_TIME_OF_DAY.LethargicWrite(plain.v_TIME_OF_DAY);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_LTIME_OF_DAY.LethargicWrite(plain.v_LTIME_OF_DAY);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_DATE_AND_TIME.LethargicWrite(plain.v_DATE_AND_TIME);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_LDATE_AND_TIME.LethargicWrite(plain.v_LDATE_AND_TIME);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_CHAR.LethargicWrite(plain.v_CHAR);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_WCHAR.LethargicWrite(plain.v_WCHAR);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_STRING.LethargicWrite(plain.v_STRING);
#pragma warning restore CS0612
#pragma warning disable CS0612
            v_WSTRING.LethargicWrite(plain.v_WSTRING);
#pragma warning restore CS0612
        }

        public async virtual Task<T> ShadowToPlain<T>()
        {
            return await (dynamic)this.ShadowToPlainAsync();
        }

        public async Task<global::Pocos.Tests_L1.Primitives.InitializedPrimitives> ShadowToPlainAsync()
        {
            global::Pocos.Tests_L1.Primitives.InitializedPrimitives plain = new global::Pocos.Tests_L1.Primitives.InitializedPrimitives();
            plain.v_BOOL = v_BOOL.Shadow;
            plain.v_BYTE = v_BYTE.Shadow;
            plain.v_WORD = v_WORD.Shadow;
            plain.v_DWORD = v_DWORD.Shadow;
            plain.v_LWORD = v_LWORD.Shadow;
            plain.v_SINTMin = v_SINTMin.Shadow;
            plain.v_SINTMax = v_SINTMax.Shadow;
            plain.v_INT = v_INT.Shadow;
            plain.v_DINT = v_DINT.Shadow;
            plain.v_LINT = v_LINT.Shadow;
            plain.v_USINT = v_USINT.Shadow;
            plain.v_UINT = v_UINT.Shadow;
            plain.v_UDINT = v_UDINT.Shadow;
            plain.v_ULINT = v_ULINT.Shadow;
            plain.v_REAL = v_REAL.Shadow;
            plain.v_LREAL = v_LREAL.Shadow;
            plain.v_TIME = v_TIME.Shadow;
            plain.v_LTIME = v_LTIME.Shadow;
            plain.v_DATE = v_DATE.Shadow;
            plain.v_LDATE = v_LDATE.Shadow;
            plain.v_TIME_OF_DAY = v_TIME_OF_DAY.Shadow;
            plain.v_LTIME_OF_DAY = v_LTIME_OF_DAY.Shadow;
            plain.v_DATE_AND_TIME = v_DATE_AND_TIME.Shadow;
            plain.v_LDATE_AND_TIME = v_LDATE_AND_TIME.Shadow;
            plain.v_CHAR = v_CHAR.Shadow;
            plain.v_WCHAR = v_WCHAR.Shadow;
            plain.v_STRING = v_STRING.Shadow;
            plain.v_WSTRING = v_WSTRING.Shadow;
            return plain;
        }

        protected async Task<global::Pocos.Tests_L1.Primitives.InitializedPrimitives> ShadowToPlainAsync(global::Pocos.Tests_L1.Primitives.InitializedPrimitives plain)
        {
            plain.v_BOOL = v_BOOL.Shadow;
            plain.v_BYTE = v_BYTE.Shadow;
            plain.v_WORD = v_WORD.Shadow;
            plain.v_DWORD = v_DWORD.Shadow;
            plain.v_LWORD = v_LWORD.Shadow;
            plain.v_SINTMin = v_SINTMin.Shadow;
            plain.v_SINTMax = v_SINTMax.Shadow;
            plain.v_INT = v_INT.Shadow;
            plain.v_DINT = v_DINT.Shadow;
            plain.v_LINT = v_LINT.Shadow;
            plain.v_USINT = v_USINT.Shadow;
            plain.v_UINT = v_UINT.Shadow;
            plain.v_UDINT = v_UDINT.Shadow;
            plain.v_ULINT = v_ULINT.Shadow;
            plain.v_REAL = v_REAL.Shadow;
            plain.v_LREAL = v_LREAL.Shadow;
            plain.v_TIME = v_TIME.Shadow;
            plain.v_LTIME = v_LTIME.Shadow;
            plain.v_DATE = v_DATE.Shadow;
            plain.v_LDATE = v_LDATE.Shadow;
            plain.v_TIME_OF_DAY = v_TIME_OF_DAY.Shadow;
            plain.v_LTIME_OF_DAY = v_LTIME_OF_DAY.Shadow;
            plain.v_DATE_AND_TIME = v_DATE_AND_TIME.Shadow;
            plain.v_LDATE_AND_TIME = v_LDATE_AND_TIME.Shadow;
            plain.v_CHAR = v_CHAR.Shadow;
            plain.v_WCHAR = v_WCHAR.Shadow;
            plain.v_STRING = v_STRING.Shadow;
            plain.v_WSTRING = v_WSTRING.Shadow;
            return plain;
        }

        public async virtual Task PlainToShadow<T>(T plain)
        {
            await this.PlainToShadowAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(global::Pocos.Tests_L1.Primitives.InitializedPrimitives plain)
        {
            v_BOOL.Shadow = plain.v_BOOL;
            v_BYTE.Shadow = plain.v_BYTE;
            v_WORD.Shadow = plain.v_WORD;
            v_DWORD.Shadow = plain.v_DWORD;
            v_LWORD.Shadow = plain.v_LWORD;
            v_SINTMin.Shadow = plain.v_SINTMin;
            v_SINTMax.Shadow = plain.v_SINTMax;
            v_INT.Shadow = plain.v_INT;
            v_DINT.Shadow = plain.v_DINT;
            v_LINT.Shadow = plain.v_LINT;
            v_USINT.Shadow = plain.v_USINT;
            v_UINT.Shadow = plain.v_UINT;
            v_UDINT.Shadow = plain.v_UDINT;
            v_ULINT.Shadow = plain.v_ULINT;
            v_REAL.Shadow = plain.v_REAL;
            v_LREAL.Shadow = plain.v_LREAL;
            v_TIME.Shadow = plain.v_TIME;
            v_LTIME.Shadow = plain.v_LTIME;
            v_DATE.Shadow = plain.v_DATE;
            v_LDATE.Shadow = plain.v_LDATE;
            v_TIME_OF_DAY.Shadow = plain.v_TIME_OF_DAY;
            v_LTIME_OF_DAY.Shadow = plain.v_LTIME_OF_DAY;
            v_DATE_AND_TIME.Shadow = plain.v_DATE_AND_TIME;
            v_LDATE_AND_TIME.Shadow = plain.v_LDATE_AND_TIME;
            v_CHAR.Shadow = plain.v_CHAR;
            v_WCHAR.Shadow = plain.v_WCHAR;
            v_STRING.Shadow = plain.v_STRING;
            v_WSTRING.Shadow = plain.v_WSTRING;
            return this.RetrievePrimitives();
        }

        ///<inheritdoc/>
        public async virtual Task<bool> AnyChangeAsync<T>(T plain)
        {
            return await this.DetectsAnyChangeAsync((dynamic)plain);
        }

        ///<summary>
        ///Compares if the current plain object has changed from the previous object.This method is used by the framework to determine if the object has changed and needs to be updated.
        ///[!NOTE] Any member in the hierarchy that is ignored by the compilers (e.g. when CompilerOmitAttribute is used) will not be compared, and therefore will not be detected as changed.
        ///</summary>
        public async Task<bool> DetectsAnyChangeAsync(global::Pocos.Tests_L1.Primitives.InitializedPrimitives plain, global::Pocos.Tests_L1.Primitives.InitializedPrimitives latest = null)
        {
            if (latest == null)
                latest = await this._OnlineToPlainNoacAsync();
            var somethingChanged = false;
            return await Task.Run(async () =>
            {
                if (plain.v_BOOL != v_BOOL.LastValue)
                    somethingChanged = true;
                if (plain.v_BYTE != v_BYTE.LastValue)
                    somethingChanged = true;
                if (plain.v_WORD != v_WORD.LastValue)
                    somethingChanged = true;
                if (plain.v_DWORD != v_DWORD.LastValue)
                    somethingChanged = true;
                if (plain.v_LWORD != v_LWORD.LastValue)
                    somethingChanged = true;
                if (plain.v_SINTMin != v_SINTMin.LastValue)
                    somethingChanged = true;
                if (plain.v_SINTMax != v_SINTMax.LastValue)
                    somethingChanged = true;
                if (plain.v_INT != v_INT.LastValue)
                    somethingChanged = true;
                if (plain.v_DINT != v_DINT.LastValue)
                    somethingChanged = true;
                if (plain.v_LINT != v_LINT.LastValue)
                    somethingChanged = true;
                if (plain.v_USINT != v_USINT.LastValue)
                    somethingChanged = true;
                if (plain.v_UINT != v_UINT.LastValue)
                    somethingChanged = true;
                if (plain.v_UDINT != v_UDINT.LastValue)
                    somethingChanged = true;
                if (plain.v_ULINT != v_ULINT.LastValue)
                    somethingChanged = true;
                if (plain.v_REAL != v_REAL.LastValue)
                    somethingChanged = true;
                if (plain.v_LREAL != v_LREAL.LastValue)
                    somethingChanged = true;
                if (plain.v_TIME != v_TIME.LastValue)
                    somethingChanged = true;
                if (plain.v_LTIME != v_LTIME.LastValue)
                    somethingChanged = true;
                if (plain.v_DATE != v_DATE.LastValue)
                    somethingChanged = true;
                if (plain.v_LDATE != v_LDATE.LastValue)
                    somethingChanged = true;
                if (plain.v_TIME_OF_DAY != v_TIME_OF_DAY.LastValue)
                    somethingChanged = true;
                if (plain.v_LTIME_OF_DAY != v_LTIME_OF_DAY.LastValue)
                    somethingChanged = true;
                if (plain.v_DATE_AND_TIME != v_DATE_AND_TIME.LastValue)
                    somethingChanged = true;
                if (plain.v_LDATE_AND_TIME != v_LDATE_AND_TIME.LastValue)
                    somethingChanged = true;
                if (plain.v_CHAR != v_CHAR.LastValue)
                    somethingChanged = true;
                if (plain.v_WCHAR != v_WCHAR.LastValue)
                    somethingChanged = true;
                if (plain.v_STRING != v_STRING.LastValue)
                    somethingChanged = true;
                if (plain.v_WSTRING != v_WSTRING.LastValue)
                    somethingChanged = true;
                plain = latest;
                return somethingChanged;
            });
        }

        public void Poll()
        {
            this.RetrievePrimitives().ToList().ForEach(x => x.Poll());
        }

        public global::Pocos.Tests_L1.Primitives.InitializedPrimitives CreateEmptyPoco()
        {
            return new global::Pocos.Tests_L1.Primitives.InitializedPrimitives();
        }

        private IList<AXSharp.Connector.ITwinObject> Children { get; } = new List<AXSharp.Connector.ITwinObject>();

        public IEnumerable<AXSharp.Connector.ITwinObject> GetChildren()
        {
            return Children;
        }

        private IList<AXSharp.Connector.ITwinElement> Kids { get; } = new List<AXSharp.Connector.ITwinElement>();

        public IEnumerable<AXSharp.Connector.ITwinElement> GetKids()
        {
            return Kids;
        }

        private IList<AXSharp.Connector.ITwinPrimitive> ValueTags { get; } = new List<AXSharp.Connector.ITwinPrimitive>();

        public IEnumerable<AXSharp.Connector.ITwinPrimitive> GetValueTags()
        {
            return ValueTags;
        }

        public void AddValueTag(AXSharp.Connector.ITwinPrimitive valueTag)
        {
            ValueTags.Add(valueTag);
        }

        public void AddKid(AXSharp.Connector.ITwinElement kid)
        {
            Kids.Add(kid);
        }

        public void AddChild(AXSharp.Connector.ITwinObject twinObject)
        {
            Children.Add(twinObject);
        }

        protected AXSharp.Connector.Connector @Connector { get; }

        public AXSharp.Connector.Connector GetConnector()
        {
            return this.@Connector;
        }

        public string GetSymbolTail()
        {
            return this.SymbolTail;
        }

        public AXSharp.Connector.ITwinObject GetParent()
        {
            return this.@Parent;
        }

        public string Symbol { get; protected set; }

        private string _attributeName;
        public System.String AttributeName { get => string.IsNullOrEmpty(_attributeName) ? SymbolTail : _attributeName.Interpolate(this).CleanUpLocalizationTokens(); set => _attributeName = value; }

        public System.String GetAttributeName(System.Globalization.CultureInfo culture)
        {
            if (string.IsNullOrEmpty(_attributeName))
            {
                return SymbolTail;
            }

            return this.Translate(_attributeName, culture).Interpolate(this);
        }

        private string _humanReadable;
        public string HumanReadable { get => string.IsNullOrEmpty(_humanReadable) ? SymbolTail : _humanReadable.Interpolate(this).CleanUpLocalizationTokens(); set => _humanReadable = value; }

        public System.String GetHumanReadable(System.Globalization.CultureInfo culture)
        {
            return this.Translate(_humanReadable, culture);
        }

        protected System.String @SymbolTail { get; set; }
        protected AXSharp.Connector.ITwinObject @Parent { get; set; }
        public AXSharp.Connector.Localizations.Translator Interpreter => global::axopen_data_tests_l1.PlcTranslator.Instance;
    }
}