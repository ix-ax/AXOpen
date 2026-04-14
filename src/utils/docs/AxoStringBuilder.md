# AxoStringBuilder

`AxoStringBuilder` is a fluent string builder that assembles composite strings from multiple typed values. It implements the `IAxoStringBuilder` interface and supports 22 `Append` overloads covering all standard Structured Text data types (BOOL, BYTE, WORD, DWORD, LWORD, SINT, INT, DINT, LINT, USINT, UINT, UDINT, ULINT, REAL, LREAL, STRING, CHAR, TIME, LTIME, DATE, DATE_AND_TIME, and TIME_OF_DAY).

## Fluent API

The builder follows a fluent pattern where you chain calls to build a string incrementally:

1. Call `Clear()` to reset the internal buffer.
2. Call `Append(value)` one or more times to add typed values.
3. Call `AsString()` to retrieve the result as `STRING[254]`, or `AsString160()` for `STRING[160]`.

Each `Append` call converts the given value to its string representation and concatenates it to the internal buffer.

## Usage

### CONTROLLER

#### Declarations

[!code-smalltalk[](../../showcase/app/src/utils/UtilsShowcase.st?name=UtilsDeclarations)]

#### Building a string

[!code-smalltalk[](../../showcase/app/src/utils/UtilsShowcase.st?name=StringBuilderUsage)]

The example above produces a string such as `Part ID: 42 | Weight: 3.14` by appending string literals and numeric values in sequence.
