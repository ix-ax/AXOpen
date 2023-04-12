using AXOpen.Data;

NAMESPACE AxoDataExamples

    {#ix-attr:[Container(Layout.Tabs)]}
    CLASS AxoTestData EXTENDS AXOpen.Data.AxoDataEntity
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
            TestDataStructude : AxoTestDataStructure;
            {#ix-attr:[Container(Layout.UniformGrid)]}
            TestDataStructude2 : AxoTestDataStructure;
            {#ix-attr:[Container(Layout.Stack)]}
            TestDataStructude3 : AxoTestDataStructure;
            {#ix-attr:[Container(Layout.Wrap)]}
            TestDataStructude4 : AxoTestDataStructure;
        END_VAR 
    END_CLASS    

   
END_NAMESPACE