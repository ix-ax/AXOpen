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
                    AxoApplication.Current.Logger.Information($"Data {dataEntity} has external modifications.", identity);
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
                object? propValue = property.GetValue(@object, null);

                if (property.Name == "Hash" || property.Name == "RecordId" || propValue == null)
                    continue;

                if (property.PropertyType.IsValueType || property.PropertyType == typeof(string) || property.PropertyType == typeof(System.Object))
                {
                    switch (propValue.GetType().ToString())
                    {
                        case "System.DateOnly":
                            stringToHash += ((DateOnly)propValue).DayNumber;
                            break;
                        case "System.DateTime":
                            stringToHash += ((DateTime)propValue).Ticks;
                            break;
                        case "System.DateTimeOffset":
                            stringToHash += ((DateTimeOffset)propValue).Ticks;
                            break;
                        case "System.TimeOnly":
                            stringToHash += ((TimeOnly)propValue).Ticks;
                            break;
                        case "System.TimeSpan":
                            stringToHash += ((TimeSpan)propValue).Ticks;
                            break;
                        default:
                            stringToHash += propValue.ToString();
                            break;
                    }
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
