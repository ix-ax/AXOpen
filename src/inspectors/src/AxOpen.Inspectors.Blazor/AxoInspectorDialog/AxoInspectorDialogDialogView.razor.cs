//using AXOpen.Core;
//using AXOpen.Core.Blazor.AxoDialogs;
//using Pocos.AXOpen.Inspectors;
//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
//using System.Threading.Tasks;

//namespace AXOpen.Inspectors
//{
//    public partial class AxoInspectorDialogDialogView: AxoDialogBaseView<AxoInspectorDialog>
//    {

//        public bool RetryDisabled { get; set; } = false;



//        public async Task Retry()
//        {
//            if (base.Component != null && !base.Component._isOverInspected.Cyclic)
//            {
//                RetryDisabled = false;
//                base.Component._dialogueRetry.Edit = true;
//                await base.CloseDialogsWithSignalR();
//            }
//            else
//            {
//                RetryDisabled = true;
//            }


//            //TcOpen.Inxton.TcoAppDomain.Current.Logger.Information($"{nameof(Retry)} of {Dialog.HumanReadable} was executed @{{payload}}.", new { Dialog.Symbol });
//        }
//        public async Task Terminate()
//        {
//            base.Component._dialogueTerminate.Edit = true;
//            await base.CloseDialogsWithSignalR();
//            //TcOpen.Inxton.TcoAppDomain.Current.Logger.Information($"{nameof(Terminate)} of {Dialog.HumanReadable} was executed @{{payload}}.", new { Dialog.Symbol });
//        }
//        public async Task Override()
//        {
//            base.Component._dialogueOverride.Edit = true;
//            await base.CloseDialogsWithSignalR();
//            //TcOpen.Inxton.TcoAppDomain.Current.Logger.Information($"{nameof(Override)} of {Dialog.HumanReadable} was executed @{{payload}}.", new { Dialog.Symbol });
//        }

       
//        public string Description
//        {
//            get => string.IsNullOrEmpty(base.Component.AttributeName) ? base.Component.GetSymbolTail() : base.Component.AttributeName;

//        }


//        //List<IVortexObject> _inspectorsList;
//        //public IEnumerable<IVortexObject> Inspectors
//        //{
//        //    get
//        //    {
//        //        if (_inspectorsList == null)
//        //        {
//        //            _inspectorsList = new List<IVortexObject>();
//        //            try
//        //            {

//        //                var parent = Dialog.GetParent();
//        //                switch (parent)
//        //                {
//        //                    case TcoInspectionGroup g:
//        //                        g.Read();
//        //                        _inspectorsList = g._inspections.Take(g._inspectionIndex.LastValue)
//        //                            .Select(p => g.GetConnector().IdentityProvider.GetVortexerByIdentity(p.LastValue) as IVortexObject)
//        //                            .Where(p => !(p is NullVortexIdentity)).ToList();
//        //                        break;
//        //                    case TcoInspector i:
//        //                        _inspectorsList.Add(parent);
//        //                        break;
//        //                }
//        //            }
//        //            catch (Exception)
//        //            {
//        //                return _inspectorsList;
//        //            }
//        //        }

//        //        return _inspectorsList;
//        //    }
//        //}
//    }
//}
