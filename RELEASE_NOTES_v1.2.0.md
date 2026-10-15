# RAY v1.2.0 — Exact symbolic d+n warped products

Release date: 2026-10-15.

## Major addition

RAY now handles symbolic spacetime dimensions d and n without substituting integer values in the metric:

- RAYGeneralWarpedMetric[d,n,A[t],B[t],opts] derives the exact time-time Ricci component, spatial Ricci tensor blocks, Ricci scalar, Einstein time-time component and Einstein spatial tensor blocks.
- RAYWarpedBlocks supports an arbitrary number of warped spatial factors with symbolic block dimensions.
- Time-dependent lapse L(t) and intrinsically curved reference geometries are supported, including completely unspecified intrinsic Ricci tensors, Einstein manifolds and constant curvature.
- RAYWarpedFieldEquations derives exact G_MN+Lambda g_MN = kappa T_MN equations for a homogeneous comoving fluid with independent block pressures. Full tensor constraints are preserved when a spatial reference block is not Einstein.
- RAYWarpedToComponents specializes dimension values and reference metric components into the existing RAY explicit metric engine. RAYWarpedReport displays the symbolic results in human-readable notation.

This is **a true symbolic-dimension curvature computation for time-orthogonal warped products**. It is not a generic Einstein tensor engine for an arbitrary metric matrix of symbolic size.

## Example

~~~mathematica
ClearAll[d,n,t,A,B];

g=RAYGeneralWarpedMetric[d,n,A[t],B[t],
 "Time"->t,
 "ExternalGeometry"->"Flat",
 "InternalGeometry"->"General"];

g["TotalDimension"]    (* d+n *)
g["RicciScalar"] // RAYReadable
g["Blocks"][[2,"RicciTensor"]] // RAYPretty
RAYWarpedReport[g]
~~~

See SYMBOLIC_DN_GUIDE.md for the derived Ricci/Einstein formulas, assumptions, field equations, curved manifolds, arbitrary multi-block examples and explicit specialization.

## Tested in a Wolfram Language 15 kernel

| Suite | Passed |
|---|---:|
| New d+n / warped Einstein checks | 82/82 |
| Original geometry regression | 7/7 |
| Matter/numeric development regression | 11/11 |
| Timed explicit/symbolic benchmarks | 62/62 |
| Notebook presentation/RAW regression | 35/35 |
| Handwritten curvature/RAW regression | 35/35 |
| **Total** | **232/232** |

Checks include exact symbolic identities with unassigned d,n; generalized lapse, Einstein/constant-curvature/non-Einstein reference geometry, 3-factor geometry and Einstein equations; plus agreement with direct explicit 3D and 5D calculations (flat and spherical internal metrics).

## Installation

Download RAYStandalone.wl from the repository main branch, restart the Wolfram/Mathematica kernel, and run:

~~~mathematica
Get["C:\\Users\\YourUser\\Downloads\\RAYStandalone.wl"];
RAYVersion
~~~

Expected output: "1.2.0". To install as an application/paclet, download/update the entire repository including Kernel/RAYSymbolicWarped.wl and run Needs["RAY`"] after installing in a recognized Mathematica application directory.

## Important scope limitations

- Reference spatial metrics are time independent; warps and lapse depend on time only.
- No shift/inter-block cross-terms, no symbolic-dimension arbitrary component arrays and no automatic lower-dimensional Einstein-frame reduction.
- An arbitrary non-Einstein reference metric retains its **full intrinsic Ricci tensor**, not just its scalar trace.
- The explicit bridge verifies matrix dimensions; the user must check that supplied metric components really obey any claimed constant-curvature or Einstein condition.
- The GitHub Actions default job checks source/repository consistency. Wolfram evaluation tests were executed separately in an actual Wolfram kernel. Interactive graphical front-end rendering remains a separate check.
