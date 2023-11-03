
NAMESPACE axosimple
    TYPE PUBLIC
        ///<summary>
        /// Station enum at whole Technology.
        ///</summary>
        eStations : INT
        (		
            None := 0,

            ///<summary>
            /// Fist Station in Technology, Create data with unique identifier.
            ///</summary>
            StarterUnitTemplate := 1,
            UnitTemplate := 1,

            // examples...
            CU_1 := 1,
            CU_2 := 2,
            CU_3 := 3,
            // examples...
            CU_10 := 10,
            CU_20 := 20,
            CU_30 := 30,

            ///<summary>
            /// Last Station in Technology, Close entity and save data.
            ///</summary>
            CU_100 := 100

        ) :=  None;
    END_TYPE
END_NAMESPACE
