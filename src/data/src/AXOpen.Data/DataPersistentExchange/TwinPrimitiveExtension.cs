using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using System;

namespace AXOpen.Data
{
    public static class TwinPrimitiveExtension
    {

        public const string CyclicPropertyName = "Cyclic";

        public static TagObject AsNewTagObject(this ITwinPrimitive primitive)
        {
            var tagObject = new TagObject();

            var onlinerType = primitive.GetType();
            var propertyInfo = onlinerType.GetProperty(CyclicPropertyName);

            tagObject.ValueType = propertyInfo.PropertyType.FullName;
            tagObject.Symbol = primitive.Symbol;
            tagObject.Value = propertyInfo.GetValue(primitive);

            return tagObject;
        }

        public static void SetTagCyclicValue(this ITwinPrimitive primitive, TagObject tagFromRepo)
        {
           
            var cyclicPropertyInfo = primitive.GetType().GetProperty(CyclicPropertyName);

            if (cyclicPropertyInfo != null && cyclicPropertyInfo.CanWrite)
            {
                var castedValue = Convert.ChangeType(tagFromRepo.Value, cyclicPropertyInfo.PropertyType);
                cyclicPropertyInfo.SetValue(primitive, castedValue);
            }
            else
            {
                throw new ArgumentException($"Property Cyclic was not found on tag {tagFromRepo.Symbol}!");
            }
        }



    }
}