# DocFX Material

A simple material theme for [DocFX](https://dotnet.github.io/docfx/). This is an
override of the **default** template so you need to enable both in the `docfx.json`.

The colors were chosen using <https://material.io/tools/color>.

![DocFX Material Site](./images/classic/docfx-screenshot.png)

## Install

1. Download the source or the zipped file from the [releases](https://github.com/ovasquez/docfx-material/releases).
2. Create a `templates` folder in the root of your DocFX directory.
3. Copy the `material-classic` folder to the `templates` folder.
4. Update the `docfx.json` configuration to include the material template:
    ```json
    {
        "template": [
            "default",
            "templates/material-classic"
        ],
    }
    ```

## Color customization

You can easily customize the color of the header bar and the links by updating
the following variables in the `material-classic/styles/main.css` file.

```css
/* COLOR VARIABLES*/
:root {
  --header-bg-color: #0d47a1;
  --header-ft-color: #fff;
  --highlight-light: #5e92f3;
  --highlight-dark: #003c8f;
  --font-color: #34393e;
}
```

## Markdown extras

For more reference about markdown support in DocFX check the
[official documentation.](https://dotnet.github.io/docfx/spec/docfx_flavored_markdown.html?tabs=tabid-1%2Ctabid-a#note-warningtipimportant) 

> [!NOTE]
> This is a note which needs your attention, but it's not super important.
>
> [!WARNING]
> This is a warning containing some important message.
>
> [!CAUTION]
> This is a warning containing some **very** important message.

## DocFX tips

### Enable search

To enable search in DocFX it's not enough to set the configuration parameter to `true`:

```json
"globalMetadata": {
    "_enableSearch": "true"
}
```

You also have to indicate in the `docfx.json` the post processor that generates the index for the searches:

```json
"postProcessors": ["ExtractSearchIndex"],
```
