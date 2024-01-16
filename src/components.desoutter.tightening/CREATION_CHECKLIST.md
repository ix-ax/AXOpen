## Code

- [ ] Does code follow recomendations from [conventions](../../docfx/articles/guidelines/Conventions.md) and [component convetions](../../docfx/articles/guidelines/components.md.md)?


## Testing

- [ ] Are all publicly exposed members unit-tested using axunit?
- [ ] Is the axunit-test coverage at min level of 60%?
- [ ] Are all extended twins tested and is the coverage at min level of 60% ?
- [ ] Are all extended twins tested and is the coverage at min level of 60% ?

## Build

- [X] Did you add this library to [build list](../../cake/BuildContext.cs#Libraries)?
- [ ] Did you add place the library in the [list](../../cake/BuildContext.cs#Libraries) past its dependencies?
- [ ] Did you add this library `src` folder to  [build list](../../src/AXOpen-packable-only.proj)?
- [ ] Did you remove all project from the `src` folder that should not be packed? 
- [ ] Does the build with test level L2 passes locally? 

## Documentation

- The documentation should be CONCISE delivering nessary information about the usage of the library. 
- The documentation should not explain details about internals of the library limit yourself on explaing how to use, not how it is made. Should it be necessary to explain some aspects in detail write an article instead.
- Do not explain HOW the parts of the library operate but WHAT they do.
- Focus on creating usable examples
- Examples should not be hard-written into to documents, but referenced from the [documentation project](app), the [ComponentTemplate](docs/ComponentTemplate.md) scaffolds the document with example references to documenation project

## General
- [ ] Does [README.md](./docs/README.md) contain general description of the library?
- [ ] Is the link to this documentation added to the [toc.yaml](../../docfx/components/toc.yml)?

### CTRL README.md
- [ ] Does [README.md](./ctrl/README.md) for controller contain information about apax package installation instructions?
- [ ] Does [README.md](./ctrl/README.md) for controller contain link to API documentation?
- [ ] Are there any additional requirement regarding usage of this package listed in this [README.md](./ctrl/README.md)?

### .NET TWIN README.md
- [ ] Does [README.md](./src/AXOpen.Components.Desoutter.Tightening/README.md) for .NET TWIN contain information with installation instructions?
- [ ] Does [README.md](./src/AXOpen.Components.Desoutter.Tightening/README.md) for .NET TWIN contain link to API documentation?
- [ ] Are there any additional requirement regarding usage of this nuget package listed in this [README.md](./src/AXOpen.Components.Desoutter.Tightening/README.md)?

### BLAZOR README.md
- [ ] Does [README.md](./src/AXOpen.Components.Desoutter.Tightening.blazor/README.md) contain information with installation instructions?
- [ ] Does [README.md](./src/AXOpen.Components.Desoutter.Tightening.blazor/README.md) contain link to API documentation?
- [ ] Are there any additional requirement regarding usage of this nuget package listed in this [README.md](./src/AXOpen.Components.Desoutter.Tightening/README.md)?


### Components

- [ ] Does [toc.yml](./docs/toc.yml) contain references to documenation to all components in this library?
- [ ] Does each component in this library has single md file with examples references from the code and structured according to [ComponentTemplate.md](./docs/ComponentTemplate.md)?

