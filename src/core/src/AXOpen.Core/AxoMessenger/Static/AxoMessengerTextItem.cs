// AXOpen.Core
// Copyright (c)2022 MTS spol. s r.o. and Contributors All Rights Reserved.
// Contributors: https://github.com/inxton/AXOpen/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/inxton/AXOpen/blob/master/LICENSE
// Third party licenses: https://github.com/inxton/AXOpen/blob/master/notices.md

namespace AXOpen.Messaging.Static;

public class AxoMessengerTextItem
{
    public Func<string> MessageTextExpression { get; set; }
    public Func<string> HelpTextExpression { get; set; }

    private string _messageText;
    public string MessageText 
    { 
        get { 
                if(_messageText is null)
                {
                    if(MessageTextExpression is not null)
                    {
                        return MessageTextExpression.Invoke();
                    }
                }
                return _messageText; 
        } 

        private set 
        { 
            _messageText = value; 
        } 
    }

    private string _helpText;
    public string HelpText { get { return _helpText; } private set { _helpText = value; } }

    public AxoMessengerTextItem(string messageText, string helpText)
    {
        MessageText = messageText;
        HelpText = helpText;
    }

    public AxoMessengerTextItem(Func<string> messageTextExpression, Func<string> helpTextExpression)
    {
        MessageTextExpression = messageTextExpression;
        HelpTextExpression = helpTextExpression;
    }

    public AxoMessengerTextItem(Func<string> messageTextExpression, string helpText)
    {
        MessageTextExpression = messageTextExpression;
        HelpText = helpText;
    }

    public AxoMessengerTextItem(string messageText)
    {
        MessageText = messageText;
        HelpText = "";
    }
}