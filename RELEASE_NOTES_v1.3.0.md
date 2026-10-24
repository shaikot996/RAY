# RAY 1.3.0 — Covariant/partial symbolic crossed double warps

## Key new capability

This release adds a pure symbolic d+n crossed doubly warped geometry:
ds² = exp(2 A(y)) hat[g]_mu nu(x) dx^mu dx^nu
    + exp(2 B(x)) tilde[g]_mn(y) dy^m dy^n.
Both d and n remain formal dimensions and no metric component matrix is required. This is the metric class in Appendix C of [arXiv:2512.19793v2](https://arxiv.org/abs/2512.19793).

RAYCrossWarpedGeometry returns external/internal/mixed Ricci tensors, the total Ricci scalar, and external/internal/mixed Einstein tensors. In d=4,n=6, these reproduce Appendix C equations (C.20)–(C.26).

## User-selectable differential-geometry notation

- DerivativeForm -> "Covariant" uses two distinguished reference Levi-Civita derivatives (hat and tilde), their covariant Hessians, Laplace-Beltrami operators and exact squared gradient contractions.
- DerivativeForm -> "Partial" uses partial derivatives and retains Gamma connection terms, as well as the inverse-reference-metric contraction required by the box operator. It is NOT a flat-space replacement.
- RAYCrossToCovariant converts the resulting partial-plus-connection expression exactly to covariant notation.
- All symbolic operators preserve copy/paste/re-evaluation via InterpretationBox.

## Worked example

~~~mathematica
ClearAll[d,n,A,B];
g=RAYCrossWarpedGeometry[d,n,A,B,
 "DerivativeForm"->"Covariant"];

g["RicciExternal"] // RAYPretty
g["RicciInternal"] // RAYPretty
g["RicciMixed"] // RAYPretty
g["RicciScalar"] // RAYPretty
g["EinsteinExternal"] // RAYPretty
g["EinsteinInternal"] // RAYPretty
RAYCrossWarpedReport[g]

p=RAYCrossWarpedGeometry[d,n,A,B,
 "DerivativeForm"->"Partial"];
Expand[RAYCrossToCovariant[p["RicciExternal"]]-g["RicciExternal"]]
(* 0 *)
~~~

## Latest downloadable standalone

Each version automatically publishes the single-file RAYStandalone.wl, a versioned ZIP and SHA256SUMS.txt through GitHub Actions. The stable URL remains:

https://github.com/shaikot996/RAY/releases/latest/download/RAYStandalone.wl

Inside Mathematica, run RAYUpdateStandalone[] to download the latest release to Downloads with SHA256 validation and a .previous backup. This opt-in command never executes downloaded code. Restart the kernel and load the updated file after download.

## Verification

- 35 new tests cover paper equations C.20-C.26, arbitrary symbolic dimensions, exact covariant/partial representation equivalence, mixed tensors, box rendering round-trip, and an independent 4D direct curvature computation with curved internal S², nontrivial external reference curvature and nonzero mixed Ricci.
- The existing 278 test cases cover time-dependent symbolic d+n geometry, coordinate-dependent base warped products, Weyl rescaling, component geometry, numerical features, formatting and benchmarks.
- The suite is 313 test cases across 8 test files. All 313/313 tests passed in the Wolfram Language kernel against the v1.3.0 standalone candidate.

## Scope

This module gives exact *geometrical* Ricci and Einstein identities for the declared crossed metric; it is not a flux-dependent Type IIB field-equation solver. The warp factors must live on opposite coordinate factors as assumed. Unlike the metric component engine, it does not produce every Riemann/Weyl component in unassigned symbolic dimension.
