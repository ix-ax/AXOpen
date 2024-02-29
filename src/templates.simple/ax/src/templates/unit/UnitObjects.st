NAMESPACE axosimple.UnitTemplate

    USING axosimple;
    USING AXOpen.Data;
    USING AXOpen.Core;
    USING System.Strings;

    {S7.extern=ReadWrite}
    CLASS PUBLIC UnitObjects EXTENDS axosimple.BaseUnit.UnitObjects
        VAR PUBLIC
            ///<summary>
            /// Handles and intializes components used by this unit.
            ///</summary>
            Components : REF_TO axosimple.UnitTemplate.Components;

            ///<summary>
            /// Provides access to process data manager of this unit
            ///</summary>
            ProcessSettings : REF_TO axosimple.UnitTemplate.FragmentProcessDataManger;

            ///<summary>
            /// Provides access to process data manager of this unit
            ///</summary>
            ProcessData : REF_TO axosimple.UnitTemplate.ProcessDataManager;

            ///<summary>
            /// Provides access to process data manager of this unit
            ///</summary>
            TechnologySettings : REF_TO axosimple.UnitTemplate.TechnologyDataManager;
                     
            {#ix-attr:[AXOpen.Data.PersistentAttribute("UnitTemplate")]}
            SpecialSettings : STRING[64] ;

            // https://ix-ax.github.io/AXOpen/core/docs/AXODIALOG.html#closing-a-dialog-with-external-signal
            _dialog : AXOpen.Core.AxoDialog;

            // https://ix-ax.github.io/AXOpen/core/docs/AXOALERTDIALOG.html#invoking-alerts-from-plc
            _alertDialog : AXOpen.Core.AxoAlert;
  
            // it needs to be handle from auto or ground sequnce
            _inspectorDialog       : AXOpen.Inspectors.AxoInspectorDialog;
        END_VAR        
    END_CLASS

END_NAMESPACE
