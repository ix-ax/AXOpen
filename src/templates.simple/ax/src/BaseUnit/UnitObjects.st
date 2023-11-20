NAMESPACE axosimple.BaseUnit
    
    USING axosimple;
    USING AXOpen.Data;
    USING AXOpen.Core;
    USING System.Strings;

    CLASS PUBLIC UnitObjects
        VAR PUBLIC
            ///<summary>
            /// Station/Unit number.
            ///</summary>
            StationNumber : INT;
            
            ///<summary>
            /// Provides access to persistent data manager
            ///</summary>
            PersistentData : REF_TO AxoDataPersistentExchange;

            Global : REF_TO axosimple.GlobalContextObjects;

            {#ix-attr:[AXOpen.Data.PersistentAttribute("")]}
            LastTechnologySettings : STRING[64] ;

        END_VAR        
    END_CLASS

END_NAMESPACE
