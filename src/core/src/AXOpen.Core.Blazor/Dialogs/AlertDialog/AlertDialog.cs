﻿//using AXSharp.Abstractions.Dialogs.AlertDialog;
//using System;

//namespace AXSharp.Presentation.Blazor.Controls.Dialogs.AlertDialog
//{
//    public class AlertDialog /*: IAlertDialog*/
//    {
//        public Guid Id { get; set; } = Guid.NewGuid();
//        public eDialogType Type { get; set; } = eDialogType.Undefined;
//        public string Title { get; set; } = "";
//        public string Message { get; set; } = "";
//        public DateTimeOffset TimeToBurn { get; set; } = DateTimeOffset.Now.AddSeconds(30);
//        public DateTimeOffset Posted { get; set; } = DateTimeOffset.Now;

//        public AlertDialog(eDialogType type, string title, string message, int time)
//        {
//            Type = type;
//            Title = title;
//            Message = message;
//            TimeToBurn = DateTimeOffset.Now.AddSeconds(time);
//        }
//    }
//}