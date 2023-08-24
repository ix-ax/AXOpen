// AXOpen.Core
// Copyright (c)2022 Peter Kurhajec and Contributors All Rights Reserved.
// Contributors: https://github.com/PTKu/ix/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/PTKu/ix/blob/master/LICENSE
// Third party licenses: https://github.com/PTKu/ix/blob/master/notices.md

namespace AXOpen.Messaging.Static;

public class AxoMessengerTextItem
{
    public string MessageText { get; }
    public string HelpText { get; }

    public AxoMessengerTextItem(string messageText,string helpText)
    {
        MessageText = messageText;
        HelpText = helpText;
    }
}