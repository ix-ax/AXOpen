using ix.framework.data;

NAMESPACE ixDataExamples

    {#ix-attr:[Container(Layout.Tabs)]}
    CLASS IxTestData EXTENDS ix.framework.data.DataEntity
        VAR PUBLIC
            RecipeName : STRING;
            String1 : STRING;
            Int1 : INT;
            Bool1 : BOOL;
            String2 : STRING;
            Int2 : INT;
            Bool2 : BOOL;
            String3 : STRING;
            Int3 : INT;
            Bool3 : BOOL;            
            TestDataStructude : IxTestDataStructure;
            {#ix-attr:[Container(Layout.UniformGrid)]}
            TestDataStructude2 : IxTestDataStructure;
            {#ix-attr:[Container(Layout.Stack)]}
            TestDataStructude3 : IxTestDataStructure;
            {#ix-attr:[Container(Layout.Wrap)]}
            TestDataStructude4 : IxTestDataStructure;
        END_VAR 
    END_CLASS    

   
END_NAMESPACE