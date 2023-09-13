using MongoDB.Bson;
using MongoDB.Bson.Serialization;
using MongoDB.Bson.Serialization.Serializers;
using System;

namespace AXOpen.Data.MongoDb
{
    /// <summary>
    /// Writes the DateOnly value to mongo as string as reads it back as DateOnly.
    /// </summary>
    public class DateOnlySerializer : StructSerializerBase<DateOnly>
    {
        /// <inheritdoc/>
        public override void Serialize(BsonSerializationContext context, BsonSerializationArgs args, DateOnly value)
        {
            context.Writer.WriteString(value.ToString());
        }

        /// <inheritdoc/>
        public override DateOnly Deserialize(BsonDeserializationContext context, BsonDeserializationArgs args)
        {
            return System.DateOnly.Parse(context.Reader.ReadString());
        }
    }
}
