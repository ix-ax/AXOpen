## PlainSymbolBuilder

`AXOpen.Data.Query.PlainSymbolBuilder` is a tool that scans a PLAIN object and generates a flat list of string-based **symbol paths** representing its properties. It is used when working with flattened filtering and querying.

---

### ✨ Features

- Recursively explores a PLAIN object.
- Returns full symbol paths as strings (e.g., `Root.PropertyA`, `Root.Nested.PropertyB`).
- Supports excluding properties:
  - From **specific interfaces**
  - From **specific types (including nested classes)**
  - From the **root type only**
  - Properties marked with `[PlainSymbolIgnoreAttribute]`

> [!IMPORTANT]  
> Exclusions are defined by a static list and affect your entire assembly or project.  
> For non-static exclusions, use the attribute on the desired property!

---

### 🛠️ How to Configure


Apply the `[PlainSymbolIgnoreAttribute]` attribute to properties to exclude them from the symbol list:

```csharp
[AXOpen.Data.Query.PlainSymbolIgnoreAttribute]
public string Hidden { get; set; }
```

"Exclude properties directly on all roots :

```csharp
AXOpen.Data.Query.PlainSymbolBuilder.IgnoreRootProperty("MyPropertyName");
```
Exclude properties defined on a specific type or its derived types:

```csharp
AXOpen.Data.Query.PlainSymbolBuilder.IgnoreProperty(typeof(MyEntityBase), "InternalCode");
```

Exclude properties defined by an interface. All implementing classes will respect this exclusion:

```csharp
AXOpen.Data.Query.PlainSymbolBuilder.IgnoreProperty(typeof(IPlain), "vBOOL");
```

>[!NOTE]
>"Hash", "Changes", and "RecordId" are ignored by default!
