// AXOpen.Core
// Copyright (c)2022 Peter Kurhajec and Contributors All Rights Reserved.
// Contributors: https://github.com/PTKu/ix/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/PTKu/ix/blob/master/LICENSE
// Third party licenses: https://github.com/PTKu/ix/blob/master/notices.md

using AXOpen.Base.Data;
using System;
using System.Collections.Generic;
using static System.Net.Mime.MediaTypeNames;

namespace AXOpen.Messaging.Static;

public partial class AxoMessenger
{

    private List<KeyValuePair<ulong, AxoMessengerTextItem>> plcMessengerTextList;
    public List<KeyValuePair<ulong, AxoMessengerTextItem>> PlcMessengerTextList
    {
        get
        {
            try
            {
                if (plcMessengerTextList == null)
                {
                    plcMessengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>();
                    if (PlcTextList != null)
                    {
                        string[] items = PlcTextList.Split('\n');
                        //All message texts and help texts are in one line
                        if (items.Length == 1)
                        {
                            string[] delimiters = { "[", "]:'", "':'", "';", "'" };
                            string[] itemSeparated = items[0].Split(delimiters, StringSplitOptions.RemoveEmptyEntries);
                            try
                            {
                                if (itemSeparated.Length >= 3 && itemSeparated.Length % 3 == 0)
                                {
                                    int itemsCount = itemSeparated.Length / 3;
                                    for (int i = 0; i < itemsCount; i++)
                                    {
                                        ulong messageCode = 0;
                                        if (ulong.TryParse(itemSeparated[3 * i], out messageCode))
                                        {
                                            string messageText = string.IsNullOrEmpty(itemSeparated[3 * i + 1]) ? "Message text not defined for the message code: " + messageCode.ToString() + "!" : itemSeparated[3 * i + 1];
                                            string helpText = string.IsNullOrEmpty(itemSeparated[3 * i + 2]) ? "Help text not defined for the message code: " + messageCode.ToString() + "!" : itemSeparated[3 * i + 2];
                                            plcMessengerTextList.Add(new KeyValuePair<ulong, AxoMessengerTextItem>(messageCode, new AxoMessengerTextItem(messageText, helpText)));
                                        }
                                    }
                                }
                            }
                            catch (Exception)
                            {
                                throw;
                            }
                        }
                        //Each pair of the  Id message text and help text are in the separate line (change on the compilator side needs to be implemented)
                        else if (items.Length > 1)
                        {
                            foreach (string item in items)
                            {
                                string[] delimiters = { "[", "]:'", "':'", "'" };
                                string[] itemSeparated = item.Split(delimiters, StringSplitOptions.RemoveEmptyEntries);
                                try
                                {
                                    ulong messageCode = 0;
                                    if (ulong.TryParse(itemSeparated[0], out messageCode))
                                    {
                                        string messageText = string.IsNullOrEmpty(itemSeparated[1]) ? "Message text not defined for the message code: " + messageCode.ToString() + "!" : itemSeparated[1];
                                        string helpText = string.IsNullOrEmpty(itemSeparated[2]) ? "Help text not defined for the message code: " + messageCode.ToString() + "!" : itemSeparated[2];
                                        plcMessengerTextList.Add(new KeyValuePair<ulong, AxoMessengerTextItem>(messageCode, new AxoMessengerTextItem(messageText, helpText)));
                                    }
                                }
                                catch (Exception)
                                {
                                    throw;
                                }
                            }
                        }

                    }
                }
                return plcMessengerTextList;
            }

            catch (Exception)
            {

                throw;
            }

        }
    }

    private List<KeyValuePair<ulong, AxoMessengerTextItem>> dotNetMessengerTextList;
    public List<KeyValuePair<ulong, AxoMessengerTextItem>> DotNetMessengerTextList
    {
        get{return dotNetMessengerTextList != null ? dotNetMessengerTextList : new List<KeyValuePair<ulong, AxoMessengerTextItem>>();}
        set{dotNetMessengerTextList = value != null ? value : new List<KeyValuePair<ulong, AxoMessengerTextItem>>(); }
    }

    public eAxoMessengerState State => (eAxoMessengerState)this.MessengerState.LastValue;
}
