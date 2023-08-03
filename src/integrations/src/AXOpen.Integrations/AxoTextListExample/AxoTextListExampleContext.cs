namespace AxoTextListExample
{
    public partial class AxoTextListExampleContext : AXOpen.Core.AxoContext
    {
        Dictionary<uint, string> descriptionDict = new Dictionary<uint, string>();
        Dictionary<uint, string> descriptionDict3 = new Dictionary<uint, string>();

        public string Description
        {
            get
            {
                if (descriptionDict == null) { descriptionDict = new Dictionary<uint, string>(); }
                if (descriptionDict.Count == 0)
                {
                    descriptionDict.Add(0, "   ");
                    for (int i = 1; i < 1000; i++)
                    {
                        descriptionDict.Add((uint)i, "Text list item : " + i.ToString());
                    }

                }
                string description = "   ";
                if (descriptionDict.TryGetValue(_myTextList1.Id.LastValue, out description))
                {
                    return description;
                }
                else

                {
                    return "   ";
                }
            }
        }

        public string Description3
        {
            get
            {
                if (descriptionDict3 == null) { descriptionDict3 = new Dictionary<uint, string>(); }
                if (descriptionDict3.Count == 0)
                {
                    descriptionDict3.Add(0, "   ");
                    for (int i = 1; i < 1000; i++)
                    {
                        descriptionDict3.Add((uint)i, "Item from the totally different text list : " + i.ToString());
                    }

                }
                string description3 = "   ";
                if (descriptionDict3.TryGetValue(_myTextList3.Id.LastValue, out description3))
                {
                    return description3;
                }
                else

                {
                    return "   ";
                }
            }
        }
    }

}
