using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace librarytemplate.blazor.Controllers;

[Route("/[controller]")]
[ApiController]
public class ThemeController : ControllerBase
{
    public async Task<ActionResult> ChangeTheme([FromQuery] string theme)
    {
        Response.Cookies.Append("theme", theme);
        return Redirect("/");
    }
}
