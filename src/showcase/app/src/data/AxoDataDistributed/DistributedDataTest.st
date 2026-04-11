// USING AXOpen.Core;
// USING AXOpen.Data;

// NAMESPACE DistributedDataTest  

//     {S7.extern=ReadWrite}
//     CLASS PUBLIC Context EXTENDS AXOpen.Core.AxoObject
//         VAR PUBLIC

//             {#ix-attr:[AXOpen.Data.DistributedDataAttribute("Group_1")]}
//             HeaderManager_1 : DistributedDataTest.HeaderManager; 
            
//             {#ix-attr:[AXOpen.Data.DistributedDataAttribute("Group_1", "Group_2")]}
//             HeaderManager_2 : DistributedDataTest.HeaderManager; 
            
//             {#ix-attr:[AXOpen.Data.DistributedDataAttribute("Group_1", "Group_2", "Group_3")]}
//             StationManager_1 : DistributedDataTest.StationManager;
            
//             {#ix-attr:[AXOpen.Data.DistributedDataAttribute("Group_1", "Group_2", "Group_3", "Group_4")]}
//             StationManager_2 : DistributedDataTest.StationManager;

//             {#ix-attr:[AXOpen.Data.DistributedDataAttribute("AxoDataFragmentExchange")]}
//             Fragment : DistributedDataTest.FragmentExchange;

//             {#ix-attr:[AXOpen.Data.DistributedDataAttribute("AxoObjectWrap")]}
//             AxoProcess : DistributedDataTest.AxoProcess;

//         END_VAR
        
       
//     END_CLASS

//     {S7.extern=ReadWrite}
//     CLASS PUBLIC AxoProcess
//         EXTENDS AXOpen.Core.AxoObject
//         VAR PUBLIC                    
//             Header : HeaderManager;            
//             Station_1 : StationManager;
//             Station_2 : StationManager;
//         END_VAR
//     END_CLASS

//     {S7.extern=ReadWrite}
//     CLASS PUBLIC FragmentExchange
//         EXTENDS AXOpen.Data.AxoDataFragmentExchange
//         VAR PUBLIC                    
//             {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
//             Header : HeaderManager;            
//             {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
//             Station_1 : StationManager;
//             {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
//             Station_2 : StationManager;
//         END_VAR
//     END_CLASS

//     {S7.extern=ReadWrite}
//     CLASS PUBLIC HeaderManager
//         EXTENDS AXOpen.Data.AxoDataExchange
//         VAR PUBLIC
//             {#ix-generic:TOnline}
//             {#ix-generic:TPlain as POCO}
//             {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}
//             {#ix-attr:[Container(Layout.Stack)]} 
//             {#ix-set:AttributeName = "Shared Header"}
//             Set : HeaderData;
//         END_VAR
//     END_CLASS

//     {S7.extern=ReadWrite}
//     CLASS PUBLIC HeaderData
//         EXTENDS AXOpen.Data.AxoDataEntity
//         VAR PUBLIC
//             HeaderPartialName : STRING;
//             HeaderIndex : INT;
//             HeaderGlogalPass : BOOL;
//         END_VAR      
//     END_CLASS
        
//     {S7.extern=ReadWrite}
//     CLASS PUBLIC StationManager
//         EXTENDS AXOpen.Data.AxoDataExchange
//         VAR PUBLIC
//             {#ix-generic:TOnline}
//             {#ix-generic:TPlain as POCO}
//             {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}        
//             {#ix-attr:[Container(Layout.Stack)]}    
//             {#ix-set:AttributeName = "Station"}    
//             Set : StationData;
//         END_VAR
//     END_CLASS

//     {S7.extern=ReadWrite}
//     CLASS PUBLIC StationData EXTENDS AXOpen.Data.AxoDataEntity
//         VAR PUBLIC
//             StationName : STRING;
//             StaionOperation : INT;
//             StationPass : BOOL;
//         END_VAR
//     END_CLASS


// END_NAMESPACE
