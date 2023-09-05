# Using Assets in package

When working with static assets in a Blazor package project(bootstap icons, images, styles, ...), for proper function need to be reference like: `_content/{PACKAGE ID}/{PATH AND FILE NAME}`.

For example:

~~~ HTML
<img src="_content/AXOpen.Data.Blazor/bootstrap-icons-1.8.2/download.svg" />
~~~

NOT only direct reference, as this approach may not function correctly when you're utilizing assets outside of the default project.

~~~ HTML
<img src="/bootstrap-icons-1.8.2/download.svg" />
~~~

For more information, refer Microsoft documentation:
[Microsoft docs](https://learn.microsoft.com/en-us/aspnet/core/blazor/components/class-libraries?view=aspnetcore-6.0&tabs=visual-studio#create-an-rcl-with-static-assets-in-the-wwwroot-folder)