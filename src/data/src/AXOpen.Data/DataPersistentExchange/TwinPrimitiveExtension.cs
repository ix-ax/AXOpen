using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using System;

namespace AXOpen.Data
{
    public static class TwinPrimitiveExtension
    {

        public const string CyclicPropertyName = "Cyclic";
        public const string LethargicWriteMethodName = "LethargicWrite";

        /// <summary>
        /// Creates a new <see cref="TagObject"/> from an <see cref="ITwinPrimitive"/>.
        /// </summary>
        /// <param name="primitive">The twin primitive to create a tag object from.</param>
        /// <returns>A new <see cref="TagObject"/> instance.</returns>
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

        /// <summary>
        /// Sets the value of a twin primitive using the 'LethargicWrite' method to avoid inconsistencies in cyclic writing.
        /// </summary>
        /// <remarks>
        /// Writing through the Cyclic property adds the variable to cyclic writing, which may lead to inconsistencies.
        /// Therefore, this method uses 'LethargicWrite' to set the value.
        /// </remarks>
        /// <param name="primitive">The twin primitive to update.</param>
        /// <param name="tagFromRepo">The tag object containing the value to set.</param>
        /// <exception cref="ArgumentException">Thrown if the 'Cyclic' property or 'LethargicWrite' method is not found.</exception>
        public static void SetTagCyclicValueUsingLethargicWrite(this ITwinPrimitive primitive, TagObject tagFromRepo)
        {
            var lethargicWriteMethodInfo = primitive.GetType().GetMethod(LethargicWriteMethodName);

            if (lethargicWriteMethodInfo != null)
            {
                var cyclicPropertyInfo = primitive.GetType().GetProperty(CyclicPropertyName);
                if (cyclicPropertyInfo == null)
                {
                    throw new ArgumentException($"Property Cyclic was not found on tag {tagFromRepo.Symbol}!");
                }

                var castedValue = Convert.ChangeType(tagFromRepo.Value, cyclicPropertyInfo.PropertyType);
                lethargicWriteMethodInfo.Invoke(primitive, new[] { castedValue });
            }
            else
            {
                throw new ArgumentException($"Method {LethargicWriteMethodName} was not found on tag {tagFromRepo.Symbol}!");
            }
        }

        //public static void SetTagCyclicValue(this ITwinPrimitive primitive, TagObject tagFromRepo)
        //{
        //    var cyclicPropertyInfo = primitive.GetType().GetProperty(CyclicPropertyName);

        //    if (cyclicPropertyInfo != null && cyclicPropertyInfo.CanWrite)
        //    {
        //        var castedValue = Convert.ChangeType(tagFromRepo.Value, cyclicPropertyInfo.PropertyType);
        //        cyclicPropertyInfo.SetValue(primitive, castedValue);
        //    }
        //    else
        //    {
        //        throw new ArgumentException($"Property Cyclic was not found on tag {tagFromRepo.Symbol}!");
        //    }
        //}
    }
}