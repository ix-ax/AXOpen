## 1. Create Controlled Unit (CU)

Install to AxCode extension: CodeTour.
When you open the Template poject in AxCode extension CodeTour automaticaly open code tour that describe all steps that are needed for scaffold of CU. Template project also contains all snippets for scaffolding.

![](assets\CodeTour.png)

## 2. Apax AddUnit
Template.Simple project contains apax script for adding CU. When you execute next apax command, it will add new CU from template to project structure.
> [!NOTE] Use this name in all snippets!
```
apax addunit
```
## 3. CU declaration
Declaraton of CU is placed to `ax\src\Context.st`. Context is the root of Technology. On the same layer is defined instance of other data`s object due to allowed depth of structure.  There is prepared snippet for adding unit declaraion. 

 ![Unit Declaration](assets\UnitDeclaration.png)

## 4. CU number
For part flow in the technology is used unique CU number. It is defined in file  `ax\src\CommonData\eStations.st`.

## 5. CU root call
CU logic needs to be called in `ax\src\Context.st`.

![Unit root call](assets\UnitRootCall.png)

## 6. Add CU Process Data 
CU Process data needs to be added to global process data manager. 
`ax\src\Context.st`.
![Add CU to Process data ](assets\AddUnitProcessData.png)


## 7. Add CU Technology Data 
CU Technology data needs to be added to global technology data manager. 
`ax\src\Context.st`.

![Add CU to Technology data ](assets\AddUnitTechnologyData.png)


## 8. Initialize CU repository (.net) 
On .net side must be initialized repository that will be used by DataExchange instace.
![Add CU repositories](assets\AddUnitRepositories.png)


## 9. Connect Plc data with Server in (.net) 
Script that add CU also create a CUService.cs file that initilize Process and technology data. But connection or call with instance of the repository needs to be done manualy.
![Connect PLC CU with Server](assets\ConnectPlcWithServer.png)


## 10. Add CU To Units View (*.blazor) 
In HMI Units view are displayed all CU that are in Technology. Also must be specified munualy logo an name of controlled unit.

[!include[Ref](Navigation.md)]
