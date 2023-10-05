
**NuGet package feed**

>[!IMPORTANT]
> **NuGet pacakges are now published experimentally**

This nuget package's feed is hosted on github on how to authenticate to the feed see the documentation [here](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-nuget-registry).

~~~bash
dotnet nuget add source --username GITHUBUSERNAME --password PAT  --store-password-in-clear-text --name gh-packages-ix-ax "https://nuget.pkg.github.com/ix-ax/index.json"
~~~

Replace GITHUBUSERNAME with your github name
Replace PAT with your Personal Access Token ([how to create your PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token))


>[!NOTE]
> Please notice that all AXOpen packages are being released from a single repository and version numbers are aligned. You can use different versions that have major version number alligned should it be necessary, however we strongly recommend to use pacakge with the same version number, such packages are being built and tested together to enshure best experience.



