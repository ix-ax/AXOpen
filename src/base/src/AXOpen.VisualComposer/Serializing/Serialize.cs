using System.Text.Json;

namespace AXOpen.VisualComposer.Serializing
{
    internal static class Serializing<T>
    {
        internal static async Task SerializeAsync(string filePath, T serialize)
        {
            try
            {
                using (FileStream fs = File.Create(filePath))
                {
                    await JsonSerializer.SerializeAsync(fs, serialize, new JsonSerializerOptions{ WriteIndented = true });
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

        internal static async Task<T?> DeserializeAsync(string filePath)
        {
            if (!File.Exists(filePath))
                return default;

            T? deserialize = default;
            try
            {
                using (FileStream fs = File.OpenRead(filePath))
                {
                    deserialize = await JsonSerializer.DeserializeAsync<T>(fs);
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
