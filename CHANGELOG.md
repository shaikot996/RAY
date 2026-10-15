# Changelog

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
