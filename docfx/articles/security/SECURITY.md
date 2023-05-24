# AXOpen.Security


overview
AxOpen.Security is library which provides authentication and authorization in Blazor AX applications. It is based on a default solution for authentication in Blazor which uses 
implemented repositories within Ax.Open.Data. As a result, multiple storage providers for security can be used. 

## Installation 

All necessary logic for security is located in AxOpen.Security library. 

### 1. Install AxOpen.Security NuGet package or add reference to this project from your Blazor application

### 2. Add reference to AxOpen.Security assembly. 

Go to `App.razor` and add `AdditionalAssemblies` as parameter of `Router` component. The following line must be added to `Router` component:

```C#
AdditionalAssemblies="new[] { typeof(BlazorSecurity).Assembly}">
```

Also, make sure, that `Router` component is wrapped inside `CascadingAuthenticationState` component. At the end, the `Router` component should look like this:

```html
<CascadingAuthenticationState>
    <Router AppAssembly="@typeof(App).Assembly" 
            AdditionalAssemblies="new[] { typeof(BlazorSecurity).Assembly}">
            ...
    </Router>
</CascadingAuthenticationState>
```

### 3. Configure Ax Blazor security services in dependency injection container of Blazor application located in `Program.cs` file.

To correctly configure security services you must:

- configure repository
- create in-app roles
- configure AxBlazorSecurity in DI container

#### **Configuring repository**
The security requires 2 instances of repositories:
- for persistence of user data
- for persistence of groups of roles

Within AXOpen 4 different types of repositories are available:
- InMemory
- Json
- MongoDB
- RavenDB

For example, the Json repository can be configured as follows:
```C#
static (IRepository<User>, IRepository<Group>) SetUpJson(string path ="\\JSONREPOS\\")
{
    var executingAssemblyFile = new FileInfo(Assembly.GetExecutingAssembly().Location);
    var repositoryDirectory = Path.GetFullPath($"{executingAssemblyFile.Directory}{path}");
    if (!Directory.Exists(repositoryDirectory))
    {
        Directory.CreateDirectory(repositoryDirectory);
    }
    IRepository<User> userRepo = new JsonRepository<User>(new JsonRepositorySettings<User>(Path.Combine(repositoryDirectory, "Users")));
    IRepository<Group> groupRepo = new JsonRepository<Group>(new JsonRepositorySettings<Group>(Path.Combine(repositoryDirectory, "Groups")));

    return (userRepo, groupRepo);
}

```

Add `SetUpJson` method in `Program.cs` file.

#### **Creating in-app roles**

In your Blazor application create new static class `Roles` and specify the roles, that will be used in your application. You can add as many roles as you want. The `Roles` class can be defined like this:

```C#
public static class Roles
{
    public static List<Role> CreateRoles()
    {
        var roles = new List<Role>
        {
            new Role(process_settings_access),
            new Role(process_traceability_access),
        };

        return roles;
    }

    public const string process_settings_access = nameof(process_settings_access);
    public const string process_traceability_access = nameof(process_traceability_access);
}
```

#### **Configure AxBlazorSecurity services**

Finally, the `AxBlazorSecurity` security can be configured in DI container of Blazor application. Go to `Program.cs` file and add following line to builder:

```C#
builder.Services.ConfigureAxBlazorSecurity(SetUpJSon(), Roles.CreateRoles());
```

The first parameter is set up repository and the second parameter are created roles.

## Add security views to application 

Go to `MainLayout.razor` located in `Shared` folder and add `LoginDisplay` view inside top bar.
```html
<main>
        <div class="top-row px-4 auth">
            <AxOpen.Security.Views.LoginDisplay/>
        </div>

        <article class="content px-4">
            @Body
        </article>
    </main>
```

Within `Pages` of the Blazor application, create new `Security.razor` page and add there `SecurityManagementView`.

```html
@page "/Security"

<h3>Security</h3>

<AxOpen.Security.Views.SecurityManagementView />

```

Add you security view inside the navigation menu in `NavMenu.razor`:

```html
<div class="nav-item px-3">
    <NavLink class="nav-link" href="security">
        <span class="oi oi-list-rich" aria-hidden="true"></span> Security
    </NavLink>
</div>
```

If everything done correctly, now security should be available in Blazor application.

security views
authorization

from view

from code