// AXOpen.Core
// Copyright (c)2022 MTS spol. s r.o. and Contributors All Rights Reserved.
// Contributors: https://github.com/inxton/AXOpen/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/inxton/AXOpen/blob/master/LICENSE
// Third party licenses: https://github.com/inxton/AXOpen/blob/master/notices.md

namespace AXOpen.Messaging.Static;

public class AxoMessengerTextItem
{
    public string MessageText { get; }
    public string HelpText { get; }

    public AxoMessengerTextItem(string messageText, string helpText)
    {
        MessageText = messageText;
        HelpText = helpText;
    }
    public AxoMessengerTextItem(string messageText)
    {
        MessageText = messageText;
        HelpText = "";
    }
}