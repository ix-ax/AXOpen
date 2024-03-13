
using System.Collections.Generic;

namespace AxoTextListExample
{
    public partial class AxoTextListExampleContext : AXOpen.Core.AxoContext
    {
        //<DeclarationOfTheDictionary>
        Dictionary<ulong, string> textList = new Dictionary<ulong, string>();
        //</DeclarationOfTheDictionary>
        public string TextList
        {
            get
            {
                //<FillingTheItemsOfTheDictionary>
                if (textList == null) { textList = new Dictionary<ulong, string>(); }
                if (textList.Count == 0)
                {
                    textList.Add(0, "   ");
                    for (int i = 1; i < 1000; i++)
                    {
                        textList.Add((ulong)i, "Text list item : " + i.ToString());
                    }

                }
                //</FillingTheItemsOfTheDictionary>
                //<ReturningTheItemBasedOnId>
                string _textItem = "   ";
                if (textList.TryGetValue(_myTextList1.Id.LastValue, out _textItem))
                {
                    return _textItem;
                }
                else
                {
                    return "   ";
                }
                //</ReturningTheItemBasedOnId>
            }
        }

        Dictionary<ulong, string> differentTextList = new Dictionary<ulong, string>();
        public string DifferentTextList
        {
            get
            {
                if (differentTextList == null) { differentTextList = new Dictionary<ulong, string>(); }
                if (differentTextList.Count == 0)
                {
                    differentTextList.Add(0, "   ");
                    for (int i = 1; i < 1000; i++)
                    {
                        differentTextList.Add((ulong)i, "Item from the totally different text list : " + i.ToString());
                    }

                }
                string differentTextItem = "   ";
                if (differentTextList.TryGetValue(_myTextList3.Id.LastValue, out differentTextItem))
                {
                    return differentTextItem;
                }
                else

                {
                    return "   ";
                }
            }
        }
    }

}
