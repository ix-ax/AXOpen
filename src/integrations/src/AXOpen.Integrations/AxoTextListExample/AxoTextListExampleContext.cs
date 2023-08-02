namespace AxoTextListExample
{
    public partial class AxoTextListExampleContext : AXOpen.Core.AxoContext
    {
        Dictionary<uint, string> descriptionDict = new Dictionary<uint, string>();

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
                if (descriptionDict.TryGetValue(_myTextList.Id.LastValue, out description))
                {
                    return description;
                }
                else

                {
                    return "   ";
                }
            }
        }

    }

}
