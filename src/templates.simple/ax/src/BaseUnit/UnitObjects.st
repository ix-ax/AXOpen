NAMESPACE axosimple.BaseUnit
    
    USING axosimple;
    USING AXOpen.Data;
    USING AXOpen.Core;
    USING System.Strings;

    {S7.extern=ReadWrite}
    CLASS PUBLIC UnitObjects
        VAR PUBLIC
            ///<summary>
            /// Station/Unit number.
            ///</summary>
            StationNumber : INT;
            
            ///<summary>
            /// Reference global objects in technology.
            ///</summary>
            Global : REF_TO axosimple.GlobalContextObjects;

            {#ix-attr:[AXOpen.Data.PersistentAttribute("")]}
            LastTechnologySettings : STRING[64] ;

        END_VAR        
    END_CLASS

END_NAMESPACE
