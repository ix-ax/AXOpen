using System.Text.Json;

namespace AXOpen.VisualComposer.Serializing
{
    internal static class Serializing
    {
        internal static void Serialize(string filePath, List<SerializableVisualComposerItem> serialize)
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

        internal static List<SerializableVisualComposerItem>? Deserialize(string filePath)
        {
            if (!File.Exists(filePath))
                return null;

            List<SerializableVisualComposerItem>? deserialize = null;
            try
            {
                using (FileStream fs = File.OpenRead(filePath))
                {
                    deserialize = JsonSerializer.Deserialize<List<SerializableVisualComposerItem>>(fs);
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
