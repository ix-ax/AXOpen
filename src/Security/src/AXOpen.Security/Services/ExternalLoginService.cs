using Microsoft.JSInterop;
using System;
using System.Net.Http;
using System.Net.Http.Json;
using System.Threading.Tasks;

namespace AXOpen.Security.Services
{
    public class ExternalLoginService
    {
        private readonly HttpClient _httpClient;
        private readonly IJSRuntime _jsRuntime;

        public ExternalLoginService(HttpClient httpClient, IJSRuntime jsRuntime)
        {
            _httpClient = httpClient;
            _jsRuntime = jsRuntime;
        }

        public async Task<ExternalLoginResult> LoginWithExternalIdAsync(string externalAuthId, string? returnUrl = null)
        {
            try
            {
                var formData = new MultipartFormDataContent();
                formData.Add(new StringContent(externalAuthId), "externalAuthId");
                formData.Add(new StringContent(returnUrl ?? "/"), "returnUrl");

                var response = await _httpClient.PostAsync("/ExternalLogin", formData);
                
                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadFromJsonAsync<ExternalLoginResult>();
                    
                    if (result != null && result.Success && result.Action == "login")
                    {
                        // Reload the page to update authentication state
                        await _jsRuntime.InvokeVoidAsync("location.reload");
                    }
                    
                    return result ?? new ExternalLoginResult { Success = false, Message = "Invalid response" };
                }
                
                return new ExternalLoginResult { Success = false, Message = $"HTTP {response.StatusCode}" };
            }
            catch (Exception ex)
            {
                return new ExternalLoginResult { Success = false, Message = ex.Message };
            }
        }
    }

    public class ExternalLoginResult
    {
        public bool Success { get; set; }
        public string? Action { get; set; } // "login" or "logout"
        public string? Message { get; set; }
        public string? ReturnUrl { get; set; }
        public string? UserName { get; set; }
    }
}
