# AXOpen.Utils

[!INCLUDE [General](../../../docfx/articles/notes/LIBRARYHEADER.md)]

**AXOpen.Utils** provides general-purpose utility functions for string building, CRC checksum calculation, and byte conversion. These are foundational helpers used across AXOpen applications when you need to compose diagnostic strings, verify data integrity, or interpret raw byte sequences.

The library contains the following components:

- **AxoStringBuilder** -- a fluent string builder that concatenates values of any Structured Text data type into a single string.
- **AxoCRC_8, AxoCRC_16, AxoCRC_32** -- CRC checksum functions for data integrity verification.
- **AxoBytesToInt, AxoBytesToDint** -- byte-to-integer conversion functions with endianness support.

[!INCLUDE [AxoStringBuilder](AxoStringBuilder.md)]

[!INCLUDE [AxoCRC](AxoCRC.md)]
