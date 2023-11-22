
using System.Collections.Generic;

namespace AxoTextListExample
{
    public partial class AxoTextListExampleContext : AXOpen.Core.AxoContext
    {
        //<DeclarationOfTheDictionary>
        Dictionary<uint, string> textList = new Dictionary<uint, string>();
        //</DeclarationOfTheDictionary>
        public string TextList
        {
            get
            {
                //<FillingTheItemsOfTheDictionary>
                if (textList == null) { textList = new Dictionary<uint, string>(); }
                if (textList.Count == 0)
                {
                    textList.Add(0, "   ");
                    for (int i = 1; i < 1000; i++)
                    {
                        textList.Add((uint)i, "Text list item : " + i.ToString());
                    }
                }
                //</FillingTheItemsOfTheDictionary>
                //<ReturningTheItemBasedOnId>
                string _textItem = "   ";
                if (_myTextList1 != null && _myTextList1.Id != null && textList.TryGetValue(_myTextList1.Id.LastValue, out _textItem))
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

        Dictionary<uint, string> differentTextList = new Dictionary<uint, string>();
        public string DifferentTextList
        {
            get
            {
                if (differentTextList == null) { differentTextList = new Dictionary<uint, string>(); }
                if (differentTextList.Count == 0)
                {
                    differentTextList.Add(0, "   ");
                    for (int i = 1; i < 1000; i++)
                    {
                        differentTextList.Add((uint)i, "Item from the totally different text list : " + i.ToString());
                    }

                }
                string differentTextItem = "   ";
                if (_myTextList3 != null && _myTextList3.Id != null && differentTextList.TryGetValue(_myTextList3.Id.LastValue, out differentTextItem))
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
