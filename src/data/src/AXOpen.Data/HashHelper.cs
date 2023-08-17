using Microsoft.AspNetCore.Identity;
using Newtonsoft.Json.Linq;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace AXOpen.Data
{
    public static class HashHelper
    {
        public static string CreateHash(Pocos.AXOpen.Data.IAxoDataEntity dataEntity)
        {
            return new PasswordHasher<Pocos.AXOpen.Data.IAxoDataEntity>().HashPassword(dataEntity, CreateStringToHash(dataEntity));
        }

        public static bool VerifyHash(Pocos.AXOpen.Data.IAxoDataEntity dataEntity, IIdentity identity)
        {
            try
            {
                var result = new PasswordHasher<Pocos.AXOpen.Data.IAxoDataEntity>().VerifyHashedPassword(dataEntity, dataEntity.Hash, CreateStringToHash(dataEntity)) != PasswordVerificationResult.Failed;
                if (!result)
                    AxoApplication.Current.Logger.Information($"Data {dataEntity} has been modified from outside.", identity);
                return result;
            }
            catch (Exception)
            {
                return false;
            }
        }

        private static string CreateStringToHash(object @object)
        {
            if (@object == null)
                return string.Empty;

            string stringToHash = string.Empty;

            foreach (PropertyInfo property in @object.GetType().GetProperties())
            {
                object propValue = property.GetValue(@object, null);
                if (property.PropertyType.IsValueType || property.PropertyType == typeof(string))
                {
                    if (property.Name == "Hash" || property.Name == "DataEntityId" || propValue == null)
                        continue;
                    stringToHash += propValue.ToString();
                }
                else if (typeof(IEnumerable).IsAssignableFrom(property.PropertyType))
                {
                    IEnumerable enumerable = (IEnumerable)propValue;
                    foreach (object child in enumerable)
                        stringToHash += CreateStringToHash(child);
                }
                else
                {
                    stringToHash += CreateStringToHash(propValue);
                }
            }
            return stringToHash;
        }
    }
}
