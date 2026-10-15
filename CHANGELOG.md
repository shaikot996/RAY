# Changelog

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
