﻿using System;
using AXOpen.Base.Data;
using AXOpen.Data;
using AXOpen.Data.Json;

namespace Ix.Repository.Json
{
    public static class Repository
    {
        public static IRepository<T> Factory<T>(JsonRepositorySettings<T> parameters) where T : IBrowsableDataObject
        {
            try
            {
                return new JsonRepository<T>(parameters);
            }
            catch (Exception ex)
            {

                throw new Exception($"Creation of JsonFile repository failed. Check number, type and value of parameters. For detail see inner exception.", ex);
            }

        }
    }
}
