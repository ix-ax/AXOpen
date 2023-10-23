using AXOpen.Core.Blazor.Culture;
using Microsoft.AspNetCore.Localization;
using Microsoft.AspNetCore.Mvc;
using System.Globalization;
using AXSharp.Connector;

namespace axosimple.server.Controllers;

[Route("/[controller]")]
[ApiController]
public class CultureController : ControllerBase
{
    public async Task<ActionResult> ChangeCulture([FromQuery] string culture)
    {
        if (culture != null)
        {
            HttpContext.Response.Cookies.Append(
                CookieRequestCultureProvider.DefaultCookieName,
                CookieRequestCultureProvider.MakeCookieValue(
            new RequestCulture(culture, culture)));

            CultureExtensions.Culture = new CultureInfo(culture);
            Connector.SetCulture(CultureExtensions.Culture);
            
        }

        return Redirect("/");
    }
}