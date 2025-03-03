namespace Tests_L4
{
    using AXOpen.Base.Data.Query;
    using Pocos.Exchange_Test_L4;
    using System;
    using System.Linq;
    using System.Linq.Expressions;
    using System.Reflection.Emit;
    using Xunit;

    public static class Constants 
    {
        public const string TESTS_MONGO = "TEST_MONGO";
        public const string TESTS_JSON = "TEST_JSON";
        public const string TESTS_MEMORY = "TEST_MEMORY";
        public const string TESTS_RAVEN = "TEST_RAVEN";


        public const string MONGO_REPOSITORY_NAME = "AxOpen_L4";
        public const string MONGO_SIMPLE_COLLECTION_NAME = "DataTestObject";
        public const string MONGO_COMPOUD_HEADER_COLLECTION_NAME = "SharedHeader";
        public const string MONGO_COMPOUD_STATION_COLLECTION_NAME = "Station";

        public const string JSON_REPOSITORY_FOLDER_NAME = "AxOpen_L4_JSON";


        public const string MEMBER_NAME_ENTITY_ID = "DataEntityId";
    }
}