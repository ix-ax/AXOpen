using System;
using System.Reflection;

namespace AXOpen.Base
{
    public static class PropertyHelper
    {
        public static object? GetPropertyValue(object obj, string propertyPath)
        {
            if (obj == null)
                throw new ArgumentNullException(nameof(obj));

            if (string.IsNullOrEmpty(propertyPath))
                throw new ArgumentNullException(nameof(propertyPath));

            string[] properties = propertyPath.Split('.');
            foreach (string property in properties)
            {
                if (obj == null) return null;

                PropertyInfo propertyInfo = obj.GetType().GetProperty(property);
                if (propertyInfo == null)
                    throw new ArgumentException($"Property '{property}' not found on '{obj.GetType().Name}'");

                obj = propertyInfo.GetValue(obj, null);
            }

            return obj;
        }
    }
}
