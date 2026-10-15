# RAY v1.2.1 — Covariant warped geometry and trustworthy derivative notation

Release date: 2026-10-15.

## Correctness fix (important)

Previous RAYGeneralWarpedMetric / RAYWarpedBlocks expressions assumed *time-dependent warp factors only*, but silently accepted inputs such as A[t,x]. This was mathematically unsafe: the time-only curvature formulas do **not** include spatial derivatives and could return incorrect results. **Now these calls reject multi-coordinate-dependent function inputs** and recommend the new coordinate-covariant API. Bare undeclared symbols are also rejected (for example A[t] Sin[x]); declare actual constant parameters explicitly with "Parameters"->{c1,c2}. The other time-only functionality remains intact.

## New exact covariant geometry

- RAYAbstractWarpedCurvature[d,n,B] returns dimension-independent d+n warped-product Ricci tensor blocks and scalar with **abstract base** covariant Hessians and Laplace-Beltrami operators. Both dimensions remain symbolic; the base metric and intrinsic curvature are left unspecified.
- RAYCovariantWarpedMetric[name,coords,baseMetric,n,B] computes exact warped geometry with **general coordinate-dependent base metric**, including time/spatial dependence A[t,x] and B[t,x] and a symbolic fiber dimension n. It actually calculates the Christoffel correction to the covariant Hessian: nabla_a nabla_b B = partial_a partial_b B - Gamma^c_(ab) partial_c B. It computes full base Ricci, fiber Ricci, Ricci scalar, Einstein tensor blocks, covariant Laplacian and gradient norm.
- RAYWeylRescale[d,omega] adds the standard exact arbitrary-dimensional conformal Ricci identities, with **base covariant** operators.
- RAYPartialD[expr,index], RAYNabla[index,expr], RAYCovariantHessian, RAYCovariantBox and RAYGradientNorm have **distinct notation and semantics**. An abstract covariant derivative is not automatically evaluated as a coordinate partial derivative.

## Improved handwritten output

- Intrinsic RAYTensor["InternalRicci",...] and RAYIntrinsicScalar["Internal"] now display with properly marked tilde curvature notation; external and fiber symbols are distinguishable.
- RAYReadable[expr] uses **partial-derivative fractions by default**. Set "DerivativeNotation"->"Dot" for traditional time-dot display. Underlying expressions and RAW are unchanged.
- Mathematica front-end boxes are copyable as original Wolfram expressions via InterpretationBox; test coverage checks their round trips. Headless kernel box testing does not substitute for checking the local GUI.

## Tested in Wolfram Language kernel

- 46/46 new covariant/format/safety tests. This includes full comparisons to independently computed coordinate Ricci tensors in 3D and 4D with curved internal S^2 and nonzero mixed gradients, and 3D independent Weyl curvature tests.
- 82/82 prior symbolic d+n checks.
- 70/70 notebook-formatting regressions.
- 62/62 benchmark cases.
- 18/18 original and development regression cases.
- **278/278 tests passed**.

The explicit coordinate-based base must have an integer number of coordinates; the internal fiber dimension may remain symbolic. For fully symbolic d and n, use RAYAbstractWarpedCurvature, which keeps base covariant derivatives formal.

## Scope limitations

The new formula covers ordinary warped products G_ab=g_ab(x), G_mn=exp(2B(x))h_mn(y), with h_mn independent of base coordinates. Its base metric g_ab can be arbitrary and off-diagonal, but the fiber shares a single warp B and there are no mixed base/fiber metric components. This is **not** an arbitrary generic D-dimensional metric engine. The declared intrinsic fiber geometry must be physically compatible with any metric provided later.

## Installation

Download the standalone asset from https://github.com/shaikot996/RAY/releases/latest then restart Mathematica and evaluate:

~~~mathematica
Get[FileNameJoin[{$HomeDirectory,"Downloads","RAYStandalone.wl"}]];
RAYVersion
~~~

Expected version: "1.2.1". See Examples/RAY_CovariantWarped_Example.wl for notebook chunks.
