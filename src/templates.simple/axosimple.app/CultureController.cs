using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Localization;
using Microsoft.AspNetCore.Mvc;

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
        }

        return Redirect("/");
    }
}