# Export/Import

If you want to be able to export data, you must add `CanExport` attribute with `true` value. Like this:

[!code-smalltalk[](../app/ix-blazor/librarytemplate.blazor/Pages/Testing.razor?name=Export)]

With this option, buttons for export and import data will appear. After clicking on the export button, the `.zip` file will be created, which contains all existing records. If you want to import data, you must upload `.zip` file with an equal data structure as we get in the export file.

![Export](assets/Export.png)

## Custom export

You have the option to customize the exported files according to your preferences. This includes selecting specific columns and rows, choosing the desired file type, and specifying the separator. It's important to note that if you don't select all columns for export, importing the files may not be done correctly.

During the importing process, it is crucial to enter the same separator that was used during the export. If the default separator was used during the export, there is no need to make any changes.

You also can create own exporter. To do this, you must create a class that implements `IDataExporter<TPlain, TOnline>` interface. This interface requires you to implement the `Export`, `Import` and `GetName` method. Once you've done this, your custom exporter will be displayed in the custom export and import modal view. Users will be able to choose the exported file type through this view.

For a better user experience, it is strongly recommended to clean the `Temp` directory when starting the application. The best way to do this is to add the following lines to the "Program.cs" file:

[!code-csharp[](../app/ix-blazor/librarytemplate.blazor/Program.cs?name=CleanUp)]

> [!IMPORTANT]
> Export and import function will create high load on the application. Don't use with large datasets. These function can be used only on a limited number (100 or less) documents. Typical used would be for recipes and settings, but not for large collections of production or event data.
