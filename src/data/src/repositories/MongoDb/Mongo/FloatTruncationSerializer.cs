﻿using MongoDB.Bson.Serialization;
using MongoDB.Bson.Serialization.Serializers;
using System;

namespace AXOpen.Data.MongoDb
{
    /// <summary>
    /// Writes the float value to mongo as double as reads it back as float.    
    /// </summary>
    public class FloatTruncationSerializer : SerializerBase<float>
    {
        /// <inheritdoc/>
        public override float Deserialize(BsonDeserializationContext context, BsonDeserializationArgs args)
        {
            var value = context.Reader.ReadDouble();
            if (value == double.Epsilon)
                return float.Epsilon;
            else
                return (float)value;
        }

        /// <inheritdoc/>
        public override void Serialize(BsonSerializationContext context, BsonSerializationArgs args, float value)
        {
            if(value == float.Epsilon)
                context.Writer.WriteDouble(double.Epsilon);
            else
                context.Writer.WriteDouble(Math.Round(value,10));
        }
    }


    public class DateOnlySerializer : SerializerBase<DateOnly>
    {
        public override DateOnly Deserialize(BsonDeserializationContext context, BsonDeserializationArgs args)
        {
            var date = BsonSerializer.Deserialize<DateTime>(context.Reader);
            return DateOnly.FromDateTime(date);
        }

        public override void Serialize(BsonSerializationContext context, BsonSerializationArgs args, DateOnly value)
        {
            BsonSerializer.Serialize(context.Writer, value.ToDateTime(new TimeOnly(0, 0)));
        }
    }

}
