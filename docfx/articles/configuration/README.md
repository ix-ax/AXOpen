# How to configure Blazor server for Siemens panel

To configure Blazor Server, you need to follow these two steps:

## 1. Change the default IP Address

To modify the IP address of the website, you have two options:

1. In Program.cs
Inside the Program.cs file, add the following lines to specify the URLs:

    ~~~ C#
    builder.WebHost.UseUrls("http://10.10.10.198:5262;https://10.10.10.198:7292");
    ~~~

    or

    ~~~ C#
    builder.WebHost.UseUrls("http://*:5262;https://*:7292");
    ~~~

2. In launchSettings.json
Open the launchSettings.json file and modify the 'applicationUrl' under the profiles section. For example:

~~~ JSON
"applicationUrl": "http://10.10.10.198:5262;https://10.10.10.198:7292"
~~~

Please note that the IP address corresponds to the IP address of your network adapter.

## 2. Add rules to the firewall

Follow these steps to add rules for the desired ports in the Windows Defender Firewall:

1. Go to Control Panel > Windows Defender Firewall > Advanced Settings

2. In the Inbound Rules section, add the rules for the ports you wish to use.

If you are using Eset, you should perform the following steps:

1. Navigate to Eset > Setup > Network > Click on settings next to Firewall > Configure.

2. Check the option `Also evaluate rules from Windows Firewall`` or add the rule directly in Eset.
If you using Eset you need to: Eset > Setup > Network > click on settings next to Firewall > Configure

### Warning

If you intend to use HTTPS with a self-signed SSL certificate, make sure to adjust the `BypassSSLCertificate` parameter in `AxoDialogLocator` to `true`, where the default value is `false`. Here's an example of how to do it:

~~~ HTML
<AxoDialogLocator BypassSSLCertificate=true ObservedObjects="new[] {Entry.Plc.Context.PneumaticManipulator}"></AxoDialogLocator>
~~~
