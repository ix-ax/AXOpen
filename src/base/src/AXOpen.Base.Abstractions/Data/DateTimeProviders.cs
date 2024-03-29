﻿using System;

namespace AXOpen.Base.Data
{
    public static class DateTimeProviders
    {
        public static DateTimeProviderBase DateTimeProvider { get; set; } = new StandardDateTimeProvider();
    }
    public class StandardDateTimeProvider : DateTimeProviderBase
    {
        public override DateTime Now => DateTime.Now;
    }

    public abstract class DateTimeProviderBase
    {
        protected DateTimeProviderBase() { }

        public abstract DateTime Now { get; }
    }
}