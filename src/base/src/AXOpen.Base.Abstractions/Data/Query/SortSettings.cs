namespace AXOpen.Base.Data.Query
{
    using System;

    public class SortSettings
    {
        public string MemberName { get; set; } = ""; // empty string => natural sorting 
        public bool IsAscending { get; set; }
    }
}