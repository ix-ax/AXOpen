using Microsoft.AspNetCore.Components.Server.ProtectedBrowserStorage;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.VisualComposer.Serializing
{
    internal static class LocalStorage<T>
    {
        internal static async Task<T?> LoadAsync(ProtectedLocalStorage protectedLocalStorage, string key)
        {
            var result = await protectedLocalStorage.GetAsync<T>(key);

            if (result.Success && result.Value != null)
            {
                return result.Value;
            }

            return default;
        }

        internal static async Task SaveAsync(ProtectedLocalStorage protectedLocalStorage, string key, T data)
        {
            await protectedLocalStorage.SetAsync(key, data);
        }
    }
}
