# RAY standalone — Quick start

The **RAYStandalone.wl** file is the complete RAY Mathematica/Wolfram Language package bundled into one file. It is a source-based Wolfram package, not a Windows executable. You do not need the rest of the repository for this installation method.

## Download

Open https://github.com/shaikot996/RAY/releases/latest and under **Assets** download:

- **RAYStandalone.wl** — one file, ready to load in Mathematica
- **RAY-vX.Y.Z-standalone.zip** — the same file with this guide and version-specific release notes
- **SHA256SUMS.txt** — checksums for validating downloaded assets

## Run on Windows

1. Save the standalone file in your Downloads folder.
2. Start Mathematica, and restart the kernel if an older RAY version was loaded.
3. Evaluate this input cell, changing YourUser to your Windows username:

~~~mathematica
Get["C:\\Users\\YourUser\\Downloads\\RAYStandalone.wl"];

RAYVersion
RAYHelp[]
~~~

## Linux and macOS

~~~mathematica
Get[FileNameJoin[{$HomeDirectory, "Downloads", "RAYStandalone.wl"}]];

RAYVersion
~~~

## First symbolic d+n test

~~~mathematica
ClearAll[d,n,t,A,B];

model=RAYGeneralWarpedMetric[d,n,A[t],B[t],
  "Time"->t, "InternalGeometry"->"General"];

model["TotalDimension"]          (* d+n *)
model["RicciScalar"] // RAYReadable
model["RicciTimeTime"] // RAYReadable
~~~

## For package developers

Use the complete repository with the Kernel directory and PacletInfo.wl if you want to edit individual RAY modules, run the test suites, or use Needs["RAY`"]. Loading the standalone file via Get does not require paclet installation.

Official package home: https://github.com/shaikot996/RAY

Historical releases are pinned to a tag. The stable *latest* download URL always points at the newest published release:

https://github.com/shaikot996/RAY/releases/latest/download/RAYStandalone.wl
