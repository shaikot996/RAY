# Crossed doubly warped metrics — RAY v1.3.0

Based on Appendix C, equations (C.20)–(C.26), of [arXiv:2512.19793](https://arxiv.org/abs/2512.19793). RAY generalizes the formulas from 4+6 to arbitrary symbolic dimensions d+n:

\[
ds^2=e^{2A(y)}\widehat g_{\mu\nu}(x)dx^\mu dx^\nu
+e^{2B(x)}\widetilde g_{mn}(y)dy^m dy^n.
\]

A depends only on internal coordinates y; B depends only on external coordinates x. Both reference metrics are arbitrary, block diagonal with respect to one another, and independent of the opposite factor. This is distinct from the time-only double warp supported by RAYGeneralWarpedMetric.

## Fully symbolic covariant form

~~~mathematica
ClearAll[d,n,A,B];

g=RAYCrossWarpedGeometry[d,n,A,B,
 "DerivativeForm"->"Covariant"];

g["TotalDimension"]                   (* d+n *)
g["RicciExternal"] // RAYPretty
g["RicciInternal"] // RAYPretty
g["RicciMixed"] // RAYPretty
g["RicciScalar"] // RAYPretty
g["EinsteinExternal"] // RAYPretty
g["EinsteinInternal"] // RAYPretty
g["EinsteinMixed"] // RAYPretty

RAYCrossWarpedReport[g]
~~~

Hat derivatives act on the external reference metric; tilde derivatives act on the internal reference metric. Neither is automatically treated as a partial derivative.

## Exact partial plus Christoffel form

~~~mathematica
p=RAYCrossWarpedGeometry[d,n,A,B,
 "DerivativeForm"->"Partial"];
p["RicciExternal"] // RAYPretty
p["RicciInternal"] // RAYPretty

Expand[RAYCrossToCovariant[p["RicciExternal"]]-
 g["RicciExternal"]]    (* 0 *)
~~~

The partial form retains the Christoffel term in the Hessian and the inverse metric contraction in the Laplace–Beltrami operator. It never replaces covariant derivatives with bare partials.

## Reproduce the paper

~~~mathematica
paper=RAYCrossWarpedGeometry[4,6,A,B];
paper["EinsteinExternal"] // RAYPretty  (* C.20 *)
paper["EinsteinInternal"] // RAYPretty  (* C.21 *)
paper["EinsteinMixed"] // RAYPretty     (* C.22 *)
paper["RicciExternal"] // RAYPretty    (* C.23 *)
paper["RicciInternal"] // RAYPretty    (* C.24 *)
paper["RicciMixed"] // RAYPretty       (* C.25 *)
paper["RicciScalar"] // RAYPretty      (* C.26 *)
~~~

The mixed component has coefficient d+n-2 (eight in 4+6). It is not dropped.

## Updating your local WL file

GitHub automatically attaches RAYStandalone.wl, a versioned ZIP and SHA256SUMS.txt to every new version through the repository release workflow. Use the permanent link:

https://github.com/shaikot996/RAY/releases/latest/download/RAYStandalone.wl

Or inside Mathematica:

~~~mathematica
RAYUpdateStandalone[]
(* restart kernel before activating updated code *)
Get[FileNameJoin[{$HomeDirectory,"Downloads","RAYStandalone.wl"}]];
RAYVersion
~~~

The updater is explicitly invoked (no silent network access), validates the published SHA256 checksum, saves a backup with suffix .previous and never executes code downloaded from the Internet.

See Examples/RAY_AppendixC_CrossWarped.wl for runnable notebook chunks and Tests/RAY_CrossWarped_Tests.wl for direct component cross-checks. This module computes geometric curvature/Einstein tensors, not Type IIB flux field equations. For general coordinate-component calculations, use the explicit RAY metric engine.
