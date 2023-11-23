NAMESPACE axosimple.StarterUnitTemplate

    USING axosimple;
    USING AXOpen.Data;
    USING AXOpen.Core;
    USING System.Strings;

    CLASS PUBLIC UnitObjects EXTENDS axosimple.BaseUnit.UnitObjects
        VAR PUBLIC
            ///<summary>
            /// Handles and intializes components used by this unit.
            ///</summary>
            Components : Components;

            ///<summary>
            /// Provides access to process data manager of this unit
            ///</summary>
            ProcessSettings : REF_TO FragmentProcessDataManger;

            ///<summary>
            /// Provides access to process data manager of this unit
            ///</summary>
            ProcessData : REF_TO ProcessDataManager;

            ///<summary>
            /// Provides access to process data manager of this unit
            ///</summary>
            TechnologySettings : REF_TO TechnologyDataManager;
                        
            {#ix-attr:[AXOpen.Data.PersistentAttribute("StarterUnitTemplate")]}
            SpecialSettings :STRING[64] ;

        END_VAR        
    END_CLASS

END_NAMESPACE
