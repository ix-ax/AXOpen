{#ix-attr:[Container(Layout.Tabs)]}
{#ix-attr:[Group(GroupLayout.GroupBox)]}
{#ix-set:AttributeName = "This is some structure"}
CLASS PUBLIC Recipe
    VAR PUBLIC            
        Header : ReciepeHeader;       
        Measurements : Measurements;
        Colors : Colors;
    END_VAR    
END_CLASS

TYPE
    Colors : (RED, GREEN, BLUE);
END_TYPE

{#ix-attr:[Container(Layout.Stack)]}
CLASS PUBLIC ReciepeHeader
    VAR PUBLIC
        Name : STRING;        	
    END_VAR    
END_CLASS 

{#ix-attr:[Container(Layout.Tabs)]}
CLASS PUBLIC Measurements
    VAR PUBLIC
        {#ix-set:AttributeName = "Dimension X"}
        DimX : ContinuesValueCheckData;
        {#ix-set:AttributeName = "Dimension Y"}
        DimY : ContinuesValueCheckData;
        {#ix-set:AttributeName = "Dimension Z"}
        DimZ : ContinuesValueCheckData;   
        {#ix-set:AttributeName = "Inside temp °C"}   
        TemperatureIn : ContinuesValueCheckData; 
        {#ix-set:AttributeName = "Outside temp °C"}   
        TemperatureOut : ContinuesValueCheckData;
    END_VAR    
END_CLASS  

{#ix-attr:[Container(Layout.Wrap)]}
{#ix-attr:[Group(GroupLayout.GroupBox)]}
CLASS PUBLIC ContinuesValueCheckData
    VAR PUBLIC        
        Min : REAL;
        Measured : REAL;
        Max : REAL;        
    END_VAR    
END_CLASS