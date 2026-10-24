# RAY: one-file installation

Download: https://github.com/shaikot996/RAY/releases/latest/download/RAY.wl

RAY.wl is the complete Wolfram Language package. No compilation or additional modules required.

## Load directly

Save RAY.wl to Downloads:

~~~mathematica
Get[FileNameJoin[{$HomeDirectory,"Downloads","RAY.wl"}]];
RAYVersion
RAYHelp[]
~~~

## Install for Needs (Windows, Linux, macOS)

~~~mathematica
src=FileNameJoin[{$HomeDirectory,"Downloads","RAY.wl"}];
dir=FileNameJoin[{$UserBaseDirectory,"Applications"}];
If[!DirectoryQ[dir],CreateDirectory[dir,CreateIntermediateDirectories->True]];
CopyFile[src,FileNameJoin[{dir,"RAY.wl"}],OverwriteTarget->True];
~~~

Restart kernel and run:

~~~mathematica
Needs["RAY`"];
RAYVersion
~~~

Future updates:

~~~mathematica
RAYUpdate[]
~~~

RAYUpdateStandalone[] remains an older command name for the same verified updater.
Existing installations are backed up to RAY.wl.previous.
If the older updater reports a SHA256 mismatch, install the RAY.wl release file manually once using the first two sections.

## Test general d+n geometry

~~~mathematica
ClearAll[d,n,t,A,B];
g=RAYGeneralWarpedMetric[d,n,A[t],B[t],
 "Time"->t,"InternalGeometry"->"General"];
g["TotalDimension"]
g["RicciScalar"]//RAYReadable
~~~
