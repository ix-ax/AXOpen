# CRC Checksum Functions

AXOpen.Utils provides three CRC (Cyclic Redundancy Check) functions for verifying data integrity. Each function accepts a `STRING[254]` input and returns a checksum of the corresponding width.

## Variants

| Function | Return type | Polynomial | Description |
|---|---|---|---|
| `AxoCRC_8` | `BYTE` | Standard CRC-8 | 8-bit checksum suitable for short messages and simple error detection. |
| `AxoCRC_16` | `WORD` | `0x1021` | 16-bit checksum (CRC-CCITT). Widely used in communication protocols. |
| `AxoCRC_32` | `DWORD` | `0x04C11DB7` | 32-bit checksum (CRC-32). Provides strong error detection for larger data. |

## Usage

### CONTROLLER

#### Calculating checksums

[!code-smalltalk[](../../showcase/app/src/utils/UtilsShowcase.st?name=CrcUsage)]

All three functions share the same calling convention: pass the string to check and receive the checksum value. Use the appropriate variant based on the level of error detection your application requires.

## Byte Conversion Functions

The library also includes two byte-to-integer conversion functions:

| Function | Description |
|---|---|
| `AxoBytesToInt` | Converts 2 bytes (`inByte0`, `inByte1`) to `DINT` with endianness control via `inFormat`. |
| `AxoBytesToDint` | Converts 4 bytes (`inByte0` through `inByte3`) to `DINT` with endianness control via `inFormat`. |

These are useful when parsing raw byte data from communication buffers or sensor readings where byte order matters.
