USING AXOpen.Core;
USING AXOpen;
using AXOpen.Data;

NAMESPACE Tests_L1.PersistentData
 
    {S7.extern=ReadWrite}
    CLASS PUBLIC ObjectWithPersistentMember
        VAR PUBLIC 
            NotPersistentVariable : INT; 
            
            {#ix-attr:[Persistent("2")]}
            InitializedPrimitives : Tests_L1.Primitives.InitializedPrimitives; // will be saved to '2' persistent group
        END_VAR
    END_CLASS
    
END_NAMESPACE
