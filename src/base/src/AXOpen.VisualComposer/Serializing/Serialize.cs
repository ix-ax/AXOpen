using System.Text.Json;

namespace AXOpen.VisualComposer.Serializing
{
    internal static class Serializing<T>
    {
        internal static void Serialize(string filePath, T serialize)
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

        internal static T? Deserialize(string filePath)
        {
            if (!File.Exists(filePath))
                return default;

            T? deserialize = default;
            try
            {
                using (FileStream fs = File.OpenRead(filePath))
                {
                    deserialize = JsonSerializer.Deserialize<T>(fs);
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
