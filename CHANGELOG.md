# Changelog

## 1.3.0 — 2026-10-25

- Add fully symbolic, arbitrary d+n crossed doubly warped curvature with A(y) and B(x), reproducing arXiv:2512.19793 Appendix C (C.20-C.26) in d=4, n=6.
- New user-selectable Covariant or Partial derivative form. The partial form explicitly retains connection terms and inverse-metric contractions.
- Add visible hat and tilde metric, Ricci, Einstein, Laplace-Beltrami and covariant Hessian notation with copy/paste-preserving interpretation boxes.
- Provide all Ricci and Einstein external, internal and mixed tensors, plus Ricci scalar, without requiring component dimensions.
- Add RAYUpdateStandalone[] to download the latest SHA256-verified GitHub Release standalone with a local backup, never executing fetched code.
- Confirm all 35 new formula, math-type and independent 4D curved double warp tests in Wolfram kernel; previous regression and benchmarks retained.



## 1.2.1 — 2026-10-15

- Prevent the time-only symbolic warp API from silently discarding x-dependence, including A[t,x], A[t] Sin[x] and x-dependent lapse factors. Constant symbolic coefficients must be declared through the "Parameters" option.
- Add exact covariant warped-product curvature for coordinate-dependent explicit base metrics with symbolic fiber dimensions.
- Add abstract covariant d+n Ricci and Weyl rescaling formulas, keeping partial derivatives, covariant Hessians, Laplace-Beltrami and gradient norms distinct.
- Improve intrinsic Ricci tilde notation; use partial derivative fractions by default, with optional time-dot display.
- Independently cross-check full 3D/4D Ricci and a 3D Weyl transformation, together with all previous regression suites: 278/278 Wolfram tests pass.



## 1.2.0 — 2026-10-15

- Introduce exact dimension-independent d+n time-warped Ricci/Einstein formulas with symbolic d,n.
- Add variable lapse, arbitrary reference curvature (including non-Einstein intrinsic Ricci tensor) and any number of warped spatial blocks.
- Derive symbolic Einstein equations for homogeneous energy density, block pressures and cosmological constant without losing intrinsic anisotropy.
- Add a checked bridge from symbolic descriptors to explicit-component geometry after integer specialization.
- Verify 82 new analytical, validation and explicit-geometry tests, alongside the prior 150 regressions and benchmarks.
- Document assumptions and full examples in SYMBOLIC_DN_GUIDE.md.



## 1.1.2 — 2026-10-15

- Display Ricci and Einstein tensors as labeled nonzero coordinate components by default rather than oversized matrices.
- Add handwritten dot notation for time derivatives and partial-derivative fraction notation for internal metric functions.
- Keep `RAYRicci["dd","Matrix"]` and `RAYEinstein["dd","Matrix"]` for full matrix output.
- Update `expr // RAW` to Mathematica notebook-style input notation (`A'[t]` instead of `Derivative[1][A][t]`), preserving exact expressions via InterpretationBox.
- Add `RAYReadable` and `RAYReadableTensor` for explicit readable formatting, plus the general output improvements.
- Run 35 handwritten tests, 35 formatting tests, 18 regressions and 62 functional benchmarks: 150/150 pass in Wolfram Language 15.



## 1.1.1 — 2026-10-15

- Abstract tensors, abstract indices, covariant derivatives and internal dummy indices now typeset automatically in Wolfram notebooks using editable InterpretationBox output.
- Added postfix `expr // RAW` for Wolfram Language InputForm syntax and `expr // RAYPretty` for TraditionalForm.
- Converted symbolic metric descriptors to proper upper/lower abstract indices.
- Added 35 Wolfram-kernel regression cases for boxes, input roundtrips and RAW presentation; 115/115 tests passed overall.
- Added notebook output example and one-file distribution update.



## 1.1.0 — 2026-10-15

- Added one-file `RAYStandalone.wl` distribution.
- Added raw expression access for complete RAY function calls.
- Added explicit algebraic matter Lagrangian variation and Hilbert stress tensors, scalar/Maxwell helpers.
- Added Einstein-equation construction, multi-IC numerical solving, customized plots, three-step solver wizard.
- Added explicit covariant derivative and warped/block diagonal metric support.
- Added symbolic tensor algebra, declared slot symmetries, dummy-index canonicalization, contraction and Bianchi identities.
- Added user tensor components and abstract covariant derivative to explicit component conversion.
- Passed 62 timed benchmark cases and 18 regression cases in Wolfram Language 15 (80/80).
- See RELEASE_NOTES_v1.1.0.md and DEVELOPMENT_API.md for examples and scope limitations.



All notable changes to RAY will be documented in this file.

## [1.0.0] - 2026-10-06

### Status

Initial public **development release**. The package is usable, but the API is not yet considered frozen.

### Added

- arbitrary-dimensional explicit metric definitions;
- support for signatures carried directly by the metric;
- Christoffel symbols;
- Riemann, Ricci, Einstein, and Weyl tensors;
- mixed-index tensor configurations;
- nonzero-component tables;
- Ricci, Kretschmann, Ricci-squared, and Weyl-squared invariants;
- normalized non-null congruences;
- covariant derivatives of the congruence;
- expansion, acceleration, shear, and vorticity;
- Raychaudhuri equation terms and residual;
- internal kinematical consistency checks;
- raw symbolic output through `RAYRaw`;
- built-in help and report commands;
- initial regression-test suite;
- GitHub-ready documentation and contribution infrastructure.
