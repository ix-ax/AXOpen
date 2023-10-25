using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace Draggable.Serializing
{
    internal static class Serializing
    {
        internal static void Serialize(string filePath, List<SerializableDraggableItem> serialize)
        {
            try
            {
                using (FileStream fs = File.Create(filePath))
                {
                    JsonSerializer.Serialize(fs, serialize, new JsonSerializerOptions{ WriteIndented = true });
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
            }
        }

        internal static List<SerializableDraggableItem>? Deserialize(string filePath)
        {
            if (!File.Exists(filePath))
                return null;

            List<SerializableDraggableItem>? deserialize = null;
            try
            {
                using (FileStream fs = File.OpenRead(filePath))
                {
                    deserialize = JsonSerializer.Deserialize<List<SerializableDraggableItem>>(fs);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
            }

            return deserialize;
        }
    }
}
