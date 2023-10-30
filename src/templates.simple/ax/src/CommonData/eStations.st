
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
            CU_10 := 10,

            ///<summary>
            /// Last Station in Technology, Close entity and save data.
            ///</summary>
            CU_100 := 100

        ) :=  None;
    END_TYPE
END_NAMESPACE
