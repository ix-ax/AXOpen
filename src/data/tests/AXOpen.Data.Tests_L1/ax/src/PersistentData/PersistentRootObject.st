USING AXOpen.Core;
USING AXOpen;
using AXOpen.Data;

NAMESPACE Tests_L1.PersistentData

    {S7.extern=ReadWrite}
    CLASS PUBLIC PersistentRootObject
        VAR PUBLIC 
            NotPersistentVariable : BOOL; 
            
            {#ix-attr:[Persistent()]}
            PersistentVariable_1 : INT; // will be saved to 'default' persistent group
            
            {#ix-attr:[Persistent("default","1")]} // will be saved to 'default' and '1' persistent group
            PersistentVariable_2 : INT;
            
            PropertyWithPersistentMember : Tests_L1.PersistentData.ObjectWithPersistentMember;
        END_VAR
    END_CLASS

END_NAMESPACE