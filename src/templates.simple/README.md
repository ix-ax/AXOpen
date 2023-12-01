# AXOpen simple Blazor application template 

**IMPORTANT!!! When you create the project from Visual Studio, you will need to run `install.ps1` manually to finish creating the project.**


## Preparing your target PLC 

### Using TIA portal

If you use TIA portal for you hardware configuration you must enable WebAPI communication with your target PLC.

[How to set-up WebAPI in TIA portal](https://youtu.be/d9EX2FixY1A?t=151)

<iframe width="560" height="315" src="https://www.youtube.com/embed/d9EX2FixY1A?start=151" frameborder="0" allowfullscreen></iframe>


## Template directory scructure
```
your.project/
│
├── .config       [dotnet config]
├── .runtime      [contains kiosk client configuration]
├── .tests        [should contain tests of the application]
├── ax            [SIMATIC-AX application]
│
├── axpansion/
│   ├── server    [HMI server]
│   └── twin      [AX twin]
│ 
├── .gitignore    
│
├── README.md     [THIS README]
│
├── slngen.ps1          [Run to regenerate visual studio solution file]
├── axosimple.sln       [VS2022 solution file open to work with server, hmi, etc]
└── this.proj           [traversal project for this directory]
```

**Opening template from within the AXOpen repository**

When creating the template from within AXOpen repository the solution structure will look something like the schema below. You application template is in `.application` solution folder. Remember to set the the project contained in `server` folder to `Set as start-up project`:

- In the Solution Explorer, find the project you want to set as the startup project. The Solution Explorer is usually located on the right side of the Visual Studio interface, but its location may vary depending on your layout settings.

- Right-click on the desired project.

- From the context menu that appears, select "Set as StartUp Project".

- The project's name will now appear in bold in the Solution Explorer, indicating that it's the startup project. When you press F5 or click on the "Start Debugging" button, this project will be the one that runs.


```
Solution 'axiosimple' (25 of 25 projects)
├── **.application**
│   │
│   ├── **axpansion**
│   │   ├── **server**
│   │   └── **twin**
├── abstractions
├── base
├── components.abstractions
├── components.cognex.vision
├── components.elements
├── components.pneumatics
├── core
├── data
├── inspectors
├── security
├── simatic1500
├── timers
├── toolbox
└── utils

```

## Setting up the connection

### .NET


Go to [Entry.cs](axosimple.twin/Entry.cs) and setup the following parameters

~~~C#
private static string TargetIp = Environment.GetEnvironmentVariable("AXTARGET"); // <- replace by your IP 
private const string UserName = "Everybody"; //<- replace by user name you have set up in your WebAPI settings
private const string Pass = ""; // <- Pass in the password that you have set up for the user. NOT AS PLAIN TEXT! Use user secrets instead.
private const bool IgnoreSslErrors = true; // <- When you have your certificates in order set this to false.
~~~

You will need to use TIA Portal to enable WebAPI interface [see here](https://console.simatic-ax.siemens.io/docs/hwld/PlcWebServer) and [here](https://youtu.be/d9EX2FixY1A?t=151) is a very informative youtube video.


### AX

#### Connection parameters

Go to [apax.yml](app/apax.yml) file and adjust the connection parameters

~~~yml
.
.
.
scripts:
  download :   
     # Here you will need to set the argumen -t to your plc IP and -i to platfrom you are dowloading to
     # --default-server-interface is a must if you are using WebAPI      
    - - apax sld load --accept-security-disclaimer -t $AXTARGET -i $AXTARGETPLATFORMINPUT -r
.
.
.
.
~~~

#### Target platform

Add or comment/uncomment your target system.

~~~yml
.
.
.
targets:
  - plcsim
  # - "1500"
  # - swcpu
  - llvm
.
.
.
~~~

## Download the project to the PLC

Navigate to your ax folder and run the script command:

~~~
PS [your_root_folder]\>apax download
~~~

## To quickly run the hmi

~~~
PS [your_root_folder]\>dotnet run --project ..\axosimple.app\axosimple.server.csproj
~~~

~~~
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5262
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
info: Microsoft.Hosting.Lifetime[0]
      Hosting environment: Development
info: Microsoft.Hosting.Lifetime[0]
.
.      
~~~

**To terminate the application press `ctrl+c`**

Navigate to the address indicated in "Now listening on:".

> NOTE!
> Your browser may redirect to https. In that case, temporarily disable the redirection. 
> (Opening the page in incognito mode should not redirect.)

## Modifying your HMI project

In Visual Studio (VS2022), open the solution file from the project folder `axosimple.sln`. You can then run the solution directly from Visual Studio.

> **NOTE: Security is set to a minimal level for a speedy start. Make sure you set the security appropriately**.

## Other usefull scripts

Build both AX and AX# part of the project and DOWNLOADS the program to the target controller
```
apax push
```

Downloads current build into the controller.
```
apax download
```

Build the both SIMATIC-AX and AXOpen projects.
```
apax build
```

Running ixc
```
dotnet ixc
```


## Resources

Documentation sources: 
- `docs` in this folder
- [AXOpen]https://ix-ax.github.io/AXOpen/
- [AX#]https://ix-ax.github.io/axsharp/
