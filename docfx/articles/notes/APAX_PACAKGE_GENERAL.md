
**APAX package registry**

>[!IMPORTANT]
> **APAX pacakges are now published experimentally**

This apax package's registry is hosted on github on how to authenticate to the registry see the documentation [here](https://console.simatic-ax.siemens.io/docs/faq/login-to-external-registries) and [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens).

~~~bash
apax login --registry https://npm.pkg.github.com --username GH_USER_NAME --password PAT
~~~

Add registry to your `apax.yml` file.

~~~yml
registries: 
  "@ix-ax": https://npm.pkg.github.com/
~~~

>[!NOTE]
> Please notice that all AXOpen packages are being released from a single repository and version numbers are aligned. You can use different versions that have major version number alligned should it be necessary, however we strongly recommend to use pacakge with the same version number, such packages are being built and tested together to enshure best experience.



