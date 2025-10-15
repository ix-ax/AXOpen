// AXOpen.Core
// Copyright (c)2022 MTS spol. s r.o. and Contributors All Rights Reserved.
// Contributors: https://github.com/inxton/AXOpen/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/inxton/AXOpen/blob/master/LICENSE
// Third party licenses: https://github.com/inxton/AXOpen/blob/master/notices.md

using AXOpen.Base.Data;
using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using System.Security.Principal;
using System.Text.RegularExpressions;
using AXOpen.Core;
using AXSharp.Connector;
using AXSharp.Connector.Localizations;
using Serilog;
using static System.Net.Mime.MediaTypeNames;

namespace AXOpen.Messaging.Static;

public partial class AxoMessenger
{
    /// <summary>
    /// Parses a string containing multiple message entries into a dictionary.
    /// Each entry is expected to have the format:
    /// [number]:'<#message text#>':'<#help text#>'
    /// Entries should be separated by a semicolon (;).
    /// Throws an exception if no matches are found, the format is invalid, or a duplicate key exists.
    /// </summary>
    /// <param name="input">The string to parse.</param>
    /// <param name="messenger">Messenger to which the list of messages belongs.</param>
    /// <returns>A dictionary mapping the key (number) to a MessageEntry instance.</returns>
    private static Dictionary<ulong, AxoMessengerTextItem> ParseMessages(string input, AxoMessenger messenger)
    {
        var messages = new Dictionary<ulong, AxoMessengerTextItem>();

        if(string.IsNullOrEmpty(input))
            return messages;
        
        // Split the input by semicolon and remove any empty entries.
        string[] entries = input.Split(new char[] { ';' }, StringSplitOptions.RemoveEmptyEntries);

        foreach (string entry in entries)
        {
            string trimmedEntry = entry.Trim();
            if (trimmedEntry.Length == 0)
                continue;

            // Extract key: look for the text between '[' and ']'
            int startBracket = trimmedEntry.IndexOf('[');
            int endBracket = trimmedEntry.IndexOf(']', startBracket + 1);
            if (startBracket == -1 || endBracket == -1)
            {
                Log.Error($"Invalid format: missing '[' or ']' for key in `{messenger.Symbol}`");
                //throw new ArgumentException("Invalid format: missing '[' or ']' for key.");
            }

            string keyString = trimmedEntry.Substring(startBracket + 1, endBracket - startBracket - 1).Trim();
            if (!ulong.TryParse(keyString, out ulong key))
            {
                Log.Error($"Invalid key format: `{keyString}` in `{messenger.Symbol}`");
                //throw new ArgumentException($"Invalid key format: {keyString}");
            }
            if (messages.ContainsKey(key))
            {
                Log.Error($"Duplicate key found: `{key} `in `{messenger.Symbol}`");
                //throw new ArgumentException($"Duplicate key found: {key}");
            }

            // After the key, the format should be :'<# ... #>':'<# ... #>'
            // We'll locate the message and help texts using the positions of single quotes.
            int firstQuote = trimmedEntry.IndexOf('\'', endBracket);
            if (firstQuote == -1)
            {
                Log.Error($"Invalid format: missing opening quote for message text in `{messenger.Symbol}`");
                //throw new ArgumentException("Invalid format: missing opening quote for message text.");
            }

            int secondQuote = trimmedEntry.IndexOf('\'', firstQuote + 1);
            if (secondQuote == -1)
            {
                Log.Error($"Invalid format: missing closing quote for message text. `{messenger.Symbol}`");
                //throw new ArgumentException("Invalid format: missing closing quote for message text.");
            }

            // Extract the message text (including the literal <# and #>).
            string messageText = trimmedEntry.Substring(firstQuote + 1, secondQuote - firstQuote - 1).Trim();

            // Locate the next pair of quotes for the help text.
            int thirdQuote = trimmedEntry.IndexOf('\'', secondQuote + 1);
            if (thirdQuote == -1)
            {
                Log.Error($"Invalid format: missing opening quote for message text in `{messenger.Symbol}`");
                //throw new ArgumentException("Invalid format: missing opening quote for message text.");
            }

            int fourthQuote = trimmedEntry.IndexOf('\'', thirdQuote + 1);
            if (fourthQuote == -1)
            {
                Log.Error($"Invalid format: missing closing quote for message text. `{messenger.Symbol}`");
                //throw new ArgumentException("Invalid format: missing closing quote for message text.");
            }

            string helpText = trimmedEntry.Substring(thirdQuote + 1, fourthQuote - thirdQuote - 1).Trim();

            // Add the entry to the dictionary.
            messages.Add(key, new AxoMessengerTextItem(messageText, helpText));
        }

        return messages;
    }

    private Dictionary<ulong, AxoMessengerTextItem> plcMessengerTextList;
    public Dictionary<ulong, AxoMessengerTextItem> PlcMessengerTextList
    {
        get
        {
            try
            {
                if (plcMessengerTextList == null)
                {
                    plcMessengerTextList = ParseMessages(this.PlcTextList_raw, this);
                }
            }
            catch (Exception)
            {
                //plcMessengerTextList = new Dictionary<ulong, AxoMessengerTextItem>();
                //swallow 
            }
            
            return plcMessengerTextList;
        }
    }

    private List<KeyValuePair<ulong, AxoMessengerTextItem>> dotNetMessengerTextList;
    public List<KeyValuePair<ulong, AxoMessengerTextItem>> DotNetMessengerTextList
    {
        get{return dotNetMessengerTextList != null ? dotNetMessengerTextList : new List<KeyValuePair<ulong, AxoMessengerTextItem>>();}
        set{dotNetMessengerTextList = value != null ? value : new List<KeyValuePair<ulong, AxoMessengerTextItem>>(); }
    }


    public void RestoreParentTask(IIdentity? currentUserIdentity)
    {
        (this?.GetParent() as AxoTask)?.Restore();
        AxoApplication.Current.Logger.Information(
            $"Task has been restored using alarm view.", this.Component,
            currentUserIdentity);
    }

    public eAxoMessengerState State => (eAxoMessengerState)this.MessengerState.LastValue;

    public bool IsActive => State == eAxoMessengerState.ActiveAlreadyAcknowledged ||
                            State == eAxoMessengerState.ActiveAcknowledgeRequired ||
                            State == eAxoMessengerState.ActiveAcknowledgeNotRequired;

    public bool IsAcknowledged => State == eAxoMessengerState.ActiveAlreadyAcknowledged;
                                      

    public void Acknowledge(IIdentity identity)
    {
        this.AcknowledgeRequest.Cyclic = true;
        AxoApplication.Current.Logger.Information("Message acknowledge", this, identity);
    }

    private ITwinObject _component;
    public ITwinObject Component
    {
        get
        {
            if (_component == null)
            {
                _component = FindParentOfType<AxoComponent>(this);
                if (_component == null)
                {
                    _component = this.GetParent();
                }
            }

            return _component;
        }
    }

    public async Task ReadDetailsAsync()
    {
        var r = new ITwinPrimitive[] { this.MessageCode, Category, MessageCode,  MessengerState, Message, Risen, Fallen, Acknowledged   };
        await this.GetConnector()?.ReadBatchAsync(r)!;
    }

    static T? FindParentOfType<T>(ITwinElement node, int depth = 0) where T : ITwinObject
    {
        if (depth > 10 || node == null || node is AXSharp.Connector.Connector) return default(T);

        if (node is T) return (T)node;

        return FindParentOfType<T>(node.GetParent(), depth++);
    }

    /// <summary>
    /// Retrieves the message text based on the message code.
    /// </summary>
    /// <returns>The message text string.</returns>
    public string GetMessageText()
    {
        //18446744073709551615
        
        ulong messageCode = this.MessageCode.LastValue;

        if (messageCode == ulong.MaxValue)
        {
            return this.Message.LastValue;
        }

        string retVal = "";
        string prefix = "";
        if (this.MessengerState.Equals(eAxoMessengerState.InvalidImplementation) || this.MessengerState.LastValue.Equals((short)eAxoMessengerState.InvalidImplementation))
        {
            prefix = "Invalid implementation (message code: " + messageCode.ToString() + ") ";
        }

        if (messageCode == 0)
            retVal = "";
        else
        {
            try
            {
                //Several static texts defined inside the `PlcTextsList` attribute in the PLC code are used
                if (this.PlcMessengerTextList != null && this.PlcMessengerTextList.Count > 0)
                {
                    string _messageText = (from item in this.PlcMessengerTextList where item.Key == messageCode select item.Value.MessageText.ToString()).FirstOrDefault();
                    retVal = string.IsNullOrEmpty(_messageText) ? prefix + "Message text not defined for the message code: " + messageCode.ToString() + " !" : prefix + _messageText;
                }
                //Message texts are written in .NET and passed into the component
                else if (this.DotNetMessengerTextList != null && this.DotNetMessengerTextList.Count > 0)
                {
                    string _messageText = (from item in this.DotNetMessengerTextList where item.Key == messageCode select item.Value.MessageText.ToString()).FirstOrDefault();
                    retVal = string.IsNullOrEmpty(_messageText) ? prefix + "Message text not defined for the message code: " + messageCode.ToString() + " !" : prefix + _messageText;
                }
                else
                {
                    retVal = prefix + "Message text not defined for the message code: " + messageCode.ToString() + " !";
                }
            }
            catch (Exception)
            {
                retVal = prefix + "Message text not defined for the message code: " + messageCode.ToString() + " !";
                return retVal;
                throw;
            }
        }
        ChekIfHelpTextDefined();
        return retVal.Interpolate(this).CleanUpLocalizationTokens();
    }

    public string GetHelpText()
        {

            ulong messageCode = MessageCode.LastValue;

            if (messageCode == ulong.MaxValue)
            {
                return string.Empty;
            }

        
            string retVal = "";
            string prefix = "";
            if (this.MessengerState.Equals(eAxoMessengerState.InvalidImplementation))
            {
                prefix = "Invalid implementation (message code: " + messageCode.ToString() + "). Check if the AxoMessenger has a valid AxoContext so as the valid AxoRtm. Check also the order of the methods called. The 'Serve' method must be calle before any other 'Activate' or 'ActivateOnCondition' method's call. ";
            }
            if (MessageCode.Cyclic == 0)
                retVal = "";
            else
            {
                try
                {
                    //Static texts defined inside the `PlcTextsList` attribute in the PLC code are used
                    if (PlcMessengerTextList != null && PlcMessengerTextList.Count > 0)
                    {
                        string _helpText = (from item in PlcMessengerTextList where item.Key == messageCode select item.Value.HelpText.ToString()).FirstOrDefault();
                        retVal = string.IsNullOrEmpty(_helpText) ? prefix + "Help text not defined for the message code: " + messageCode.ToString() + " !" : prefix + _helpText + $"[{messageCode}]";
                }
                    //Message texts are written in .NET and passed into the component
                    else if (DotNetMessengerTextList != null && DotNetMessengerTextList.Count > 0)
                    {
                        string _helpText = (from item in DotNetMessengerTextList where item.Key == messageCode select item.Value.HelpText.ToString()).FirstOrDefault();
                        retVal = string.IsNullOrEmpty(_helpText) ? prefix + "Help text not defined for the message code: " + messageCode.ToString() + " !" : prefix + _helpText + $"[{messageCode}]";
                }
                    else
                    {
                        retVal = prefix + "Help text not defined for the message code: " + messageCode.ToString() + " !";
                    }
                }
                catch (Exception)
                {
                    retVal = prefix + "Help text not defined for the message code: " + messageCode.ToString() + " !";
                    return retVal;
                    throw;
                }
        }
            return retVal.Interpolate(this).CleanUpLocalizationTokens();
        }
    
    public bool HelpTextDefined = false;
    private void ChekIfHelpTextDefined()
    {
        ulong messageCode = this.MessageCode.LastValue;

        //Just one static text defined inside the `MessageText` attribute in the PLC code is used
        if (messageCode == 0)
            //HelpTextDefined = !(string.IsNullOrEmpty(this.Help) || this.Help == this.GetSymbolTail());
            HelpTextDefined = false;
        else
        {
            try
            {
                //Several static texts defined inside the `PlcTextsList` attribute in the PLC code are used
                if (this.PlcMessengerTextList != null && this.PlcMessengerTextList.Count > 0)
                {
                    string _helpText = (from item in this.PlcMessengerTextList where item.Key == messageCode select item.Value.HelpText.ToString()).FirstOrDefault();
                    HelpTextDefined = !(string.IsNullOrEmpty(_helpText));
                }
                //Message texts are written in .NET and passed into the component
                else if (this.DotNetMessengerTextList != null && this.DotNetMessengerTextList.Count > 0)
                {
                    string _helpText = (from item in this.DotNetMessengerTextList where item.Key == messageCode select item.Value.HelpText.ToString()).FirstOrDefault();
                    HelpTextDefined = !(string.IsNullOrEmpty(_helpText));
                }
                else
                {
                    HelpTextDefined = false;
                }
            }
            catch (Exception)
            {
                HelpTextDefined = false;
                throw;
            }
    }
}
}

public class EmptyMessenger
{
    public string MessageText { get; set; } = "All good here.";
}