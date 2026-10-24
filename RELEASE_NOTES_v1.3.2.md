# RAY v1.3.2 — canonical RAY.wl and corrected updater

## Fixes

- **RAY.wl** is the primary complete standalone download; no additional source modules are required.
- **RAYUpdate[]** downloads the latest RAY.wl to **$UserBaseDirectory/Applications/RAY.wl**, checking the official release checksum first.
- **RAYUpdateStandalone[]** remains as a backward-compatible alias, installing the same RAY.wl file.
- The old code hashed a Wolfram expression containing a list of bytes. The new code hashes the raw bytes with **FileHash[file,"SHA256","HexString"]**, matching GNU sha256sum.
- The update creates an existing-file backup as **RAY.wl.previous** and refuses an invalid checksum.
- The release pipeline creates RAY.wl, the versioned ZIP and SHA256SUMS.txt.
- RAYStandalone.wl is kept in the repository for development compatibility, not as the primary release asset.

## Recovering from the old updater

Download https://github.com/shaikot996/RAY/releases/latest/download/RAY.wl

~~~mathematica
Get[FileNameJoin[{$HomeDirectory,"Downloads","RAY.wl"}]];
RAYVersion
~~~

To install the one file permanently, copy it to
FileNameJoin[{$UserBaseDirectory,"Applications","RAY.wl"}]
and restart the Mathematica kernel. Afterwards:

~~~mathematica
Needs["RAY`"];
RAYVersion
RAYUpdate[]
~~~

## Verification

The raw-file SHA256 fix was verified on a Wolfram kernel with the known vector abc: the FileHash result matches SHA256, while hashing the list from BinaryReadList yields a different result. Existing curvature and warped geometry tests are retained; new updater regression tests cover file hashes, checksum selection, and API availability.
