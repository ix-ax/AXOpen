// AXOpen.Core
// Copyright (c)2022 Peter Kurhajec and Contributors All Rights Reserved.
// Contributors: https://github.com/PTKu/ix/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/PTKu/ix/blob/master/LICENSE
// Third party licenses: https://github.com/PTKu/ix/blob/master/notices.md

using System;
using System.Collections.Generic;
using static System.Net.Mime.MediaTypeNames;

namespace AXOpen.Messaging.Static;

public partial class AxoMessenger
{

    private List<KeyValuePair<int, AxoMessengerTextItem>> axoMessengerTextList;
    public List<KeyValuePair<int, AxoMessengerTextItem>> AxoMessengerTextList 
    {
        get
        {
            try
            {
                if (axoMessengerTextList == null)
                {
                    axoMessengerTextList = new List<KeyValuePair<int, AxoMessengerTextItem>>();
                    if(MessageTextList  != null )
                    {
                        string[] items = MessageTextList.Split('\n');
                        if (items.Length == 1 ) 
                        {
                            string[] delimiters = { "[", "]:'", "':'", "';", "'" };
                            string[] itemSeparated = items[0].Split(delimiters, StringSplitOptions.RemoveEmptyEntries);
                            try
                            {
                                if(itemSeparated.Length >= 3 && itemSeparated.Length % 3 ==0  ) 
                                { 
                                    int itemsCount = itemSeparated.Length / 3;
                                    for ( int i = 0; i < itemsCount; i++)
                                    {
                                        int messageCode = 0;
                                        if (Int32.TryParse(itemSeparated[3*i], out messageCode))
                                        {
                                            string messageText = string.IsNullOrEmpty(itemSeparated[3 * i + 1]) ? "Message text not defined for the message code: " + messageCode.ToString() + "!" : itemSeparated[3 * i + 1];
                                            string helpText = string.IsNullOrEmpty(itemSeparated[3 * i + 2]) ? "Help text not defined for the message code: " + messageCode.ToString() + "!" : itemSeparated[3 * i + 2];
                                            KeyValuePair<int, AxoMessengerTextItem> valuePair = new KeyValuePair<int, AxoMessengerTextItem>(messageCode, new AxoMessengerTextItem(messageText, helpText));
                                            axoMessengerTextList.Add(valuePair);
                                        }
                                    }
                                }
                            }
                            catch (Exception)
                            {
                                throw;
                            }
                        }
                        else if(items.Length > 1)
                        {
                            foreach (string item in items)
                            {
                                string[] delimiters = { "[", "]:'", "':'", "'" };
                                string[] itemSeparated = item.Split(delimiters, StringSplitOptions.RemoveEmptyEntries);
                                try
                                {
                                    int messageCode = 0;
                                    if (Int32.TryParse(itemSeparated[0], out messageCode))
                                    {
                                        string messageText = string.IsNullOrEmpty(itemSeparated[1]) ? "Message text not defined for the message code: " + messageCode.ToString() + "!" : itemSeparated[1];
                                        string helpText = string.IsNullOrEmpty(itemSeparated[2]) ? "Help text not defined for the message code: " + messageCode.ToString() + "!" : itemSeparated[2];
                                        KeyValuePair<int, AxoMessengerTextItem> valuePair = new KeyValuePair<int, AxoMessengerTextItem>(messageCode, new AxoMessengerTextItem(messageText, helpText));
                                        axoMessengerTextList.Add(valuePair);
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
                return axoMessengerTextList;
            }

            catch (Exception)
            {

                throw;
            }

        }
    }

}


