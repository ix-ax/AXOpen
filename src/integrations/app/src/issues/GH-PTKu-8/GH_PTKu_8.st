NAMESPACE Layouts.Tabbed
    {S7.extern=ReadWrite}
    CLASS PUBLIC weather  EXTENDS weatherBase 
        VAR PUBLIC
            Latitude : REAL;       
            Longitude : REAL;       
            Altitude : REAL;       
            Description : STRING;      
            LongDescription : STRING;   
          END_VAR               
    END_CLASS    
END_NAMESPACE 

{S7.extern=ReadWrite}
CLASS PUBLIC weatherBase
    VAR PUBLIC
      baseLatitude : REAL;       
      baseLongitude : REAL;       
      baseAltitude : REAL;       
      baseDescription : STRING;      
      baseLongDescription : STRING;   
    END_VAR  
  END_CLASS 
